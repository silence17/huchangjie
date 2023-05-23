package com.hucj.hucjtest.dialogmanager.listener;

import androidx.fragment.app.Fragment;

import java.util.List;

/**
 * @author : huchangjie1
 * @date 2022/11/7
 * Description:
 */
public class ListenerFragment extends BaseLazyFragment {

    public interface FragmentLifecycle {

        void onResume();

        void onPause();

        /**
         * @param isVisible true:可见
         */
        void onVisible(boolean isVisible);

        void onDestroy();
    }

    private FragmentLifecycle mFragmentLifecycle;


    public static ListenerFragment newInstance(FragmentLifecycle lifecycler) {
        ListenerFragment fragment = new ListenerFragment();
        fragment.mFragmentLifecycle = lifecycler;
        return fragment;
    }

    @Override
    public void onResume() {
        super.onResume();
        mFragmentLifecycle.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mFragmentLifecycle.onPause();
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mFragmentLifecycle.onDestroy();
    }

    @Override
    protected void onFragmentVisibleChanged(boolean visible) {
        mFragmentLifecycle.onVisible(visible);
    }
}
