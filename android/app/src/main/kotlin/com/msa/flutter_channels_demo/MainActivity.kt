package com.msa.flutter_channels_demo

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor, "modi/deviceInfo").setMethodCallHandler{ call, result ->
            if(call.method == "getDeviceInfo"){
                result.success(getDeviceName());
            } else
                result.error("404","unknown method",null);
        }
    }
    private fun getDeviceName(): String {
        val manufacturer = Build.MANUFACTURER
        val model = Build.MODEL
        val androidVer = "Android ${android.os.Build.VERSION.RELEASE}"


        return if (model.startsWith(manufacturer)) {
            "$model ($androidVer)"
        } else {
            "$manufacturer $model ($androidVer)"
        }
    }
}
