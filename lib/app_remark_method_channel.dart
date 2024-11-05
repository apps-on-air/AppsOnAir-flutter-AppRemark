import 'dart:convert';

import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRemarkMethodChannel extends AppRemarkPlatformInterface {
  late BuildContext context;

  @visibleForTesting
  final methodChannel = const MethodChannel('isUpdateAvailable');

  @override
  Future<void> initMethod(
    BuildContext context, {
    bool showNativeUI = true,
    Widget? Function(Map<String, dynamic> response)? customWidget,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      this.context = context;

      final appUpdateResponse = await _check(showNativeUI);
      if (customWidget != null) {
        final widget = customWidget.call(appUpdateResponse);

        ///custom ui dialog
        if (!showNativeUI && widget != null) {
          //your call
        }
      }
    });
  }

  Future<Map<String, dynamic>> _check(bool showNativeUI) async {
    String updateCheck = '';
    try {
      final result = await methodChannel
          .invokeMethod('isUpdateAvailable', {"showNativeUI": showNativeUI});
      if (result != null && result is String) {
        return Map<String, dynamic>.from(json.decode(result));
      }
      return Map<String, dynamic>.from(((result ?? {}) as Map));
    } on PlatformException catch (e) {
      updateCheck = "Failed to check for update: '${e.message}'.";
    }
    if (kDebugMode) {
      print(updateCheck);
    }
    return {"exception": updateCheck};
  }
}
