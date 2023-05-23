package com.hucj.hucjtest.dialogmanager;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import com.hucj.hucjtest.dialogmanager.listener.ListenerFragment;

import java.lang.reflect.Field;
import java.util.Comparator;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.PriorityBlockingQueue;

/**
 * @author huchangjie1
 * @date 2022/9/26
 * <p>
 * dialog显示条件：
 * 1、dialog queue != null
 * 2、依附的activity/fragment容器
 * 3、dialog dismiss后再行
 * <p>
 * <p>
 * 技术点：
 * 1、监控Activity、Fragment生命周期
 */
public class DialogHelper2<T> {

    private static final String TAG = "DialogHelper2";
    static final String LISTENER_FRAGMENT_TAG = "listener_fragment_tag";

    private final Object lock = new Object();

    /**
     * 依附activity/fragment
     */
    private final T parent;

    /**
     * 将要显示的dialog
     */
    private DialogMessage nextDialog;

    /**
     * 当前展示的dialog
     */
    private DialogMessage currentDialog;

    static ExecutorService threadPool = Executors.newCachedThreadPool();

    //activity、fragment是否能交互 false：能交互； true：能交互
    private boolean mIsHidden;
    private FragmentManager manager;

    //优先级阻塞队列
    private final PriorityBlockingQueue<DialogMessage> queue
            = new PriorityBlockingQueue<>(8, new Comparator<DialogMessage>() {

        @Override
        public int compare(DialogMessage o1, DialogMessage o2) {
            //对比优先级
            return o2.priority - o1.priority;
        }
    });


    /**
     * @param parent 依附页面 activity/fragment
     */
    public DialogHelper2(T parent) {
        this.parent = parent;

        if (parent instanceof FragmentActivity) {
            this.manager = ((FragmentActivity) parent).getSupportFragmentManager();
            //监听Activity的可见
            activityMonitor((Activity) parent);
        } else if (parent instanceof Fragment) {
            this.manager = ((Fragment) parent).getChildFragmentManager();
            //监听目标Fragment生命周期
            fragmentMonitor((Fragment) parent);
        }
    }

    /**
     * 插入子fragment，用于监听fragment状态
     *
     * @param fragment
     */
    private void fragmentMonitor(Fragment fragment) {
        ListenerFragment mListenerFragment = ListenerFragment.newInstance(new ListenerFragment.FragmentLifecycle() {

            @Override
            public void onResume() {
            }

            @Override
            public void onPause() {
            }

            @Override
            public void onDestroy() {
                if (currentDialog != null && currentDialog.dialog.getShowsDialog()) {
                    currentDialog.dialog.dismiss();
                }
            }

            @Override
            public void onVisible(boolean isVisible) {
                if (isVisible) {
                    synchronized (lock) {
                        //展示下一个dialog && 当前dialog不展示
                        if (nextDialog != null && nextDialog.isAutoNext) {
                            lock.notify();
                        }
                    }
                }
                mIsHidden = !isVisible;
            }
        });
        // 由于Fragment的bug，必须将mChildFragmentManager的accessible设为true
        compatibleFragment(fragment);
        fragment.getChildFragmentManager()
                .beginTransaction()
                .add(mListenerFragment, LISTENER_FRAGMENT_TAG)
                .commitAllowingStateLoss();
    }


    /**
     * For bug of Fragment in Android
     * https://issuetracker.google.com/issues/36963722
     *
     * @param fragment 绑定子fragment
     */
    private void compatibleFragment(Fragment fragment) {
        try {
            Field childFragmentManager = Fragment.class.getDeclaredField("mChildFragmentManager");
            childFragmentManager.setAccessible(true);
            childFragmentManager.set(fragment, null);
        } catch (NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }


    /**
     * 监听Activity可见状态
     *
     * @param activity 目标Activity
     */
    private void activityMonitor(Activity activity) {
        activity.getApplication().registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
            }

            @Override
            public void onActivityStarted(@NonNull Activity activity) {
            }

            @Override
            public void onActivityResumed(@NonNull Activity activity) {
                if (activity == parent) {
                    mIsHidden = false;
                    synchronized (lock) {
                        //展示下一个dialog && 当前dialog不展示
                        if (nextDialog != null && nextDialog.isAutoNext) {
                            lock.notify();
                        }
                    }
                }
            }

            @Override
            public void onActivityPaused(@NonNull Activity activity) {
                if (activity == parent) {
                    mIsHidden = true;
                }
            }

            @Override
            public void onActivityStopped(@NonNull Activity activity) {
            }

            @Override
            public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
            }

            @Override
            public void onActivityDestroyed(@NonNull Activity activity) {
                if (activity == parent) {
                    activity.getApplication().unregisterActivityLifecycleCallbacks(this);
                    if (currentDialog != null && currentDialog.dialog.getShowsDialog()) {
                        currentDialog.dialog.dismiss();
                    }
                }
            }
        });
    }


    /**
     * @param bean dialog bean
     */
    void addDialog(DialogMessage bean) {
        queue.put(bean);
        Log.e(TAG, "queue.total:" + (queue.size()) + " priority: " + bean.priority + " thread id: " + Thread.currentThread().getId());
    }


    /**
     * 展示下一个dialog
     */
    @SuppressWarnings("all")
    synchronized void show() {
        threadPool.submit(new Runnable() {
            @Override
            public void run() {

                Log.e(TAG, Thread.currentThread().getId() + "");
                try {
                    synchronized (lock) {
                        while (true) {
                            //阻塞队列
                            nextDialog = queue.take();

                            Log.e(TAG, "queue.take(): " + (nextDialog == null));
                            if (mIsHidden) {
                                lock.wait();
                            }
                            if (nextDialog != null) {
                                //展示dialog
                                new Handler(Looper.getMainLooper()).post(new Runnable() {
                                    @Override
                                    public void run() {
                                        //展示dialog
                                        nextDialog.dialog.show(manager, "");
                                        //回收对象
                                        if (currentDialog != null) {
                                            currentDialog.recycle();
                                        }
                                        currentDialog = nextDialog;
                                        nextDialog = null;
                                    }
                                });
                                lock.wait();
                                Log.e(TAG, "dialog show wait thread id:" + Thread.currentThread().getId());
                            }
                        }
                    }
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
            }
        });
    }

    /**
     * 展示下一个
     */
    public void showNext() {
        synchronized (lock) {
            lock.notify();
        }
    }

    /**
     * 清除队列
     */
    void removeAll() {
        queue.clear();
    }

    /**
     * 队列中清除指定dialog
     *
     * @param bean 目标dialog
     */
    void remoceById(DialogMessage bean) {
        //queue.remove(bean);
    }

    void performDestroy(){

    }

}
