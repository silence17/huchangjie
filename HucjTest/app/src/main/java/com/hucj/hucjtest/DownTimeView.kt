package com.hucj.hucjtest

import android.content.Context
import android.content.res.TypedArray
import android.graphics.*
import android.util.AttributeSet
import android.util.Log
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.view.View.MeasureSpec.AT_MOST
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors


class DownTimeView constructor(context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0) :
    SurfaceView(context, attrs, defStyleAttr), SurfaceHolder.Callback {

    companion object {
        const val TAG = "DownTimeView"

        const val LEFT = 1
        const val CENTER = 2
        const val RIGHT = 3
    }

    private val drawThread: DrawThread

    //用线程池管理线程，避免随意开辟新线程
    private val es: ExecutorService

    //倒计时的数
    private var countDown = 30

    //字体颜色
    private val mTextColor: Int

    //字体大小
    private val mTextSize: Float

    //文本显示模式
    private val mGravity: Int

    //倒计时文本
    private val mText: String
    private val bgRect = RectF()

    //文本画笔
    var textPaint = Paint()

    //背景画笔
    var bgPain = Paint()

    //绘制的文本
    private var txt = ""

    private var radio: Float = 50f //DPIUtil.dip2px(context, 20f)

    //倒计时结束回调
    private var mCompleteRun: Runnable? = null

    init {
        drawThread = DrawThread()
        es = Executors.newSingleThreadExecutor()

        val ta: TypedArray = context.obtainStyledAttributes(attrs, R.styleable.DownTimeView)
        mTextColor = ta.getColor(R.styleable.DownTimeView_text_color, Color.WHITE)
        mTextSize = ta.getDimension(R.styleable.DownTimeView_text_size, 20f)
        mText = ta.getString(R.styleable.DownTimeView_text_text).toString()
        mGravity = ta.getInt(R.styleable.DownTimeView_text_gravity, 0)
        ta.recycle()

        //定义画笔
        textPaint.let {
            it.color = Color.RED//mTextColor
            //去锯齿
            it.isAntiAlias = true
            it.textSize = 50f//DpiUtil.sp2px(context, mTextSize).toFloat()
        }
        bgPain.let {
            it.color = Color.BLACK
            it.alpha = 40
            it.style = Paint.Style.FILL
        }

        txt = mText + countDown + "s"

        holder.addCallback(this)
        //设置画布  背景透明
        holder.setFormat(PixelFormat.TRANSLUCENT)
        setZOrderOnTop(true)
    }

    constructor(context: Context, attrs: AttributeSet) : this(context, attrs, 0) {
    }


    /**
     * @param time:单位秒
     */
    fun startTime(time: Int, runnable: Runnable) {
        this.countDown = time
        this.mCompleteRun = runnable

        txt = mText + countDown + "s"
        invalidate()
    }


    /**
     * 用于绘制的线程
     */
    internal inner class DrawThread : Runnable {

        var isRun = true

        override fun run() {
            synchronized(holder) {

                //绘制背景
                var canvas: Canvas
                while (isRun) {
                    canvas = holder.lockCanvas()
                    try {
                        //本次绘制的文本
                        txt = mText + countDown-- + "s"
                        //清除canvas
                        canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)
                        //绘制背景
                        canvas.drawRoundRect(bgRect, radio, radio, bgPain)
                        val local = calLocation(txt)
                        //锁定并返回画布
                        when (mGravity) {
                            LEFT -> {
                                canvas.drawText(txt, 0f, paddingTop + local[1], textPaint)
                            }
                            CENTER -> {
                                val left = (bgRect.width() - local[0]) / 2
                                canvas.drawText(txt, left, paddingTop + local[1], textPaint)
                            }
                            RIGHT -> {
                                val right = bgRect.width() - local[0]
                                canvas.drawText(txt, right, paddingTop + local[1], textPaint)
                            }
                            else -> {
                                canvas.drawText(txt, paddingLeft.toFloat(), paddingTop + local[1], textPaint)
                            }
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    } finally {
                        //解锁画布并显示到屏幕上
                        if (canvas != null) {
                            holder.unlockCanvasAndPost(canvas)
                        }
                    }

                    Thread.sleep(1000)
                    if (countDown < 0) {
                        isRun = false
                        mCompleteRun?.run()
                    }
                }
            }
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)

        var right = this@DownTimeView.width.toFloat()
        var bottom = this@DownTimeView.height.toFloat()

        if (MeasureSpec.getMode(widthMeasureSpec) == AT_MOST || MeasureSpec.getMode(heightMeasureSpec) == AT_MOST) {
            //根据文字的大小计算surface view 的大小
            val rect = calLocation(txt)
            right = paddingLeft + paddingRight + rect[0]
            bottom = paddingTop + paddingBottom + rect[1]
            setMeasuredDimension(right.toInt(), bottom.toInt())
        }

        bgRect.let {
            it.left = 0f
            it.right = right
            it.top = 0f
            it.bottom = bottom
        }
        radio = bottom / 2
    }

    /**
     * 计算文字的大小
     * @return [0]:文字left 坐标； [1]:文字top 坐标
     */
    private fun calLocation(txt: String): FloatArray {

        val textRect: Rect = Rect();
        textPaint.getTextBounds(txt, 0, txt.length, textRect)

        Log.e(TAG, "==========1 ${textRect.width()}")
        Log.e(TAG, "==========2 ${textRect.height()}")
        return floatArrayOf(textRect.width().toFloat(), textRect.height().toFloat())
    }


    /**
     * surface创建的时候调用
     */
    override fun surfaceCreated(holder: SurfaceHolder) {
        es.execute(drawThread)
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        drawThread.isRun = false
        es.shutdown()
    }

}