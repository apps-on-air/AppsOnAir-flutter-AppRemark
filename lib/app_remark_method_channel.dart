import 'dart:developer';

import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An implementation of [AppRemarkPlatformInterface] that uses method channels.
/// This class enables communication with the native platform for the AppsOnAir AppRemark SDK.
class AppRemarkMethodChannel extends AppRemarkPlatformInterface {
  ///[context]: Required to show a dialog or overlay.
  late BuildContext context;
  bool _dialogOpen = false;
  OverlayEntry? _overlayEntry;

  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('appsOnAirAppRemark');

  /// Initializes the AppsOnAir AppRemark SDK.
  ///
  /// - [context]: Required to show a dialog or overlay.
  /// - [shakeGestureEnable]: Determines whether the shake gesture is enabled for feedback (default is true).
  /// - [options]: Additional configuration options for the SDK.
  ///
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

  /// Listens to method calls from the native platform.
  ///
  /// This overlay to block user interactions with the Flutter UI
  /// To manage overlay visibility
  ///
  void _listenToNativeMethod() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
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

  /// Displays an overlay when a native dialog is open.
  void _showIgnorePointerOverLay(BuildContext context) {
    if (_dialogOpen) return; // Prevent showing multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Container(color: Colors.transparent),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hides the overlay when the native dialog is closed.
  void _hideIgnorePointerOverLay() {
    if (!_dialogOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Manually opens the App Remark screen.
  ///
  /// - [context]: The current BuildContext.
  /// - [extraPayload]: Additional data to send along with the remark (default is an empty map).
  ///
  @override
  Future<void> addRemark(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await methodChannel.invokeMethod('addAppRemark');
      } on PlatformException catch (e) {
        debugPrint('Failed to implement addRemark()! ${e.message ?? ''}');
      }
    });
  }

  @override
  Future<void> setAdditionalMetaData({
    Map<String, dynamic> extraPayload = const {},
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await methodChannel.invokeMethod('setAdditionalMetaData', {
          'extraPayload': extraPayload,
        });
      } on PlatformException catch (e) {
        debugPrint('Failed to implement setAdditionalMetaData() ${e.message ?? ''}');
      }
    });
  }
}
