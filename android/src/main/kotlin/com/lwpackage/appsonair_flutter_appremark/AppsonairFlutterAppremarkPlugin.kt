package com.lwpackage.appsonair_flutter_appremark

import android.app.Activity
import android.util.Log
import com.appsonair.appremark.interfaces.RemarkResponse

import com.appsonair.appremark.services.AppRemarkService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import org.json.JSONObject
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

class AppsonairFlutterAppremarkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppRemark")
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppRemark/events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
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
                options = options,

            ){ result ->
                mainHandler.post {
                    eventSink?.success(result.toString())
                }
            }
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
        eventChannel.setStreamHandler(null)
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