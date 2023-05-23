package com.hucj.hucjtest.dialogmanager;

import android.util.Log;

import androidx.fragment.app.DialogFragment;

import java.io.Serializable;

/**
 * @author : huchangjie1
 * @date : 2022/9/26
 */
public class DialogMessage implements Serializable {

    private static final String TAG = "DialogMessage";

    public static final Object sPoolSync = new Object();

    //对象池最大缓存量
    private static final int MAX_POOL_SIZE = 3;

    //对象池
    private static DialogMessage sPool;

    private static int sPoolSize = 0;

    //是否自动展示下一个
    boolean isAutoNext = true;

    DialogFragment dialog;

    //优先级
    int priority;

    //单向链表
    DialogMessage next;


    private DialogMessage() {
    }

    public static DialogMessage obtain() {
        synchronized (sPoolSync) {
            if (sPool != null) {
                DialogMessage m = sPool;
                sPool = m.next;
                m.next = null;
                sPoolSize--;
                Log.e(TAG, "obtain dialogMessage ");
                return m;
            }
        }
        return new DialogMessage();
    }

    public void recycle() {
        // Mark the message as in use while it remains in the recycled object pool.
        // Clear out all other details.
        dialog = null;
        priority = -1;
        isAutoNext = false;

        synchronized (sPoolSync) {
            if (sPoolSize < MAX_POOL_SIZE) {
                next = sPool;
                sPool = this;
                sPoolSize++;
                Log.e(TAG, "recycle dialogMessage ");
            }
        }
    }
}