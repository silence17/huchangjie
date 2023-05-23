package com.hucj.hucjtest;

import android.view.animation.Interpolator;

/**
 * @ProjectName: jdjch
 * @Author: huchangjie1
 * @CreateDate: 2022/3/2
 * @Version: 1.0
 * @Description:
 */
public class DancingInterpolator implements Interpolator {
    @Override
    public float getInterpolation(float input) {
        return (float) (1 - Math.exp(-3 * input) * Math.cos(10 * input));
    }
}
