package com.hucj.hucjtest.flutter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * @description 使用MethodChannel，android和Flutter交互
 */
public class Flutter2AndroidHelp implements MethodChannel.MethodCallHandler {

    public static String CHANNEL_NAME = "com.supermax";

    private MethodChannel methodChannel;
    private Activity mActivity;


    @SuppressLint("StaticFieldLeak")
    private static Flutter2AndroidHelp instance;


    public static Flutter2AndroidHelp getInstance() {
        if (instance == null) {
            synchronized (Flutter2AndroidHelp.class) {
                if (instance == null) {
                    instance = new Flutter2AndroidHelp();
                }
            }
        }
        return instance;
    }

    private Flutter2AndroidHelp() {
    }

    private Flutter2AndroidHelp(Activity activity) {
        this.mActivity = activity;
    }


    /**
     * Android 调用 Flutter
     */
    public void callFlutter() {
        methodChannel.invokeMethod("call3", "我是参数", new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {

            }

            @Override
            public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

            }

            @Override
            public void notImplemented() {

            }
        });
    }


    /**
     * 接收Flutter传来的指令，进一步处理
     *
     * @param call
     * @param result
     */
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        Log.e("FlutterPluginJumpToAct", "method is " + call.method + " arguments is " + (call.arguments == null ? "" : call.arguments.toString()));

//        switch (call.method) {
//            case "withoutParams":
//                Intent intent = new Intent(mActivity, Flutter2AndroidActivity.class);
//                mActivity.startActivity(intent);
//                result.success("success");
//                break;
//            case "withParams":
//                if (call.arguments == null) {
//                    return;
//                }
//                Intent intent1 = new Intent(mActivity, Flutter2AndroidActivity.class);
//                String text = call.arguments.toString();
//                intent1.putExtra("test", text);
//                mActivity.startActivity(intent1);
//                result.success("success");
//                break;
//            default:
//                result.notImplemented();
//                break;
//        }

    }

    public void registerWith(BinaryMessenger registrar, Activity activity) {
        methodChannel = new MethodChannel(registrar, CHANNEL_NAME);
        Flutter2AndroidHelp instance = new Flutter2AndroidHelp(activity);
        //setMethodCallHandler在此通道上接收方法调用的回调
        methodChannel.setMethodCallHandler(instance);
    }

}

