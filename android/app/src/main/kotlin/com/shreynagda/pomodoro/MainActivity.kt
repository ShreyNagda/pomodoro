package com.shreynagda.pomodoro

//import androidx.annotation.NonNull
//import io.flutter.embedding.engine.FlutterEngine
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter.temp.channel").setMethodCallHandler {
//                call, result ->
//            // This method is invoked on the main thread.
//            // TODO
//        }
//    }
    override fun onDestroy() {
        super.onDestroy()
        Log.d("SHREY", "onDestroy");
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, "flutter.temp.channel").invokeMethod("destroy", null, null);
//        Toast.makeText(baseContext, "onDestroy", Toast.LENGTH_SHORT).show()
    }
}
