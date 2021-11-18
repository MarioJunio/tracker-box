import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';
import 'package:tracker_box/app/shared/utils/map_utils.dart';
import 'package:tracker_box/app/shared/utils/trackFormatter.dart';

class TrackPillInfo extends StatefulWidget {
  final TrackEntity? track;
  final Uint8List? icon;
  final double? pinPillPosition;

  TrackPillInfo({Key? key, this.track, this.icon, this.pinPillPosition = 0})
      : super(key: key);

  @override
  _TrackPillInfoState createState() => _TrackPillInfoState();
}

class _TrackPillInfoState extends State<TrackPillInfo> {
  Uint8List? icon;

  @override
  void initState() {
    super.initState();

    MapUtils.drawTrackMarkerDot(60, 60, Colors.blueAccent.shade200)
        .then((value) {
      setState(() {
        icon = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      left: 0,
      right: 0,
      bottom: widget.pinPillPosition,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        padding: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ]),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: ClipOval(
                child: Image.asset(
                  "assets/u1.jpeg",
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.track!.user!.username!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.blueAccent.shade200),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _metric("Distância",
                        TrackFormatter.formatDistance(widget.track!.distance!)),
                    _metric("Tempo",
                        TrackFormatter.formatTimer(widget.track!.time!)),
                    _metric("Velocidade máxima",
                        TrackFormatter.formatSpeed(widget.track!.maxSpeed!)),
                  ],
                ),
              ),
            ),
            icon != null
                ? Image.memory(
                    icon!,
                    width: 40,
                    height: 40,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) => Row(
        children: [
          Text(
            label,
            style:
                Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      );
}
