import 'package:flutter/material.dart';

import 'package:easy_alert/easy_alert.dart';

void main() => runApp(new AlertProvider(
      child: new MyApp(),
      config: new AlertConfig(ok: "确定", cancel: "取消"),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Easy alert example',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Easy alert example"),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new RaisedButton(
            onPressed: () {
              Alert.alert(context, title: "Hello")
                  .then((_) => Alert.toast(context, "You just click ok"));
            },
            child: new Text("alert"),
          ),
          new RaisedButton(
            onPressed: () {
              Alert.alert(context, title: "Hello", content: "this is a alert")
                  .then((_) => Alert.toast(context, "You just click ok"));
            },
            child: new Text("alert with content"),
          ),
          new RaisedButton(
            onPressed: () {
              Alert.confirm(context, title: "Hello", content: "this is a alert")
                  .then((int ret) =>
                      Alert.toast(context, ret == Alert.OK ? "ok" : "cancel"));
            },
            child: new Text("confirm"),
          ),
          new RaisedButton(
            onPressed: () {
              Alert.toast(context, "center toast",
                  position: ToastPosition.center);
            },
            child: new Text("show center toast"),
          ),
          new RaisedButton(
            onPressed: () {
              Alert.toast(context, "top toast", position: ToastPosition.top);
            },
            child: new Text("show top toast"),
          ),
          new RaisedButton(
            onPressed: () {
              Alert.toast(context,
                  "bottom long toast bottom long toastbottom long toastbottom long toastbottom long toastbottom long toastbottom long toast",
                  position: ToastPosition.bottom, duration: ToastDuration.long);
            },
            child: new Text("show bottom long toast"),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
