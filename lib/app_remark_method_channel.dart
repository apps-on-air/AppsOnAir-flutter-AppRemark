import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRemarkMethodChannel extends AppRemarkPlatformInterface {
  @visibleForTesting
  final methodChannel = const MethodChannel('appsOnAirAppRemark');

  @override
  Future<void> initialize(
    BuildContext context, {
    bool shakeGestureEnable = true,
    Map<String, dynamic> options = const {},
  }) async {
    try {
      await methodChannel.invokeMethod('initializeAppRemark', {
        "shakeGestureEnable": shakeGestureEnable,
        'options': options,
      });
    } on PlatformException catch (e) {
      debugPrint(
          'Failed to initialize AppsOnAir AppRemarkSDK! ${e.message ?? ''}');
    }
  }

  @override
  Future<void> addRemark(
    BuildContext context, {
    Map<String, dynamic> extraPayload = const {},
  }) async {
    try {
      await methodChannel.invokeMethod('addAppRemark', {
        'extraPayload': extraPayload,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to implement addRemark()! ${e.message ?? ''}');
    }
  }
}
