import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_sync/global/nav_key.dart';
import 'package:photo_sync/inherited_widgets/auth_bloc_inherited.dart';
import 'package:photo_sync/routes/route_builder.dart';

class ApiConnectionInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    AuthBlocInherited.of(navigatorKey.currentContext!).changeLoading(false);
    if (err.type == DioErrorType.connectTimeout) {
      Navigator.pushNamed(
          navigatorKey.currentContext!, RouteBuilder.API_NOT_REACHABLE);
    }
  }
}
