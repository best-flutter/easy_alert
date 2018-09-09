library easy_alert;

import 'dart:async';

import 'package:easy_alert/src/provider.dart';
import 'package:flutter/material.dart';

export 'package:easy_alert/src/provider.dart';

class Alert {
  static const int OK = 0;
  static const int CANCEL = 1;

  static Future<int> confirm(BuildContext context,
      {String title, String content, String ok, String cancel}) {
    Completer<int> completer = new Completer<int>();
    if (ok == null || cancel != null) {
      AlertConfig config = AlertProvider.getConfig(context);
      assert(config != null, "A `AlertProvider` must be supplied");
      if (ok == null) ok = config.ok;
      if (cancel == null) cancel = config.cancel;
    }
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (c) {
          return new AlertDialog(
            title: new Text(title),
            content: content == null ? null : new Text(content),
            actions: <Widget>[
              new FlatButton(
                child: new Text(cancel),
                onPressed: () {
                  completer.complete(Alert.CANCEL);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(ok),
                onPressed: () {
                  completer.complete(Alert.OK);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    return completer.future;
  }

  static Future<int> alert(
    BuildContext context, {
    String title,
    String content,
    String ok,
  }) {
    Completer<int> completer = new Completer<int>();
    if (ok == null) {
      AlertConfig config = AlertProvider.getConfig(context);
      assert(config != null, "A `AlertProvider` must be supplied");
      ok = config.ok;
    }
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (c) {
          return new AlertDialog(
            title: new Text(title),
            content: content == null ? null : new Text(content),
            actions: <Widget>[
              new FlatButton(
                child: new Text(ok),
                onPressed: () {
                  completer.complete(Alert.OK);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    return completer.future;
  }

  static void toast(BuildContext context, String message,
      {ToastPosition position: ToastPosition.bottom,
      ToastDuration duration: ToastDuration.short}) {
    ToastManager manager = AlertProvider.getManager(context);
    assert(manager != null, "A `AlertProvider` must be supplied");
    manager.showToast(message, position: position, duration: duration);
  }
}
