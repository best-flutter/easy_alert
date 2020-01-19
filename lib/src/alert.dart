import 'dart:async';

import 'package:easy_alert/src/picker.dart';
import 'package:easy_alert/src/provider.dart';
import 'package:easy_alert/src/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Option<T> {
  final String label;
  final T value;

  const Option(this.label, this.value);

  static String getLabel<T>(List<Option<T>> options, T value) {
    return options
        .firstWhere((Option<T> o) => o.value == value, orElse: () => null)
        ?.label;
  }

  static int getIndex<T>(List<Option<T>> options, T value) {
    return options.indexWhere((Option<T> o) => o.value == value);
  }
}

class Alert {
  static const int OK = 0;
  static const int CANCEL = 1;

  static Future<int> confirm(BuildContext context,
      {String title, String content, String ok, String cancel}) {
    Completer<int> completer = new Completer<int>();
    AlertConfig config = AlertProvider.getConfig(context);
    assert(config != null, "A `AlertProvider` must be supplied");

    if (ok == null || cancel != null) {
      if (ok == null) ok = config.ok;
      if (cancel == null) cancel = config.cancel;
    }
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (c) {
          if (config.useIosStyle) {
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
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(ok),
                  onPressed: () {
                    completer.complete(Alert.OK);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          } else {
            return new AlertDialog(
              title: new Text(title),
              content: content == null ? null : new Text(content),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(cancel),
                  onPressed: () {
                    completer.complete(Alert.CANCEL);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                new FlatButton(
                  child: new Text(ok),
                  onPressed: () {
                    completer.complete(Alert.OK);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          }
        });

    return completer.future;
  }

  static Future<String> input(BuildContext context,
      {String ok, String value, String title = "Please input"}) async {
    AlertConfig config = AlertProvider.getConfig(context);
    assert(config != null, "A `AlertProvider` must be supplied");
    if (ok == null) {
      ok = config.ok;
    }
    TextEditingController controller =
        new TextEditingController(text: value ?? "");
    try {
      var str = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (c) {
            if (config.useIosStyle) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: new Padding(
                  padding: new EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(ok),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(controller.text);
                    },
                  ),
                ],
              );
            } else {
              return new AlertDialog(
                title: new Text(title),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(ok),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(controller.text);
                    },
                  ),
                ],
              );
            }
          });
      if (str == null) {
        throw new Exception("Canceled");
      }
      return str;
    } catch (e) {
      throw e;
    }
  }

  static Future<int> alert(BuildContext context,
      {String title,
      String content,
      String ok,
      bool barrierDismissible: false}) async {
    AlertConfig config = AlertProvider.getConfig(context);
    assert(config != null, "A `AlertProvider` must be supplied");
    if (ok == null) {
      ok = config.ok;
    }

    if (title == null && content != null) {
      title = content;
    }

    try {
      int ret = await showDialog(
          context: context,
          barrierDismissible: barrierDismissible, // user must tap button!
          builder: (c) {
            if (config.useIosStyle) {
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
                      Navigator.of(context, rootNavigator: true).pop(Alert.OK);
                    },
                  ),
                ],
              );
            } else {
              return new AlertDialog(
                title: new Text(title),
                content: content == null ? null : new Text(content),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(ok),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(Alert.OK);
                    },
                  ),
                ],
              );
            }
          });
      if (ret == null) {
        throw new Exception("Canceled");
      }
      return ret;
    } catch (e) {
      throw e;
    }
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
              Navigator.of(context).pop(index);
              completer.complete(index);
            },
            onCancel: () {
              Navigator.of(context).pop(null);
            },
          );
        }).then((var value) {
      if (value == null) {
        completer.completeError(null);
      }
    });
    return completer.future;
  }

  static select<T>(BuildContext context,
      {List<Option<T>> options, T value}) async {
    int index = Option.getIndex<T>(options, value);
    if (index < 0) {
      index = 0;
    }
    index = await pick(context,
        values: options.map((Option o) => o.label).toList(), index: index);
    return options[index].value;
  }

  static void toast(BuildContext context, String message,
      {ToastPosition position: ToastPosition.bottom,
      ToastDuration duration: ToastDuration.short}) {
    ToastManager manager = AlertProvider.getManager(context);
    assert(manager != null, "A `AlertProvider` must be supplied");
    manager.showToast(message, position: position, duration: duration);
  }
}
