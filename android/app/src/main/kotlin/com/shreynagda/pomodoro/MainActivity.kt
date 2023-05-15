package com.shreynagda.pomodoro

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        val engine = FlutterEngine(this.applicationContext);
        val entrypoint = DartExecutor.DartEntrypoint(FlutterLoader().findAppBundlePath(), "vm:entry-point");
        engine.dartExecutor.executeDartEntrypoint(entrypoint);

        GeneratedPluginRegistrant.registerWith(engine);
//        initialize();
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("SHREY", "onDestroy");
//        Toast.makeText(baseContext, "onDestroy", Toast.LENGTH_SHORT).show();
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, "com.shreynagda.pomodoro/notifications").invokeMethod("destroy", null, null);
    }

    override fun onDetachedFromWindow() {
        Log.d("SHREY", "Detached from Window");
        super.onDetachedFromWindow()
    }

}
