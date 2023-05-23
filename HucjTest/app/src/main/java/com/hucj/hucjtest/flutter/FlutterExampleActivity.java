package com.hucj.hucjtest.flutter;

import android.os.Bundle;
import android.view.View;
import android.widget.FrameLayout;

import com.hucj.hucjtest.R;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.plugins.GeneratedPluginRegistrant;


/**
 * Flutter 承载页面 FlutterActivity
 */
public class FlutterExampleActivity extends FlutterActivity implements View.OnClickListener {

    private FrameLayout container;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_flutter_example);

        container = findViewById(R.id.container);
        findViewById(R.id.call_flutter).setOnClickListener(this);

        FlutterView flutterView = new FlutterView(this);
        container.addView(flutterView);

        //挂载Flutter回调代理，Flutter和原生相互调用
        if (getFlutterEngine() != null) {
            // 关键代码，将Flutter页面显示到FlutterView中
            flutterView.attachToFlutterEngine(getFlutterEngine());
            getFlutterEngine().getNavigationChannel().setInitialRoute("/second");

            GeneratedPluginRegistrant.registerWith(getFlutterEngine());
            Flutter2AndroidHelp.getInstance()
                    .registerWith(getFlutterEngine().getDartExecutor().getBinaryMessenger(), this);
        }


        //Flutter 加载Fragment
//        //页面上的按钮点击的时候 向占位符里 添加一个 flutter module
//        FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
//        //FlutterFragment中的 initialRoute方法接收一个 string参数 可以传到flutter中接收
//        FlutterFragment fragment =
//                FlutterFragment.withNewEngine().initialRoute("/").build();
//        tx.replace(R.id.container, fragment);
//        tx.commit();
    }


    @Override
    public void onClick(View view) {
        Flutter2AndroidHelp.getInstance().callFlutter();
    }
}
