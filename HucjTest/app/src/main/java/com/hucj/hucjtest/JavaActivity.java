package com.hucj.hucjtest;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

/**
 * @ProjectName: jdjch
 * @Author: huchangjie1
 * @CreateDate: 2022/12/13
 * @Version: 1.0
 * @Description:
 */
public class JavaActivity extends FragmentActivity {


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {

            }
        }, Integer.MAX_VALUE);


    }
}
