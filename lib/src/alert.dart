import 'dart:async';

import 'package:easy_alert/src/picker.dart';
import 'package:easy_alert/src/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          return CupertinoAlertDialog(
            title: Text(title),
            content: content != null
                ? new Padding(
                    padding: new EdgeInsets.only(top: 10),
                    child: Text(content),
                  )
                : null,
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(cancel),
                onPressed: () {
                  completer.complete(Alert.CANCEL);
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text(ok),
                onPressed: () {
                  completer.complete(Alert.OK);
                  Navigator.pop(context);
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

    if (title == null && content != null) {
      title = content;
    }

    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (c) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: content != null
                ? new Padding(
                    padding: new EdgeInsets.only(top: 10),
                    child: Text(content),
                  )
                : null,
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(ok),
                onPressed: () {
                  completer.complete(Alert.OK);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });

    return completer.future;
  }

  static Future<int> pick(BuildContext context,
      {List<String> values, int index}) {
    Completer<int> completer = new Completer<int>();
    showModalBottomSheet(
        context: context,
        builder: (c) {
          return new Picker(
            values: values,
            index: index,
            onSelectedItemChanged: (int index) {
              completer.complete(index);
            },
            onCancel: () {
              completer.completeError(null);
            },
          );
        }).then((var value) {
      if (value == null) {
        completer.completeError(null);
      }
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
