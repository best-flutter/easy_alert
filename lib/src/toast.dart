import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      borderRadius: new BorderRadius.circular(5.0),
      child: new Container(
        color: Colors.black54,
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(20, 8, 20, 8.0),
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
