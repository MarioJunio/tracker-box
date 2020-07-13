import 'package:flutter/material.dart';
import 'package:tracker_box/app/shared/utils/colors.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioItem.dart';
import 'package:tracker_box/app/shared/widgets/radio/radioModel.dart';

class RadioGroup extends StatefulWidget {
  final List<RadioModel> radioModels;
  final bool firstRadius;
  final bool lastRadius;
  final bool leftBorder;
  final bool rightBorder;
  final bool active;
  final double borderWidth;
  final double activeBorderWidth;

  const RadioGroup(this.radioModels,
      {this.firstRadius = true,
      this.lastRadius = true,
      this.leftBorder = true,
      this.rightBorder = true,
      this.active = true,
      this.borderWidth = 1,
      this.activeBorderWidth = 2});

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildItems(),
      decoration: new BoxDecoration(
        border: Border(
          top: _buildBorderSide(),
          left: _buildBorderSide(),
          right: _buildBorderSide(),
          bottom: _buildBorderSide(),
        ),
        borderRadius: boxRadius(),
      ),
    );
  }

  BorderRadius boxRadius() {
    if (widget.firstRadius && widget.lastRadius) {
      return const BorderRadius.only(
        topLeft: const Radius.circular(4),
        bottomLeft: const Radius.circular(4),
        bottomRight: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
    } else if (widget.firstRadius && !widget.lastRadius) {
      return const BorderRadius.only(
        topLeft: const Radius.circular(4),
        bottomLeft: const Radius.circular(4),
        bottomRight: const Radius.circular(0),
        topRight: const Radius.circular(0),
      );
    } else if (!widget.firstRadius && widget.lastRadius) {
      return const BorderRadius.only(
        topLeft: const Radius.circular(0),
        bottomLeft: const Radius.circular(0),
        bottomRight: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
    } else {
      return const BorderRadius.only(
        topLeft: const Radius.circular(0),
        bottomLeft: const Radius.circular(0),
        bottomRight: const Radius.circular(0),
        topRight: const Radius.circular(0),
      );
    }
  }

  Widget _buildItems() => ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.radioModels.length,
      itemBuilder: (context, int index) {
        RadioModel radioModel = widget.radioModels[index];

        return InkWell(
          splashColor: Theme.of(context).primaryColor,
          onTap: () {
            setState(() {
              // limpa o estado selecionado de todos os Radio
              widget.radioModels.forEach((RadioModel model) {
                model.isSelected = false;
              });

              // seleciona o Radio pressionado
              radioModel.isSelected = true;

              // executa a função de tap
              if (radioModel.onTap != null) radioModel.onTap();
            });
          },
          child: RadioItem(
            radioModel,
            active: widget.active,
            hasRightBorder: widget.radioModels.length == 2 &&
                radioModel.location == RadioModelLocation.first,
          ),
        );
      });

  BorderSide _buildBorderSide() {
    return BorderSide(
      width: widget.active ? widget.activeBorderWidth : widget.borderWidth,
      color:
          widget.active ? Theme.of(context).primaryColor : ColorUtils.lightGrey,
    );
  }
}
