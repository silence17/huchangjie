package com.hucj.hucjtest.dialog

import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import android.util.DisplayMetrics
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import rx.Observable
import rx.Observer
import rx.android.schedulers.AndroidSchedulers
import java.lang.reflect.Constructor
import java.lang.reflect.Field
import java.util.*
import java.util.concurrent.TimeUnit

abstract class CommonDialogFragment : DialogFragment() {
    private var mIsTouchCancel: Boolean = false
    private var mLayoutPosition = Gravity.CENTER
    private var mRootView: View? = null

    companion object {

        fun <T : CommonDialogFragment> newClass(clazz: Class<T>, bundle: Bundle?): T? {
            try {
                val fragment = clazz.newInstance()
                if (null == bundle) {
                    return fragment
                }
                fragment.arguments = bundle
                return fragment
            } catch (e: IllegalAccessException) {
                e.printStackTrace()
            } catch (e: java.lang.InstantiationException) {
                e.printStackTrace()
            }

            return null
        }
    }

    /**
     * 设置填充的布局
     */
    abstract fun getFillInLayout(): Int

    /**
     * 初始化布局和点击事件
     */
    abstract fun initView()

    /**
     * 设置布局的位置
     */
    fun setLayoutPosition(layoutPosition: Int) {
        mLayoutPosition = layoutPosition
    }

    /**
     * 设置点击阴影是否取消对话框
     */
    fun setTouchCancel(cancel: Boolean) {
        mIsTouchCancel = cancel
    }

    fun getRootView(): View? {
        return mRootView
    }

    private fun getScreenHeight(): Int {
        val displayMetrics = DisplayMetrics()
        activity!!.windowManager.defaultDisplay.getMetrics(displayMetrics)
        return displayMetrics.heightPixels
    }

    private fun getStatusBarHeight(context: Context): Int {
        var statusBarHeight = 0
        val res = context.resources
        val resourceId = res.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            statusBarHeight = res.getDimensionPixelSize(resourceId)
        }
        return statusBarHeight
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        if (null != context) {
            val commonDialog = Dialog(context!!, theme)
            mRootView = LayoutInflater.from(context).inflate(getFillInLayout(), null)
            if (mRootView != null) {
                commonDialog.setContentView(mRootView!!)
            }
            return commonDialog
        }

        return dialog!!
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        initView()
    }

    override fun onStart() {
        super.onStart()

        val screenHeight = getScreenHeight()
        val statusBarHeight = getStatusBarHeight(context!!)
        val dialogHeight = screenHeight - statusBarHeight
        val window = dialog?.window ?: return
        val params = window.attributes
        params.width = WindowManager.LayoutParams.MATCH_PARENT
        if (0 == dialogHeight) {
            params.height = WindowManager.LayoutParams.MATCH_PARENT
        } else {
            params.height = dialogHeight
        }
        params.gravity = mLayoutPosition

        window.setBackgroundDrawable(ColorDrawable(Color.parseColor("#00000000")))
        dialog?.setCancelable(mIsTouchCancel)
        dialog?.setCanceledOnTouchOutside(mIsTouchCancel)
    }

    override fun onResume() {
        super.onResume()
        //避免activity全屏时，dialogfragment高度不能铺满屏幕
        dialog?.window?.setLayout(-1, -1)
    }

    //解决现实老版本升级新版本崩溃的问题
    override fun show(
            manager: FragmentManager,
            tag: String?
    ) {
        try {
            val c = Class.forName("androidx.fragment.app.DialogFragment")
            val con: Constructor<out Any> = c.getConstructor()
            val obj: Any = con.newInstance()
            val dismissed: Field = c.getDeclaredField("mDismissed")
            dismissed.isAccessible = true
            dismissed.set(obj, false)
            val shownByMe: Field = c.getDeclaredField("mShownByMe")
            shownByMe.isAccessible = true
            shownByMe.set(obj, false)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        val ft: FragmentTransaction = manager.beginTransaction()
        ft.add(this, tag)
        ft.commitAllowingStateLoss()
    }

    override fun dismiss() {
        if (null == fragmentManager) {
            return
        }
        dismissAllowingStateLoss()
    }

    //2s自动消失
    fun onStartAutoDisappear(showTime: Int = 2) {
        Observable.interval(0, 1, TimeUnit.SECONDS)
                .take(showTime + 1)
                .map {
                    showTime - it
                }
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(object : Observer<Long?> {
                    override fun onCompleted() {
                        dismiss()
                    }

                    override fun onError(p0: Throwable?) {
                        dismiss()
                    }

                    override fun onNext(p0: Long?) {
                    }
                })
    }
}