import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/core/model/launchUnitType.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';
import 'package:tracker_box/app/shared/utils/colors.dart';
import 'package:tracker_box/app/shared/utils/keyboard_utils.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioGroup.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioModel.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final TrackController controller = Modular.get<TrackController>();
  final TextEditingController _distanceInputController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<RadioModel> items = [];

  @override
  void initState() {
    super.initState();

    items
      ..add(
        RadioModel(true, RadioModelLocation.first, "Segundos", onTap: () {
          controller.launch.setLaunchUnitType(LaunchUnitType.seconds);
        }),
      )
      ..add(
        RadioModel(false, RadioModelLocation.last, "Minutos", onTap: () {
          controller.launch.setLaunchUnitType(LaunchUnitType.minute);
        }),
      );

    _focusNode.addListener(() {
      controller.launch.selectLaunchType(LaunchType.time);

      setState(() {
        controller.setActive(_focusNode.hasFocus);
      });
    });

    controller.launch.setLaunchUnitType(LaunchUnitType.seconds);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height *
              AppPreferences.TRACK_TOGGLE_BUTTON_HEIGHT),
      child: Row(
        children: <Widget>[
          _buildTextField(),
          _buildActionButtons(),
          _buildConfirmButton()
        ],
      ),
    );
  }

  Widget _buildConfirmButton() => _focusNode.hasFocus
      ? IconButton(
          icon: Icon(
            Icons.check,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _focusNode.unfocus();
            KeyboardUtils.close(context);
          })
      : Container();

  Widget _buildTextField() {
    return Expanded(
      child: TextField(
        controller: _distanceInputController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        focusNode: _focusNode,
        onChanged: (value) {
          _submitDistance(value.isEmpty ? 0 : int.parse(value));
        },
        decoration: InputDecoration(
          hintText: "Informe o tempo",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorUtils.lightGrey,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() => SizedBox(
        child: Observer(builder: (_) {
          return RadioGroup(
            items,
            leftBorder: false,
            firstRadius: false,
            active: controller.active,
          );
        }),
        height: 59,
      );

  _submitDistance(int distance) {
    controller.launch.setValue(distance);
  }
}
