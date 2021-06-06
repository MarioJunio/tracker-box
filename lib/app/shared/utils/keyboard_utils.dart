import 'package:flutter/material.dart';

class KeyboardUtils {
  static void close(context) {
    FocusScope.of(context).unfocus();
  }
}
