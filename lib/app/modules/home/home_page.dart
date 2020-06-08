import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/modules/home/views/distanceView.dart';
import 'package:tracker_box/app/modules/home/views/speedView.dart';
import 'package:tracker_box/app/modules/home/views/startEngineButton.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioGroup.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioModel.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final PageController _pageController = PageController();
  List<RadioModel> radioModels = List();

  @override
  void initState() {
    super.initState();

    this.radioModels
      ..add(
        new RadioModel(
          true,
          RadioModelLocation.first,
          LaunchTypeDescription.getDescription(LaunchType.km_h),
          onTap: () {
            controller.resetLaunch(LaunchType.km_h);
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
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Launch"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: _buildFormSetup(),
      ),
    );
  }

  Widget _buildFormSetup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTypes,
        SizedBox(height: 60),
        Expanded(
            child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SpeedView(),
            DistanceView(),
          ],
        )),
        SizedBox(height: 60),
        StartEngineButton(),
        SizedBox(height: 10),
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

  Widget _buildTracker() {
    return Center(
      child: Text(
        "${controller.speed} km/h",
        style: TextStyle(
            color: Colors.black87, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
