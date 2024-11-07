import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/material.dart';

class AppRemarkService {
  static Future<void> initialize(
    BuildContext context, {
    bool shakeGestureEnable = true,
    Map<String, dynamic> options = const {},
  }) async {
    AppRemarkPlatformInterface.instance.initialize(
      context,
      shakeGestureEnable: shakeGestureEnable,
      options: options,
    );
  }

  static Future<void> addRemark(
    BuildContext context, {
    Map<String, dynamic> extraPayload = const {},
  }) async {
    AppRemarkPlatformInterface.instance.addRemark(
      context,
      extraPayload: extraPayload,
    );
  }
}
