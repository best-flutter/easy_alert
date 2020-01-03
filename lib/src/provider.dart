import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// Supply text for alert, cancel and ok
/// 为Alert提供文字，一般为取消和确认
class AlertConfig {
  final String ok;
  final String cancel;
  const AlertConfig({
    this.ok: "OK",
    this.cancel: "CANCEL",
  });
}

class AlertProvider extends StatefulWidget {
  final Widget child;

  final AlertConfig config;

  final TextDirection textDirection;

  AlertProvider(
      {this.child,
      this.config: const AlertConfig(),
      this.textDirection = TextDirection.ltr});

  static AlertConfig getConfig(BuildContext context) {
    final _AlertScope scope = context.inheritFromWidgetOfExactType(_AlertScope);
    return scope?.config;
  }

  static AlertConfig getToaster(BuildContext context) {
    final _AlertScope scope = context.inheritFromWidgetOfExactType(_AlertScope);
    return scope?.config;
  }

  static ToastManager getManager(BuildContext context) {
    final _AlertScope scope = context.inheritFromWidgetOfExactType(_AlertScope);

    return scope?.manager;
  }

  @override
  State<StatefulWidget> createState() {
    return new _AlertProviderState();
  }
}

enum ToastPosition {
  bottom,
  center,
  top,
}

enum ToastDuration {
  short,
  long,
}

class Toast {
  final String message;
  final ToastPosition position;
  final ToastDuration duration;

  Toast({this.position, this.message, this.duration});
}

class ToastView extends StatelessWidget {
  final String text;
  final TextDirection textDirection;

  ToastView({this.text, this.textDirection});

  @override
  Widget build(BuildContext context) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(3.0),
      child: new Container(
        color: Colors.black54,
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: new Text(
            text,
            textDirection: textDirection,
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 13.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

abstract class ToastManager {
  void showToast(
    String message, {
    ToastPosition position,
    ToastDuration duration: ToastDuration.short,
  });
}

class _AlertProviderState extends State<AlertProvider>
    with SingleTickerProviderStateMixin
    implements ToastManager {
  List<Toast> _queue = [];
  Toast _current;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void showToast(
    String message, {
    ToastPosition position,
    ToastDuration duration,
  }) {
    Toast toast =
        new Toast(message: message, position: position, duration: duration);
    if (_current != null) {
      _queue.add(toast);
    } else {
      _show(toast);
    }
  }

  void _show(Toast toast) {
    _current = toast;
    _controller.animateTo(1.0,
        curve: Curves.ease, duration: new Duration(milliseconds: 300));
    new Future.delayed(new Duration(
            milliseconds:
                _current.duration == ToastDuration.long ? 3000 : 1000))
        .whenComplete(_hide);
    setState(() {});
  }

  void _hide() {
    _controller
        .animateTo(0.0,
            curve: Curves.ease, duration: new Duration(milliseconds: 300))
        .whenComplete(() {
      if (_queue.length > 0) {
        _show(_queue.removeAt(0));
        return;
      } else {
        _current = null;
        setState(() {});
      }
    });
  }

  void _next(_) {}

  @override
  void initState() {
    _controller = new AnimationController(vsync: this);
    _controller.duration = new Duration(milliseconds: 300);
    _animation = new Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  AlignmentGeometry _getAlignment() {
    switch (_current.position) {
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
      case ToastPosition.top:
        return Alignment.topCenter;
    }
    return Alignment.center;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      new _AlertScope(
        manager: this,
        config: widget.config,
        child: widget.child,
      )
    ];
    if (_current != null) {
      children.add(
        new Padding(
            padding: new EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 10.0),
            child: new Align(
              child: new AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget w) {
                    return new Opacity(
                      opacity: _animation.value,
                      child: new IgnorePointer(
                        child: new ToastView(
                          text: _current.message,
                          textDirection: widget.textDirection,
                        ),
                      ),
                    );
                  }),
              alignment: _getAlignment(),
            )),
      );
    }

    return new Material(
        child: new Stack(
      textDirection: TextDirection.ltr,
      children: children,
    ));
  }
}

class _AlertScope extends InheritedWidget {
  const _AlertScope({Key key, this.config, this.manager, Widget child})
      : super(key: key, child: child);

  final AlertConfig config;
  final ToastManager manager;

  @override
  bool updateShouldNotify(_AlertScope old) {
    return config != old.config;
  }
}
