import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  static String genSha256(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }
}
