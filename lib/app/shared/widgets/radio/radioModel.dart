enum RadioModelLocation { first, middle, last }

class RadioModel {
  final String buttonText;
  final RadioModelLocation location;
  final Function onTap;

  bool isSelected;

  RadioModel(this.isSelected, this.location, this.buttonText, {this.onTap});
}
