import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/material.dart';

class AppRemarkService {
  static Future<void> sync(
    BuildContext context, {
    Map<String, dynamic>? options,
    Widget? Function(Map<String, dynamic>)? customWidget,
  }) async {
    bool showNativeUI = true;
    if ((options ?? {}).isNotEmpty) {
      showNativeUI = options!['showNativeUI'];
    }
    if (!showNativeUI && customWidget == null) {
      throw Exception(
          "set showNativeUI = 'true' to show default UI or/else return your custom widget in from sync() method");
    } else if (showNativeUI && customWidget != null) {
      debugPrint(
          "set showNativeUI = 'false' to show custom UI or/else remove custom widget from sync() method");
    }
    AppRemarkPlatformInterface.instance.initMethod(
      context,
      showNativeUI: showNativeUI,
      customWidget: customWidget,
    );
  }
}
