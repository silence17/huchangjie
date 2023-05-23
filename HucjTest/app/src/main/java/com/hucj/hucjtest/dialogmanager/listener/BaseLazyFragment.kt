package com.hucj.hucjtest.dialogmanager.listener

import android.os.Bundle
import androidx.fragment.app.Fragment

/**
 * 添加fragment显隐状态改变的回调 [onFragmentVisibleChanged]
 *
 * Created by huchangjie on 2019/1/4.
 */
abstract class BaseLazyFragment : Fragment() {

    var isFragmentVisible = false
        private set

    //上次可见的时间戳
    private var preVisibility: Long? = null

    //生命周期内可见的总事件数
    var totalVisibility: Long = 0


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        dealFragmentVisibleChange()
    }

    override fun setUserVisibleHint(isVisibleToUser: Boolean) {
        super.setUserVisibleHint(isVisibleToUser)
        dealFragmentVisibleChange()
    }

    override fun onHiddenChanged(hidden: Boolean) {
        super.onHiddenChanged(hidden)
        dealFragmentVisibleChange()
    }

    override fun onResume() {
        super.onResume()
        dealFragmentVisibleChange()
    }

    override fun onPause() {
        super.onPause()
        dealFragmentVisibleChange()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        isFragmentVisible = false
    }

    /**
     *
     */
    private fun dealFragmentVisibleChange() {

        val visible = !isFragmentSelfHidden(this) && !isAncestorFragmentHidden()

        if (isFragmentVisible != visible) {
            isFragmentVisible = visible
            //统计fragment可见时间
            if (visible) {
                preVisibility = System.currentTimeMillis()
            } else if (preVisibility != null) {
                totalVisibility = System.currentTimeMillis() - preVisibility!!
            }
            onFragmentVisibleChanged(visible)
            childFragmentManager.fragments.forEach {
                if (it is BaseLazyFragment) {
                    it.dealFragmentVisibleChange()
                }
            }
        }
    }

    private fun isParentFragmentHidden(fragment: Fragment) = fragment.parentFragment != null && isFragmentSelfHidden(fragment.requireParentFragment())

    private fun isFragmentSelfHidden(fragment: Fragment) = fragment.isHidden || !fragment.userVisibleHint || !isResumed

    /**
     * 用 isHidden() 方法判断所属的所有上层 fragment 中是否有 hidden 的
     */
    private fun isAncestorFragmentHidden(fragment: Fragment = this): Boolean = when {
        isParentFragmentHidden(fragment) -> true
        fragment.parentFragment != null -> isAncestorFragmentHidden(fragment.requireParentFragment())
        else -> false
    }

    /**
     * fragment 显隐状态改变。
     */
    protected abstract fun onFragmentVisibleChanged(visible: Boolean)

}






