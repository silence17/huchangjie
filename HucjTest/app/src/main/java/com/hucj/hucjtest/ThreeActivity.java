package com.hucj.hucjtest;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

/**
 * @author : huchangjie1
 * @data: 2022/8/13
 */
public class ThreeActivity extends FragmentActivity {

    private static final String TAG = "ThreeActivity";

    private MyHandle handle;


    private class MyHandle extends Handler {

        public MyHandle() {
            super(Looper.getMainLooper());
        }

        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);

//            handle.sendEmptyMessage(0);
            Log.e(TAG, "====my handler");
        }
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_three);
        handle = new MyHandle();


        findViewById(R.id.finish).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        findViewById(R.id.leakage).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                handle.sendEmptyMessage(0);
                handle.sendEmptyMessageDelayed(0, 1000000);
                finish();
            }
        });
    }

}
