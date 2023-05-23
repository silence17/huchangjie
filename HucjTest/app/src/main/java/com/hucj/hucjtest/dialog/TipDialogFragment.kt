package com.hucj.hucjtest.dialog

import android.content.DialogInterface
import android.graphics.Color
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.fragment.app.FragmentActivity
import com.hucj.hucjtest.R
import com.hucj.hucjtest.util.AppUtil

class TipDialogFragment : CommonDialogFragment() {

    //参数集合
    var mTipParams: TipDialogParams? = null


    override fun getFillInLayout(): Int {
        return R.layout.layout_dialog_tip
    }

    override fun initView() {
        if (mTipParams == null) {
            dismiss()
            return
        }
        mTipParams?.let { params ->
            dialog?.window?.let {
                if (params.fullScreen) {
                    it.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)
                }
                it.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
                it.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                it.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
                it.statusBarColor = Color.TRANSPARENT
            }

            val tvTitle = getRootView()!!.findViewById<TextView>(R.id.tvTitle)
            val tvLeftButton = getRootView()!!.findViewById<TextView>(R.id.tvLeftButton)
            val tvRightButton = getRootView()!!.findViewById<TextView>(R.id.tvRightButton)
            val tvTipContent = getRootView()!!.findViewById<FrameLayout>(R.id.tvTipContent)
            if (params.tipTitleVisible) {
                tvTitle.visibility = View.VISIBLE
                tvTitle.text = params.tipTitle
            } else {
                tvTitle.visibility = View.GONE
            }

            if (params.leftButtonVisible) {
                tvLeftButton.visibility = View.VISIBLE
                tvLeftButton.text = params.leftButtonText
                tvLeftButton.setTextColor(params.leftButtonColor)
                tvLeftButton.setBackgroundResource(params.leftButtonBackground)
                tvLeftButton.setOnClickListener {
                    dismiss()
                    params.listenerOfLeftBtn?.invoke(it)
                }
            } else {
                tvLeftButton.visibility = View.GONE
            }

            if (params.rightButtonVisible) {
                if (params.useSmallOneBtn && tvLeftButton.visibility == View.GONE) {
                    val layoutParams = tvRightButton.layoutParams as ConstraintLayout.LayoutParams
                    layoutParams.width = AppUtil.dip2px(requireContext(), 117F)
                    layoutParams.marginStart = 0
                    layoutParams.marginEnd = 0
                    layoutParams.goneLeftMargin = 0
                    tvLeftButton.layoutParams = layoutParams
                }
                tvRightButton.visibility = View.VISIBLE
                tvRightButton.text = params.rightButtonText
                tvRightButton.setTextColor(params.rightButtonColor)
                tvRightButton.setBackgroundResource(params.rightButtonBackground)
                tvRightButton.setOnClickListener {
                    dismiss()
                    params.listenerOfRightBtn?.invoke(it)
                }
            } else {
                tvRightButton.visibility = View.GONE
            }
            tvTipContent.addView(params.fillContainer?.invoke(requireContext(), tvTipContent)
                ?: TextView(context).apply {
                    val dp20 = AppUtil.dip2px(context, 20F)
                    val dp10 = AppUtil.dip2px(context, 10F)
                    setPadding(dp20, dp10, dp20, dp20)
                    text = params.tipContent
                    setTextColor(params.tipContentColor)
                    setTextSize(TypedValue.COMPLEX_UNIT_DIP, 14F)
                    gravity = Gravity.CENTER
                })
        }
    }

    override fun onDismiss(dialog: DialogInterface) {
        super.onDismiss(dialog)

        mTipParams?.onDismissListener?.invoke()
    }

    companion object {
        fun show(activity: FragmentActivity, params: TipDialogParams, touchCancel: Boolean = true): TipDialogFragment? {
            return newClass(TipDialogFragment::class.java, null)?.apply {
                mTipParams = params
                setTouchCancel(touchCancel)
                show(activity.supportFragmentManager, TipDialogFragment::class.java.name)
            }
        }
    }
}