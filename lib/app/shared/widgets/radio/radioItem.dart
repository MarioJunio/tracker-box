import 'package:flutter/material.dart';
import 'package:tracker_box/app/shared/utils/colors.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioModel.dart';

class RadioItem extends StatefulWidget {
  final RadioModel _model;
  final bool active;
  final bool hasRightBorder;

  RadioItem(
    this._model, {
    this.active = false,
    this.hasRightBorder,
  });

  @override
  _RadioItemState createState() => _RadioItemState();
}

class _RadioItemState extends State<RadioItem> {
  var context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: new Center(
        child: new Text(
          widget._model.buttonText,
          style: new TextStyle(
            color: _textColor(),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      decoration: _buildBoxDecoration,
    );
  }

  Color _textColor() {
    if (widget._model.isSelected) {
      return Colors.white;
    } else if (widget.active) {
      return Theme.of(context).primaryColor;
    } else {
      return ColorsUtil.lightGrey;
    }
  }

  Decoration get _buildBoxDecoration {
    switch (widget._model.location) {
      case RadioModelLocation.first:
        return new BoxDecoration(
            color: _color,
            border: Border(
              right: widget.hasRightBorder
                  ? _buildBorderSide()
                  : _buildBorderSideTransparent(),
            ));

      case RadioModelLocation.middle:
        return new BoxDecoration(
          color: _color,
          border: Border(
            left: _buildBorderSide(),
            right: _buildBorderSide(),
          ),
        );

      default:
        return new BoxDecoration(
          color: _color,
        );
    }
  }

  BorderSide _buildBorderSide() {
    return BorderSide(
      width: 1,
      color: _middleBorderColor,
    );
  }

  BorderSide _buildBorderSideTransparent() {
    return BorderSide(
      width: 0,
      color: Theme.of(context).primaryColor,
    );
  }

  Color get _middleBorderColor {

    if (widget.hasRightBorder) {

      if (widget.active) {
        return Theme.of(context).primaryColor;
      } else {
        return ColorsUtil.lightGrey;
      }
    } 

    return Theme.of(context).primaryColor;
  }

  Color get _color {
    if (widget._model.isSelected) {
      return widget.active
          ? Theme.of(context).primaryColor
          : ColorsUtil.lightGrey;
    } else {
      return Colors.transparent;
    }
  }
}
