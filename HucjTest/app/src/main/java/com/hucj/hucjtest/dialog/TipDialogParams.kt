package com.hucj.hucjtest.dialog

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.FrameLayout
import com.hucj.hucjtest.R
import java.io.Serializable

class TipDialogParams private constructor(var builder: Builder) : Serializable {

    internal var tipTitle: String
    internal var tipContent: String
    internal var leftButtonText: String
    internal var rightButtonText: String
    internal var tipContentColor: Int
    internal var leftButtonColor: Int
    internal var rightButtonColor: Int
    internal var leftButtonBackground: Int
    internal var rightButtonBackground: Int
    internal var tipTitleVisible: Boolean
    internal var leftButtonVisible: Boolean
    internal var rightButtonVisible: Boolean
    internal var useSmallOneBtn: Boolean
    internal var fullScreen: Boolean

    /**
     * 填充container,自定义view
     */
    internal var fillContainer: ((context: Context, container: FrameLayout) -> View)?
    internal var listenerOfLeftBtn: ((v: View) -> Unit)?
    internal var listenerOfRightBtn: ((v: View) -> Unit)?
    internal var onDismissListener: (() -> Unit)? = null

    init {
        tipTitle = builder.tipTitle
        tipContent = builder.tipContent
        leftButtonText = builder.leftButtonText
        rightButtonText = builder.rightButtonText
        tipContentColor = builder.tipContentColor
        leftButtonColor = builder.leftButtonColor
        rightButtonColor = builder.rightButtonColor
        leftButtonBackground = builder.leftButtonBackground
        rightButtonBackground = builder.rightButtonBackground
        tipTitleVisible = builder.tipTitleVisible
        leftButtonVisible = builder.leftButtonVisible
        rightButtonVisible = builder.rightButtonVisible
        useSmallOneBtn = builder.useSmallOneBtn
        fillContainer = builder.fillContainer
        fullScreen = builder.fullScreen
        listenerOfLeftBtn = builder.listenerOfLeftBtn
        listenerOfRightBtn = builder.listenerOfRightBtn
        onDismissListener = builder.onDismissListener
    }


    class Builder : Serializable {
        internal var tipTitle: String = "提示"
        internal var tipContent: String = ""
        internal var leftButtonText: String = "取消"
        internal var rightButtonText: String = "确定"
        internal var tipTitleVisible: Boolean = true
        internal var leftButtonVisible: Boolean = true
        internal var rightButtonVisible: Boolean = true
        internal var useSmallOneBtn: Boolean = false
        internal var fullScreen: Boolean = false
        internal var tipContentColor: Int = Color.parseColor("#333333")
        internal var leftButtonColor: Int = Color.parseColor("#F2270C")
        internal var rightButtonColor: Int = Color.parseColor("#FFFFFF")
        internal var leftButtonBackground: Int = R.drawable.shape_round_stroke
        internal var rightButtonBackground: Int = R.drawable.shape_gradient_round_btn
        internal var fillContainer: ((context: Context, container: FrameLayout) -> View)? = null
        internal var listenerOfLeftBtn: ((v: View) -> Unit)? = null
        internal var listenerOfRightBtn: ((v: View) -> Unit)? = null
        internal var onDismissListener: (() -> Unit)? = null

        fun tipTitle(value: String): Builder {
            tipTitle = value
            return this
        }

        fun tipContent(value: String): Builder {
            tipContent = value
            return this
        }

        fun oneButtonText(value: String): Builder {
            leftButtonVisible(false)
            rightButtonText(value)
            return this
        }

        fun leftButtonText(value: String): Builder {
            leftButtonText = value
            return this
        }

        fun rightButtonText(value: String): Builder {
            rightButtonText = value
            return this
        }

        fun tipContentColor(value: Int): Builder {
            tipContentColor = value
            return this
        }

        fun oneButtonColor(value: Int): Builder {
            rightButtonColor = value
            return this
        }

        fun leftButtonColor(value: Int): Builder {
            leftButtonColor = value
            return this
        }

        fun rightButtonColor(value: Int): Builder {
            rightButtonColor = value
            return this
        }

        fun leftButtonBackground(value: Int): Builder {
            leftButtonBackground = value
            return this
        }

        fun rightButtonBackground(value: Int): Builder {
            rightButtonBackground = value
            return this
        }

        fun tipTitleVisible(visible: Boolean): Builder {
            tipTitleVisible = visible
            return this
        }

        fun leftButtonVisible(visible: Boolean): Builder {
            leftButtonVisible = visible
            return this
        }

        fun rightButtonVisible(visible: Boolean): Builder {
            rightButtonVisible = visible
            return this
        }

        fun useSmallOneBtn(smallBtn: Boolean): Builder {
            useSmallOneBtn = smallBtn
            return this
        }

        fun fillContainer(value: ((context: Context, container: FrameLayout) -> View)): Builder {
            fillContainer = value
            return this
        }

        fun listenerOfOneBtn(value: ((v: View) -> Unit)): Builder {
            listenerOfRightBtn(value)
            return this
        }

        fun listenerOfLeftBtn(value: ((v: View) -> Unit)): Builder {
            listenerOfLeftBtn = value
            return this
        }

        fun listenerOfRightBtn(value: ((v: View) -> Unit)): Builder {
            listenerOfRightBtn = value
            return this
        }

        fun fullScreen(value: Boolean): Builder {
            fullScreen = value
            return this
        }

        fun setOnDismiss(listener: (() -> Unit)?): Builder {
            this.onDismissListener = listener
            return this
        }

        fun build(): TipDialogParams {
            return TipDialogParams(this)
        }
    }
}