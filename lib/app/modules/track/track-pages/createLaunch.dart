import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/modules/track/launch-pages/distancePage.dart';
import 'package:tracker_box/app/modules/track/launch-pages/speedPage.dart';
import 'package:tracker_box/app/modules/track/launch-pages/timerPage.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/shared/utils/keyboard_utils.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioGroup.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioModel.dart';

class CreateTrackPage extends StatefulWidget {
  @override
  _CreateTrackPageState createState() => _CreateTrackPageState();
}

class _CreateTrackPageState extends State<CreateTrackPage> {
  final TrackController controller = Modular.get<TrackController>();
  final PageController _pageController = PageController();

  List<RadioModel> radioModels = [];

  @override
  void initState() {
    super.initState();

    this.radioModels
      ..add(
        new RadioModel(
          true,
          RadioModelLocation.first,
          LaunchTypeDescription.getDescription(LaunchType.speed),
          onTap: () {
            controller.resetLaunch(LaunchType.speed);

            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      )
      ..add(
        new RadioModel(
          false,
          RadioModelLocation.middle,
          LaunchTypeDescription.getDescription(LaunchType.distance),
          onTap: () {
            controller.resetLaunch(LaunchType.distance);

            _pageController.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      )
      ..add(
        new RadioModel(
          false,
          RadioModelLocation.last,
          LaunchTypeDescription.getDescription(LaunchType.time),
          onTap: () {
            controller.launch.selectLaunchType(LaunchType.time);

            _pageController.animateToPage(2,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTypes,
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int pageNumber) {
              KeyboardUtils.close(context);
            },
            children: <Widget>[
              SpeedPage(),
              DistancePage(),
              TimerPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _buildTypes => Container(
        height: 50,
        child: RadioGroup(
          radioModels,
          activeBorderWidth: 1,
        ),
      );
}
