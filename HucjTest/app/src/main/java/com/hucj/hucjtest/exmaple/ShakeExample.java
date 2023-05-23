package com.hucj.hucjtest.exmaple;

import android.util.Log;

/**
 * @author huchangjie1
 * @date 2022/9/21
 * 模拟内存抖动
 */
public class ShakeExample {

    private static final String TAG = "ShakeExample";


    public String addStr(String[] values) {
        String result = null;
        for (int i = 0; i < values.length; i++) {

            result += values[i];
        }
        return result;
    }

}
