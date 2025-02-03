import 'package:appsonair_flutter_appremark/app_remark_platform_interface.dart';
import 'package:flutter/material.dart';

class AppRemarkService {
  /// [shakeGestureEnable] controls the shake behaviour in your app
  ///
  ///Pass the below data in options in case you require custom theme
  ///
  /// Parameter               | Type    |Default Value            | Description
  ///:-------------------------|:---------|:--------------------------|:-----------------------------------
  /// pageBackgroundColor     | String  | "#E8F1FF"                | Set page background color
  /// appBarBackgroundColor   | String  | "#E8F1FF"                | Set appbar background color
  /// appBarTitleText         | String  | "Add Remark"             | Set appbar title text
  /// appBarTitleColor        | String  | "#000000"                | Set appbar title color
  /// remarkTypeLabelText     | String  | "Remark Type"            | Set remark type label text
  /// descriptionLabelText    | String  | "Description"            | Set description label text
  /// descriptionHintText     | String  | "Add description here..."| Set description hint text
  /// descriptionMaxLength    | int     | 255                      | Set description max length
  /// buttonText              | String  | "Submit"                 | Set button text
  /// buttonTextColor         | String  | "#FFFFFF"                | Set button text color
  /// buttonBackgroundColor   | String  | "#007AFF"                | Set button background color
  /// labelColor              | String  | "#000000"                | Set textfield label color
  /// hintColor               | String  | "#B1B1B3"                | Set textfield hint color
  /// inputTextColor          | String  | "#000000"                | Set textfield input text color

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

  /// Manually opens the App Remark screen.
  ///
  /// - [context]: The current BuildContext.
  /// - [extraPayload]: Additional data to send along with the remark (default is an empty map).
  ///
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
