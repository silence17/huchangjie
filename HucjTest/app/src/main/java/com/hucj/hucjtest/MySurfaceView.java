package com.hucj.hucjtest;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class MySurfaceView extends SurfaceView implements SurfaceHolder.Callback {
    private SurfaceHolder holder;
    private DrawThread drawThread;
    ExecutorService es;      //用线程池 管理线程     尽量避免随意开辟新线程

    public MySurfaceView(Context context) {
        super(context);
        init();
    }


    public MySurfaceView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public MySurfaceView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }


    void init() {
        drawThread = new DrawThread();
        es = Executors.newSingleThreadExecutor();
        holder = this.getHolder();
        holder.addCallback(this);
    }


    //用于绘制的线程
    class DrawThread implements Runnable {
        public boolean isRun = true;
        Paint p = null;

        public DrawThread() {
            //定义画笔
            p = new Paint();
            p.setColor(Color.YELLOW);
            p.setAntiAlias(true);//去锯齿
            p.setTextSize(50);
        }

        @Override
        public void run() {
            int count = 10; //倒计时的数
            while (isRun) {
                Canvas c = null;
                synchronized (holder) {
                    try {
                        //锁定并返回画布
                        c = holder.lockCanvas();
                        c.drawColor(Color.BLACK);
                        c.drawText("倒计时：" + (count--), 10 + count, 100, p);
                    } finally {
                        //解锁画布并显示到屏幕上
                        holder.unlockCanvasAndPost(c);
                    }
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    if (count < 0) {
                        isRun = false;
                    }
                }
            }
        }
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        es.execute(drawThread);
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        drawThread.isRun = false;
        es.shutdown();
    }
}
