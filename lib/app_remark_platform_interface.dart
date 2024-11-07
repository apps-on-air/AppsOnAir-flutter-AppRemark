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

  Future<void> initialize(
    BuildContext context, {
    bool shakeGestureEnable = true,
    Map<String, dynamic> options = const {},
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> addRemark(
    BuildContext context, {
    Map<String, dynamic> extraPayload = const {},
  }) {
    throw UnimplementedError('addRemark() has not been implemented.');
  }
}
