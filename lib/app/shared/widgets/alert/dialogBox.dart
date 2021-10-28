import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_box/app/shared/utils/constants.dart';
import 'package:tracker_box/app/shared/widgets/alert/dialogTypes.dart';

class CustomDialogBox extends StatefulWidget {
  final DialogType? type;
  final String? title;
  final String? message;
  final String textPositiveButton;
  final Function? onPressPositiveButton;
  final String textNegativeButton;
  final Function? onPressNegativeButton;

  const CustomDialogBox({
    @required this.type,
    @required this.title,
    this.message,
    this.textPositiveButton = "Ok",
    this.onPressPositiveButton,
    this.textNegativeButton = "Cancelar",
    this.onPressNegativeButton,
  });

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }

  Widget _contentBox(BuildContext context) {
    return Stack(
      children: [
        _body(context),
        _avatar(context),
      ],
    );
  }

  _avatar(BuildContext context) {
    return Positioned(
      left: Constants.padding,
      right: Constants.padding,
      child: CircleAvatar(
        backgroundColor: Colors.grey[50],
        radius: Constants.avatarRadius,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.avatarRadius),
          ),
          child: _getIcon(),
        ),
      ),
    );
  }

  Widget _getIcon() {
    switch (widget.type) {
      case DialogType.ERROR:
        return FaIcon(
          FontAwesomeIcons.exclamationCircle,
          size: 80,
          color: Colors.redAccent,
        );

      case DialogType.CONFIRMATION:
        return FaIcon(
          FontAwesomeIcons.question,
          size: 60,
          color: Colors.blueAccent,
        );

      default:
        return FaIcon(
          FontAwesomeIcons.info,
          size: 80,
          color: Colors.amberAccent,
        );
    }
  }

  _body(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Constants.padding,
          top: Constants.padding * 3,
          right: Constants.padding,
          bottom: Constants.padding),
      margin: EdgeInsets.only(top: Constants.avatarRadius),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(Constants.padding),
        boxShadow: [
          BoxShadow(color: Colors.black38, offset: Offset(0, 5), blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            this.widget.title ?? "",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          widget.message != null
              ? Text(
                  this.widget.message ?? "",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )
              : Container(),
          widget.message != null
              ? SizedBox(
                  height: 22,
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () => widget.onPressPositiveButton != null
                      ? widget.onPressNegativeButton!()
                      : null,
                  child: Text(
                    this.widget.textNegativeButton,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => widget.onPressPositiveButton != null
                      ? widget.onPressPositiveButton!()
                      : null,
                  child: Text(
                    this.widget.textPositiveButton,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
