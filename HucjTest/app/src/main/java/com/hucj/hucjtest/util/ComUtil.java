package com.hucj.hucjtest.util;

import android.util.Log;

import java.lang.reflect.Field;

/**
 * @ProjectName: jdjch
 * @Author: huchangjie1
 * @CreateDate: 2022/10/8
 * @Version: 1.0
 * @Description:
 */
public class ComUtil {


    public static void getFiled(Object object) {

        try {

            Class<?> class1 = object.getClass();
            Field[] fields = class1.getDeclaredFields();
            for (Field field : fields) {

                Log.e("Field", "======" + field.getName());
            }

            Field field = class1.getDeclaredField("serialVersionUID");
            field.setAccessible(true);
            long value = field.getLong(object);

            Log.e("Field", "=serialVersionUID=====:  " + value);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }


}
