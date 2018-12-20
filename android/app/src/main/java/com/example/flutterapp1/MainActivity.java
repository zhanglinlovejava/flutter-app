package com.example.flutterapp1;

import android.os.Bundle;

import com.example.flutterapp1.plugins.SysInfoPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new SysInfoPlugin(this).register();
    }


}
