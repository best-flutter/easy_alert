import 'package:easy_alert/src/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  @required
  final List<String> values;

  @required
  final int index;

  @required
  final ValueChanged<int> onSelectedItemChanged;
  @required
  final VoidCallback onCancel;

  /// ok test
  final String ok;

  /// cancel text
  final String cancel;

  Picker(
      {this.values,
      this.index,
      this.onSelectedItemChanged,
      this.onCancel,
      this.ok,
      this.cancel})
      : assert(onSelectedItemChanged != null),
        assert(values != null),
        assert(index != null);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  FixedExtentScrollController _controller;
  int _index;

  @override
  void initState() {
    _controller = new FixedExtentScrollController(initialItem: widget.index);
    _index = widget.index;
    super.initState();
  }

  @override
  void didUpdateWidget(Picker oldWidget) {
    if (widget.index != oldWidget.index) {
      _index = widget.index;
      _controller = new FixedExtentScrollController(initialItem: widget.index);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    AlertConfig config = AlertProvider.getConfig(context);
    assert(config != null, "A `AlertProvider` must be supplied");
    String ok = widget.ok;
    String cancel = widget.cancel;
    if (ok == null) ok = config.ok;
    if (cancel == null) cancel = config.cancel;
    return new Container(
      height: 300,
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new InkWell(
                child: new Padding(
                  padding: new EdgeInsets.all(10),
                  child: new Text(cancel),
                ),
                onTap: () {
                  widget.onCancel();
                },
              ),
              new InkWell(
                child: new Padding(
                  padding: new EdgeInsets.all(10),
                  child: new Text(
                    ok,
                    style: new TextStyle(color: Colors.blueAccent),
                  ),
                ),
                onTap: () {
                  widget.onSelectedItemChanged(_index);
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          new Expanded(
              child: CupertinoPicker(
            scrollController: _controller,
            itemExtent: 35,
            backgroundColor: Colors.white,
            onSelectedItemChanged: (int index) {
              _index = index;
            },
            children: widget.values.map((d) => new Text(d)).toList(),
          ))
        ],
      ),
    );
  }
}
