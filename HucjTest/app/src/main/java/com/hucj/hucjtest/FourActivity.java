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

import com.hucj.hucjtest.base64.User;
import com.hucj.hucjtest.exmaple.IOSStyleLoadingview;

/**
 * @author : huchangjie1
 * @data: 2022/8/13
 */
public class FourActivity extends FragmentActivity {

    private static final String TAG = "ThreeActivity";

    private IOSStyleLoadingview loadingview;

    Personal personal = null;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_four);

        loadingview = findViewById(R.id.loading_view);
        Button stopBtn = findViewById(R.id.btn_stop);
        stopBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                loadingview.stop();


                comple(personal);
            }
        });
    }


    void comple(@NonNull Personal personal){
        Personal p1 /*= new Personal()*/ = null;
        if (personal == p1) {
            Log.e("=====", "909090");
        }


    }


    class Personal {
        String sopId = "";
    }

}
