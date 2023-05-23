package com.hucj.hucjtest.dialogmanager;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.FragmentActivity;

import com.hucj.hucjtest.R;
import com.hucj.hucjtest.dialog.TipDialogFragment;
import com.hucj.hucjtest.dialog.TipDialogParams;

import kotlin.Unit;
import kotlin.jvm.functions.Function0;

/**
 * @author : huchangjie1
 * @data: 2022/8/13
 */
public class FiveActivity extends FragmentActivity {

    private static final String TAG = "FiveActivity";

    private DialogHelper2<Activity> dialogHelper;


    @RequiresApi(api = Build.VERSION_CODES.Q)
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_four);

        dialogHelper = new DialogHelper2<>(this);
        initDialog();

        Button stopBtn = findViewById(R.id.btn_stop);
        stopBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                dialogHelper.show();

                //延迟显示
                stopBtn.postDelayed(new Runnable() {
                    @Override
                    public void run() {

                        TipDialogParams params2 = new TipDialogParams.Builder()
                                .tipTitle("延迟测试测试测试")
                                .useSmallOneBtn(true)
                                .oneButtonText("弹窗" + (10))
                                .setOnDismiss(new Function0<Unit>() {
                                    @Override
                                    public Unit invoke() {
                                        dialogHelper.showNext();
                                        return null;
                                    }
                                })
                                .build();
                        TipDialogFragment dialog2 = new TipDialogFragment();
                        dialog2.setMTipParams(params2);

                        DialogMessage dialogBean2 = DialogMessage.obtain();
                        dialogBean2.dialog = dialog2;
                        dialogBean2.isAutoNext = false;
                        dialogBean2.priority = 300;

                        Log.e("DialogHelper2", "延迟添加dialogMessage");
                        dialogHelper.addDialog(dialogBean2);
                    }
                }, 5000);

                for (int i = 0; i < 2; i++) {
                    TipDialogParams params2 = new TipDialogParams.Builder()
                            .tipTitle("12121212121212")
                            .useSmallOneBtn(true)
                            .oneButtonText("弹窗" + (3 + i))
                            .setOnDismiss(new Function0<Unit>() {
                                @Override
                                public Unit invoke() {
                                    dialogHelper.showNext();
                                    return null;
                                }
                            })
                            .build();
                    TipDialogFragment dialog2 = new TipDialogFragment();
                    dialog2.setMTipParams(params2);

                    DialogMessage dialogBean2 = DialogMessage.obtain();
                    dialogBean2.dialog = dialog2;
                    dialogBean2.isAutoNext = true;
                    dialogBean2.priority = 1000 + i;

                    dialogHelper.addDialog(dialogBean2);
                }
            }
        });
    }

    private void initDialog() {
        TipDialogParams params1 = new TipDialogParams.Builder()
                .tipTitle("09090909090")
                .useSmallOneBtn(true)
                .oneButtonText("弹窗1")
                .setOnDismiss(new Function0<Unit>() {
                    @Override
                    public Unit invoke() {
                        dialogHelper.showNext();
                        return null;
                    }
                })
                .build();
//                TipDialogFragment.Companion.show(FiveActivity.this, params, false);

        TipDialogFragment dialog1 = new TipDialogFragment();
        dialog1.setMTipParams(params1);
//        dialog1.show(FiveActivity.this.getSupportFragmentManager(), "");

        DialogMessage dialogBean1 = DialogMessage.obtain();
        dialogBean1.dialog = dialog1;
        dialogBean1.isAutoNext = true;
        dialogBean1.priority = 600;

        dialogHelper.addDialog(dialogBean1);


        //========== 弹窗2

        TipDialogParams params2 = new TipDialogParams.Builder()
                .tipTitle("12121212121212")
                .useSmallOneBtn(true)
                .oneButtonText("弹窗2")
                .setOnDismiss(new Function0<Unit>() {
                    @Override
                    public Unit invoke() {
                        dialogHelper.showNext();
                        return null;
                    }
                })
                .build();
        TipDialogFragment dialog2 = new TipDialogFragment();
        dialog2.setMTipParams(params2);

        DialogMessage dialogBean2 = DialogMessage.obtain();
        dialogBean2.dialog = dialog2;
        dialogBean2.isAutoNext = true;
        dialogBean2.priority = 800;

        dialogHelper.addDialog(dialogBean2);
    }


}
