package com.msa.flutter_channels_demo

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    val STREAM = "locationStatusStream"
    val TAG = "MainActivityLog"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor, "modi/deviceInfo").setMethodCallHandler{ call, result ->
            if(call.method == "getDeviceInfo"){
                result.success(getDeviceName());
            } else
                result.error("404", "unknown method", null);
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventSink?) {

                        Log.w(TAG, "adding listener")
                        val listener = object : LocationListener {
                            override fun onLocationChanged(location: android.location.Location) {
                            }

                            override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {

                            }

                            override fun onProviderEnabled(provider: String) {
                                events?.success(true)
                            }

                            override fun onProviderDisabled(provider: String) {
                                events?.success(false)
                            }
                        }

                        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

                        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                            // TODO: Consider calling
                            //    ActivityCompat#requestPermissions
                            // here to request the missing permissions, and then overriding
                            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                            //                                          int[] grantResults)
                            // to handle the case where the user grants the permission. See the documentation
                            // for ActivityCompat#requestPermissions for more details.
                            return
                        }
                        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                                2000,
                                10f, listener)
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                            events?.success(locationManager.isLocationEnabled)
                        } else {
                            var gps_enabled = false
                            try {
                                gps_enabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                            } catch (ex: Exception) {
                            }
                            events?.success(gps_enabled)
                        }
                    }

                    override fun onCancel(arguments: Any?) {
                        Log.w(TAG, "cancelling listener")
                    }
                }
        )
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
