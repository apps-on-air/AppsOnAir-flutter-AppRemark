import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_remark_method_channel.dart';

/// Controls how hard the device must be shaken to open the feedback screen.
///
/// | Value      | Description                                          |
/// |:-----------|:-----------------------------------------------------|
/// | veryLow    | Needs a very hard, deliberate shake                  |
/// | low        | Needs a firm shake, useful for apps used on the move |
/// | medium     | Default                                              |
/// | high       | Triggers on a light shake                            |
/// | veryHigh   | Triggers on a very light shake, useful for testers   |
enum ShakeSensitivity { veryLow, low, medium, high, veryHigh }

/// The platform interface for AppRemark.
///
/// This allows communication between the platform-specific implementation
/// and the Flutter application. The concrete implementation of this interface
/// should provide platform-specific functionality, typically by using a
/// [MethodChannel] to invoke native code.
abstract class AppRemarkPlatformInterface extends PlatformInterface {
  AppRemarkPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static AppRemarkPlatformInterface _instance = AppRemarkMethodChannel();

  /// The current instance of [AppRemarkPlatformInterface].
  ///
  /// This is typically a concrete implementation such as [AppRemarkMethodChannel].
  static AppRemarkPlatformInterface get instance => _instance;

  /// Sets the [AppRemarkPlatformInterface] instance.
  ///
  /// This is used to assign a custom implementation of [AppRemarkPlatformInterface],
  /// typically used for testing or for providing a different platform-specific implementation.
  static set instance(AppRemarkPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the AppRemark platform.
  ///
  /// This method should be implemented by platform-specific code and is used to
  /// initialize the necessary platform resources.
  ///
  /// - [context]: The build context for the current widget.
  /// - [shakeGestureEnable]: Whether the shake gesture should be enabled. Defaults to `true`.
  /// - [options]: A map of additional configuration options, defaults to an empty map.
  Future<void> initialize(
    BuildContext context, {
    bool shakeGestureEnable = true,
    ShakeSensitivity shakeSensitivity = ShakeSensitivity.medium,
    Map<String, dynamic> options = const {},
    required Function(Map<String, dynamic>) onRemarkResponse,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Adds a remark on the platform.
  ///
  /// - [context]: The build context for the current widget.
  /// - [extraPayload]: A map of extra data to send with the remark, defaults to an empty map.
  Future<void> addRemark(BuildContext context) {
    throw UnimplementedError('addRemark() has not been implemented.');
  }

  Future<void> setAdditionalMetaData({
    Map<String, dynamic> extraPayload = const {},
  }) {
    throw UnimplementedError('addRemark() has not been implemented.');
  }
}
