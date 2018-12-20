package com.example.flutterapp1.plugins;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by zhanglin on 2018/12/11.
 */
public class SysInfoPlugin implements MethodChannel.MethodCallHandler {
    public static final String BATTERY_LEVEL_CHANNEL = "example.flutter.io/battery-level";
    private Context context;

    public SysInfoPlugin(Context context) {
        this.context = context;
    }
    public void register(){
        registerBatteryPlugin();
    }
    private void registerBatteryPlugin() {
        MethodChannel channel = new MethodChannel(((FlutterActivity) context).getFlutterView(), BATTERY_LEVEL_CHANNEL);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "getBatteryLevel":
                int level = getBatteryLevel();
                Log.e("test", "onMethodCall:" + level);
                if (level != -1) {
                    result.success(level);
                } else {
                    result.error("UNAVALIABLE", "Battery level not avaliable", null);
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) context.getSystemService(Context.BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(context.getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
        return batteryLevel;
    }
}
