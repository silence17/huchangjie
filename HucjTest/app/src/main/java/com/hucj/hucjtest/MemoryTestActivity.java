package com.hucj.hucjtest;

import android.content.Context;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * @author huchangjie1
 * @date 2022-08-14 17:22
 */
public class MemoryTestActivity extends FragmentActivity {

    private static final String TAG = "MemoryTestActivity";
    private static final String LOG_PATH = "/dump.gc/";


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_memory_test);

        createDumpFile(this);
    }

    public static boolean createDumpFile(Context context) {

        boolean bool = false;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd_HH.mm.ssss", Locale.getDefault());
        String createTime = sdf.format(new Date(System.currentTimeMillis()));
        String state = android.os.Environment.getExternalStorageState();

        // 判断SdCard是否存在并且是可用的
        if (android.os.Environment.MEDIA_MOUNTED.equals(state)) {
            File file = new File(Environment.getExternalStorageDirectory().getPath() + LOG_PATH);
            if (!file.exists()) {
                file.mkdirs();
            }

            String hprofPath = file.getAbsolutePath();
            if (!hprofPath.endsWith("/")) {
                hprofPath += "/";
            }
            hprofPath += createTime + ".hprof";
            try {
                android.os.Debug.dumpHprofData(hprofPath);
                bool = true;
                Log.d(TAG, "create dumpfile done!");
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            bool = false;
            Log.d(TAG, "no sdcard!");
        }
        return bool;
    }

}
