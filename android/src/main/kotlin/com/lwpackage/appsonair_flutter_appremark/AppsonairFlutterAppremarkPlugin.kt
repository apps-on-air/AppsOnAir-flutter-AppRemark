package com.lwpackage.appsonair_flutter_appremark

import android.app.Activity

import com.appsonair.appremark.services.AppRemarkService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class AppsonairFlutterAppremarkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppRemark")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "initializeAppRemark") {
            var shakeGestureEnable: Boolean =
                call.argument<Boolean>("shakeGestureEnable") as Boolean

            var options: Map<String, Any> =
                call.argument<Map<String, Any>>("options") as Map<String, Any>

            AppRemarkService.initialize(
                activity,
                shakeGestureEnable = shakeGestureEnable,
                options = options
            )
        } else if (call.method == "addAppRemark") {
            AppRemarkService.addRemark(
                activity
            )
        }else if (call.method == "setAdditionalMetaData") {
            var extraPayload: Map<String, Any> =
                call.argument<Map<String, Any>>("extraPayload") as Map<String, Any>

            AppRemarkService.setAdditionalMetaData(
                extraPayload,
            )
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}
