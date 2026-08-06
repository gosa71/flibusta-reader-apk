package ru.utopicnarwhal.flibustabrowser

import android.media.MediaScannerConnection
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "ru.utopicnarwhal.flibustabrowser/native_methods_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "rescan_folder" -> {
                    val response = rescanFolder(call.arguments.toString())
                    if (response != -1) {
                        result.success(response)
                    } else {
                        result.error("UNAVAILABLE", "Not available.", null)
                    }
                }
                "keep_screen_on" -> {
                    val keepOn = call.arguments as Boolean
                    setKeepScreenOn(keepOn)
                    result.success(true)
                }
                "set_brightness" -> {
                    val value = (call.arguments as Double).toFloat()
                    setBrightness(value)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun rescanFolder(dir: String): Int {
        try {
            MediaScannerConnection.scanFile(this@MainActivity, arrayOf(dir), null, null)
        } catch (e: Exception) {
            return -1
        }
        return 1
    }

    private fun setKeepScreenOn(keepOn: Boolean) {
        if (keepOn) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    /// value: -1f — вернуть системную яркость, 0f..1f — переопределить для этого окна.
    private fun setBrightness(value: Float) {
        val params = window.attributes
        params.screenBrightness = if (value < 0f) {
            WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
        } else {
            value.coerceIn(0.05f, 1f)
        }
        window.attributes = params
    }
}
