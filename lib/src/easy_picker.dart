import 'package:easy_alert/src/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EasyPicker extends StatefulWidget {
  @required
  final Widget child;

  @required
  final List<String> values;

  @required
  final int index;

  @required
  final ValueChanged<int> onSelectedItemChanged;
  @required
  final VoidCallback onCancel;

  EasyPicker(
      {this.child,
      this.values,
      this.index,
      this.onSelectedItemChanged,
      this.onCancel});

  @override
  State<StatefulWidget> createState() {
    return new _EasyPickerState();
  }
}

class _EasyPickerState extends State<EasyPicker> {
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: widget.child,
      onTap: () async {
        try {
          int index = await Alert.pick(context,
              values: widget.values, index: widget.index);
          if (widget.onSelectedItemChanged != null) {
            widget.onSelectedItemChanged(index);
          }
        } catch (e) {
          if (widget.onCancel != null) {
            widget.onCancel();
          }
        }
      },
    );
  }
}
