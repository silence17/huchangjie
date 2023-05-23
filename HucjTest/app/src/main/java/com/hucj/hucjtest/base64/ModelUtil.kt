package com.hucj.hucjtest.base64

import android.util.Log
import com.google.gson.Gson

object ModelUtil {
    /**
     * 把modelA对象的属性值赋值给bClass对象的属性。
     * @param modelA
     * @param bClass
     * @param <T>
     * @return
     */
    fun <A, B> modelA2B(modelA: A, bClass: Class<B>): B? {
        try {
            val gson = Gson()
            val gsonA = gson.toJson(modelA)
            return gson.fromJson(gsonA, bClass)
        } catch (e: Exception) {
            Log.e("ModelUtil", "modelA2B Exception=" + modelA + " " + bClass + " " + e.message)
            return null
        }
    }
}