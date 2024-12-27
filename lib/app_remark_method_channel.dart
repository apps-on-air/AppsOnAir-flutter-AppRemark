import 'dart:developer';
import 'dart:io';

import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRemarkMethodChannel extends AppRemarkPlatformInterface {
  late BuildContext context;
  bool _dialogOpen = false;
  OverlayEntry? _overlayEntry;
  
  final methodChannel = const MethodChannel('appsOnAirAppRemark');

  @override
  Future<void> initialize(
    BuildContext context, {
    bool shakeGestureEnable = true,
    Map<String, dynamic> options = const {},
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      this.context = context;
      _listenToNativeMethod();
      try {
        final result = await methodChannel.invokeMethod('initializeAppRemark', {
          "shakeGestureEnable": shakeGestureEnable,
          'options': options,
        });
        if (result is! bool) {
          log("App Remark : ${result["error"]}");
        }
      } on PlatformException catch (e) {
        debugPrint('Failed to initialize AppsOnAir AppRemarkSDK! ${e.message ?? ''}');
      }
    });
  }

  /// While the native screen is open (in iOS), the Flutter UI remains accessible.
  /// This overlay provides a solution to block access to the Flutter UI.
  void _listenToNativeMethod() {
    if (Platform.isIOS) {
      methodChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case "openDialog":
            _showIgnorePointerOverLay(context);
            _dialogOpen = true;
            break;
          case "closeDialog":
            _hideIgnorePointerOverLay();
            if (_dialogOpen) {
              _dialogOpen = false;
            }
            break;
        }
        return Future.sync(() => _dialogOpen);
      });
    }
  }

  // show overLay
  void _showIgnorePointerOverLay(BuildContext context) {
    if (_dialogOpen) return; // Prevent showing multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // hide overLay
  void _hideIgnorePointerOverLay() {
    if (!_dialogOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Future<void> addRemark(
    BuildContext context, {
    Map<String, dynamic> extraPayload = const {},
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await methodChannel.invokeMethod('addAppRemark', {
          'extraPayload': extraPayload,
        });
      } on PlatformException catch (e) {
        debugPrint('Failed to implement addRemark()! ${e.message ?? ''}');
      }
    });
  }
}
