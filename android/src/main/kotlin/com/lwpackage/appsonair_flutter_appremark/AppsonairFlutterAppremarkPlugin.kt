package com.lwpackage.appsonair_flutter_appremark

import android.app.Activity
import android.util.Log
import com.appsonair.appremark.enums.ShakeSensitivity
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

    // Stored init params so AppRemarkService can be re-initialized on activity resume
    private var initialized = false
    private var storedShakeEnable = true
    private var storedOptions: Map<String, Any> = emptyMap()
    private var storedSensitivity = ShakeSensitivity.MEDIUM

    private val lifecycleCallbacks = object : android.app.Application.ActivityLifecycleCallbacks {
        override fun onActivityResumed(a: android.app.Activity) {
            if (initialized && ::activity.isInitialized && a == activity) {
                AppRemarkService.initialize(
                    activity,
                    shakeGestureEnable = storedShakeEnable,
                    options = storedOptions,
                    shakeSensitivity = storedSensitivity,
                ) { result ->
                    mainHandler.post { eventSink?.success(result.toString()) }
                }
            }
        }
        override fun onActivityCreated(a: android.app.Activity, b: android.os.Bundle?) {}
        override fun onActivityStarted(a: android.app.Activity) {}
        override fun onActivityPaused(a: android.app.Activity) {}
        override fun onActivityStopped(a: android.app.Activity) {}
        override fun onActivitySaveInstanceState(a: android.app.Activity, b: android.os.Bundle) {}
        override fun onActivityDestroyed(a: android.app.Activity) {}
    }

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

        (flutterPluginBinding.applicationContext as? android.app.Application)
            ?.registerActivityLifecycleCallbacks(lifecycleCallbacks)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initializeAppRemark" -> {
                val shakeGestureEnable: Boolean =
                    call.argument<Boolean>("shakeGestureEnable") as Boolean

                val options: Map<String, Any> =
                    call.argument<Map<String, Any>>("options") as Map<String, Any>

                val shakeSensitivity = when (call.argument<String>("shakeSensitivity")) {
                    "veryLow"  -> ShakeSensitivity.VERY_LOW
                    "low"      -> ShakeSensitivity.LOW
                    "medium"   -> ShakeSensitivity.MEDIUM
                    "high"     -> ShakeSensitivity.HIGH
                    "veryHigh" -> ShakeSensitivity.VERY_HIGH
                    else       -> ShakeSensitivity.MEDIUM
                }

                storedShakeEnable = shakeGestureEnable
                storedOptions = options
                storedSensitivity = shakeSensitivity
                initialized = true

                AppRemarkService.initialize(
                    activity,
                    shakeGestureEnable = shakeGestureEnable,
                    options = options,
                    shakeSensitivity = shakeSensitivity,
                ) { result ->
                    mainHandler.post {
                        eventSink?.success(result.toString())
                    }
                }
            }
            "addAppRemark" -> {
                AppRemarkService.addRemark(activity)
            }
            "setAdditionalMetaData" -> {
                val extraPayload: Map<String, Any> =
                    call.argument<Map<String, Any>>("extraPayload") as Map<String, Any>

                AppRemarkService.setAdditionalMetaData(extraPayload)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        (binding.applicationContext as? android.app.Application)
            ?.unregisterActivityLifecycleCallbacks(lifecycleCallbacks)
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