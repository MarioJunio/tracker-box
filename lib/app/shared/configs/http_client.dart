import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';

final $HttpClient = BindInject(
  (i) => HttpClient(),
  isSingleton: true,
  isLazy: true,
);

class HttpClient extends DioForNative {
  HttpClient()
      : super(
          BaseOptions(
            // baseUrl: 'http://localhost:8080',
            baseUrl: "http://192.168.100.84:8080",
            connectTimeout: 60 * 1000,
            receiveTimeout: 60 * 1000,
          ),
        );
}
