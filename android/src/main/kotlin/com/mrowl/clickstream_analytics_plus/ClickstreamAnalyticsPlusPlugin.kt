package com.mrowl.clickstream_analytics_plus

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import software.aws.solution.clickstream.ClickstreamAnalytics
import software.aws.solution.clickstream.ClickstreamAttribute
import software.aws.solution.clickstream.ClickstreamConfiguration
import software.aws.solution.clickstream.ClickstreamUserAttribute

class ClickstreamAnalyticsPlusPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "clickstream_analytics_plus")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                val args = call.arguments as? Map<String, Any> ?: emptyMap()
                result.success(initialize(args))
            }
            "recordEvent" -> {
                val args = call.arguments as? Map<String, Any> ?: emptyMap()
                recordEvent(args)
                result.success(null)
            }
            "setUserId" -> {
                val args = call.arguments as? Map<String, Any> ?: emptyMap()
                setUserId(args)
                result.success(null)
            }
            "setUserAttributes" -> {
                val args = call.arguments as? Map<String, Any> ?: emptyMap()
                setUserAttributes(args)
                result.success(null)
            }
            "flushEvents" -> {
                ClickstreamAnalytics.flushEvents()
                result.success(null)
            }
           // Replace invalid calls with proper equivalents or safe no-ops
            "pauseSession" -> {
                // AWS Android SDK manages session automatically. No direct method.
                result.success(null)
            }
            "resumeSession" -> {
                // No-op; automatic session tracking
                result.success(null)
            }
            "setGlobalAttributes" -> {
                val args = call.arguments as? Map<String, Any> ?: emptyMap()
                val attrs = args["attributes"] as? Map<String, Any> ?: emptyMap()
                ClickstreamAnalytics.addGlobalAttributes(getClickStreamAttributes(attrs))
                result.success(null)
            }
            "removeGlobalAttribute" -> {
                // No API available; rebuild the global attributes map if needed
                result.success(null)
            }
            "getSdkVersion" -> {
                // AWS SDK doesn’t expose version programmatically
                result.success("Android SDK (Clickstream) - version not exposed")
            }
            "enableLogging" -> {
                // Not supported at runtime by Android SDK; advise re-init via Dart docs.
                result.success(null)
            }
          
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initialize(arguments: Map<String, Any>): Boolean {
        return try {
            val appId = arguments["appId"] as? String ?: return false
            val endpoint = arguments["endpoint"] as? String ?: return false
            val logEvents = arguments["logEvents"] as? Boolean
            val compressEvents = arguments["compressEvents"] as? Boolean
            val sessionTimeoutMs = (arguments["sessionTimeoutMs"] as? Number)?.toLong()
            val sendEventIntervalMs = (arguments["sendEventIntervalMs"] as? Number)?.toLong()
            val initialGlobalAttributes = arguments["initialGlobalAttributes"] as? Map<String, Any>

            val configuration = ClickstreamConfiguration()
                .withAppId(appId)
                .withEndpoint(endpoint)

            if (logEvents != null) configuration.withLogEvents(logEvents)
            if (compressEvents != null) configuration.withCompressEvents(compressEvents)
            if (sessionTimeoutMs != null) configuration.withSessionTimeoutDuration(sessionTimeoutMs)
            if (sendEventIntervalMs != null)
                configuration.withSendEventsInterval(sendEventIntervalMs)
            if (initialGlobalAttributes != null) {
                configuration.withInitialGlobalAttributes(getClickStreamAttributes(initialGlobalAttributes))
            }

            ClickstreamAnalytics.init(context, configuration)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun recordEvent(arguments: Map<String, Any>) {
        val eventName = arguments["name"] as? String ?: return
        val attributes = arguments["attributes"] as? Map<String, Any> ?: emptyMap()

        // Create a ClickstreamEvent builder
        val builder = software.aws.solution.clickstream.ClickstreamEvent.builder()
            .name(eventName)

        // Add attributes if provided
        attributes.forEach { (key, value) ->
            when (value) {
                is String -> builder.add(key, value)
                is Boolean -> builder.add(key, value)
                is Int -> builder.add(key, value)
                is Long -> builder.add(key, value)
                is Double -> builder.add(key, value)
            }
        }

        // Build the event and send it
        ClickstreamAnalytics.recordEvent(builder.build())
    }

    private fun setUserId(arguments: Map<String, Any>) {
        val userId = arguments["userId"] as? String
        ClickstreamAnalytics.setUserId(userId)
    }

    private fun setUserAttributes(arguments: Map<String, Any>) {
        val attrs = arguments["attributes"] as? Map<String, Any> ?: return
        ClickstreamAnalytics.addUserAttributes(getClickStreamUserAttributes(attrs))
    }

    private fun getClickStreamAttributes(attrs: Map<String, Any>): ClickstreamAttribute {
        val builder = ClickstreamAttribute.Builder()
        attrs.forEach { (key, value) ->
            when (value) {
                is String -> builder.add(key, value)
                is Boolean -> builder.add(key, value)
                is Int -> builder.add(key, value)
                is Long -> builder.add(key, value)
                is Double -> builder.add(key, value)
                else -> { /* ignore unknown types */ }
            }
        }
        return builder.build()
    }

    private fun getClickStreamUserAttributes(attrs: Map<String, Any>): ClickstreamUserAttribute {
        val builder = ClickstreamUserAttribute.Builder()
        attrs.forEach { (key, value) ->
            when (value) {
                is String -> builder.add(key, value)
                is Boolean -> builder.add(key, value)
                is Int -> builder.add(key, value)
                is Long -> builder.add(key, value)
                is Double -> builder.add(key, value)
                else -> { /* ignore unknown types */ }
            }
        }
        return builder.build()
    }
}