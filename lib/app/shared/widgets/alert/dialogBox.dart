import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_box/app/shared/utils/constants.dart';

class CustomDialogBox extends StatefulWidget {
  final String title;
  final String message;
  final String textButtonOk;
  final Function onPressButtonOk;

  const CustomDialogBox({
    this.title = "Title",
    this.message =
        "Qui ex cupidatat pariatur magna non eu officia tempor ipsum ex. Eu excepteur commodo commodo est incididunt excepteur eu mollit eu cillum adipisicing. Irure voluptate pariatur in ad duis cillum minim Lorem laboris labore ex. Irure deserunt nisi commodo dolore eu minim deserunt enim duis sit dolore enim cillum id. Laborum officia labore cupidatat proident eiusmod amet fugiat in aute Lorem. Mollit reprehenderit eiusmod nisi aliquip adipisicing tempor. Cupidatat nisi sint voluptate enim aute consectetur.",
    this.textButtonOk = "OK",
    required this.onPressButtonOk,
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
          child: FaIcon(
            FontAwesomeIcons.exclamationCircle,
            size: 80,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
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
            this.widget.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            this.widget.message,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 22,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () => widget.onPressButtonOk(),
                child: Text(
                  this.widget.textButtonOk,
                  style: TextStyle(fontSize: 18),
                )),
          ),
        ],
      ),
    );
  }
}
