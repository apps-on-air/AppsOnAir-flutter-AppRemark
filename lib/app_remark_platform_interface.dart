import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_remark_method_channel.dart';

abstract class AppRemarkPlatformInterface extends PlatformInterface {
  AppRemarkPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static AppRemarkPlatformInterface _instance = AppRemarkMethodChannel();

  static AppRemarkPlatformInterface get instance => _instance;

  static set instance(AppRemarkPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initMethod(
    BuildContext context, {
    bool showNativeUI = true,
    Widget? Function(Map<String, dynamic>)? customWidget,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
