package com.hucj.hucjtest.util

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.graphics.Point
import android.net.ConnectivityManager
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.Settings
import android.telephony.TelephonyManager
import android.text.TextUtils
import android.view.Display
import android.view.Gravity
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import java.io.File
import java.io.UnsupportedEncodingException
import java.net.URI
import java.net.URLEncoder
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*
import java.util.regex.Pattern


object AppUtil {


    fun getRequestParamsMap(url: String, splitChar: String): Map<String, String> {
        var map: Map<String, String> = HashMap()
        try {
            val urlObj = URI(url)
            val queryMapStr = urlObj.query
            map = getRequestParamsMapByString(queryMapStr, splitChar)
        } catch (e: Exception) {
            e.printStackTrace()
            // 不做处理
        }

        return map
    }

    fun getRequestParamsMapByString(queryMapStr: String?, splitChar: String): Map<String, String> {
        val map = HashMap<String, String>()
        if (queryMapStr != null) {
            val params =
                queryMapStr.split(splitChar.toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            for (param in params) {
                val firstEqual = param.indexOf("=")
                if (firstEqual > 0) {
                    val name = param.substring(0, firstEqual)
                    val value = param.substring(firstEqual + 1, param.length)
                    map[name] = value
                }
            }
        }
        return map
    }
    fun isEmpty(str: String, addStr: String): String? {
        return if (TextUtils.isEmpty(str)) "" else str + addStr
    }

    fun isEmpty(str: String): String? {
        return isEmpty(str, "")
    }


    /**
     * @param str 识别或者手输入的字符串
     * @return 如果VIN位数够17位，并且是大写字母和数字的组合，返回非空字符串；否则返回空字符串
     */
    fun getCorrectVin(str: String?): String {
        if (null == str) {
            return ""
        }
        if (str.length != 17) {
            return ""
        }
        val replaceAfterStr = str.replace("I", "1")
            .replace("O", "0")
            .replace("Q", "0")
        val numberRegex = "^[0-9]*$"
        val letterRegex = "^[A-Za-z]+$"
        if (Pattern.matches(numberRegex, replaceAfterStr)
            || Pattern.matches(letterRegex, replaceAfterStr)
        ) {
            return ""
        }
        val vinRegex = "^[A-Z0-9]{17}$"
        return if (Pattern.matches(vinRegex, replaceAfterStr)) {
            replaceAfterStr
        } else ""
    }
    @JvmStatic
    fun isSDPresent(): Boolean {
        return Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED
    }

    fun getTempFileDir(context: Context, dirPath: String): String? {
        val filePath =
            (if (isSDPresent()) context.externalCacheDir?.absolutePath else context.cacheDir.absolutePath) + File.separator + dirPath
        File(filePath).mkdirs()
        return filePath
    }

    fun getScreenWidth(context: Context): Int {
        val defaultDisplay: Display =
            (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).getDefaultDisplay()
        val point = Point()
        defaultDisplay.getSize(point)
        return point.x
    }

    fun getScreenHeight(context: Context): Int {
        val defaultDisplay: Display =
            (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).getDefaultDisplay()
        val point = Point()
        defaultDisplay.getSize(point)
        return point.y
    }

    /**
     * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
     */
    fun dip2px(context: Context, dpValue: Float): Int {
        val scale = context.resources.displayMetrics.density
        return (dpValue * scale + 0.5f).toInt()
    }

//    /**
//     * 由于京车会商户和京东云修公用部分老接口,需要区分内外版本号,调用接口版本X统一加9(从10.0.0开始)
//     */
//    @JvmStatic
//    fun getInternelVersionName(): String {
////        val oldName = BuildConfig.VERSION_NAME
//        val list = oldName?.split(".").toMutableList()
//        list[0] = (list.get(0).toInt() + 9).toString()
//        return list.joinToString(".")
//    }

    @JvmStatic
    fun signatureByMD5(source: String): String? {
        try {
            val md = MessageDigest.getInstance("MD5")
            md.reset()
            md.update(source.toByteArray())
            val mdbytes = md.digest()
            val hexString = java.lang.StringBuilder()
            for (i in mdbytes.indices) {
                val hex = Integer.toHexString(0xff and mdbytes[i].toInt())
                if (hex.length == 1) hexString.append('0')
                hexString.append(hex)
            }
            return hexString.toString()
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
        }
        return null
    }

    @JvmStatic
    fun showLongMessage(mContext: Context?, text: CharSequence?) {
        if (text != null && text.isNotEmpty()) {
            Toast.makeText(mContext, text, Toast.LENGTH_LONG).show()
        }
    }

    @JvmStatic
    fun showShortMessage(mContext: Context?, text: CharSequence?) {
        if (!TextUtils.isEmpty(text)) {
            Toast.makeText(mContext, text, Toast.LENGTH_SHORT).show()
        }
    }

    @JvmStatic
    fun showShortMessage(mContext: Context?, resId: Int) {
        Toast.makeText(mContext, resId, Toast.LENGTH_SHORT).show()
    }

    @JvmStatic
    fun isSimpleMobilePhoneNumber(number: String): Boolean {
        return !TextUtils.isEmpty(number) && number.length == 11
    }

    /**  检测用户名（用户名只支持中文、英文、数字、“-”、“_”的组合，不能使用纯数字；4-20个字符） */
    @JvmStatic
    fun checkUsername(username: String?): Boolean {
//        val regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z-_]{4,20}$"
        val regex = "^[\\u4E00-\\u9FA5A-Za-z0-9_-]{4,20}+\$"
        val p = Pattern.compile(regex)
        val m = p.matcher(username)
        return m.matches()
    }

    /**  检测密码（只支持字母、数字和符号，11-20个字符） */
    @JvmStatic
    fun checkPassword(password: String?): Boolean {
        val regex = "^.{11,20}$"
        val p = Pattern.compile(regex)
        val m = p.matcher(password)
        return m.matches()
    }

    @SuppressLint("MissingPermission")
    @JvmStatic
    fun getNetworkType(context: Context?): Int {
        val UNKNOWN = -1
        val WIFI = 1
        val GPRS = 2
        val TD_SCDMA = 3
        val LTE = 4
        if (context == null) {
            return UNKNOWN
        }
        val connMgr = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkInfo = connMgr.activeNetworkInfo
        if (networkInfo != null && networkInfo.type == ConnectivityManager.TYPE_WIFI) {
            return WIFI
        } else if (networkInfo != null && networkInfo.type == ConnectivityManager.TYPE_MOBILE) {
            val mTelephonyManager =
                context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                    ?: return UNKNOWN
            val networkType = mTelephonyManager.networkType
            return when (networkType) {
                TelephonyManager.NETWORK_TYPE_GPRS, TelephonyManager.NETWORK_TYPE_EDGE, TelephonyManager.NETWORK_TYPE_CDMA, TelephonyManager.NETWORK_TYPE_1xRTT, TelephonyManager.NETWORK_TYPE_IDEN -> GPRS
                TelephonyManager.NETWORK_TYPE_UMTS, TelephonyManager.NETWORK_TYPE_EVDO_0, TelephonyManager.NETWORK_TYPE_EVDO_A, TelephonyManager.NETWORK_TYPE_HSDPA, TelephonyManager.NETWORK_TYPE_HSPA, TelephonyManager.NETWORK_TYPE_EVDO_B, TelephonyManager.NETWORK_TYPE_EHRPD, TelephonyManager.NETWORK_TYPE_HSPAP -> TD_SCDMA
                TelephonyManager.NETWORK_TYPE_LTE -> LTE
                else -> UNKNOWN
            }
        }
        return UNKNOWN
    }

    /**  （只支持字母、数字） */
    @JvmStatic
    fun checkValidateInput(str: String?): Boolean {
        val regex = "^[A-Za-z0-9]+\$"
        val p = Pattern.compile(regex)
        val m = p.matcher(str)
        return m.matches()
    }

    /**  （只支持大写字母、数字） */
    @JvmStatic
    fun checkCapitalNumberInput(str: String?): Boolean {
        val regex = "^[A-Z0-9]+\$"
        val p = Pattern.compile(regex)
        val m = p.matcher(str)
        return m.matches()
    }

    /** 检验是否为纯数字 */
    @JvmStatic
    fun isNumeric(str: String?): Boolean {
        val regex = "^[0-9]*\$"
        val p = Pattern.compile(regex)
        val m = p.matcher(str)
        return m.matches()
    }

    /** 检验是否为纯字母 */
    @JvmStatic
    fun isAlphabet(str: String?): Boolean {
        val regex = "^[A-Za-z]*\$"
        val p = Pattern.compile(regex)
        val m = p.matcher(str)
        return m.matches()
    }

    /** 检验是否为纯特殊字符 */
    @JvmStatic
    fun isAllSpecialCharacter(str: String?): Boolean {
        val regex = "^[`~!@#\$%^&*()_\\-+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？₱¥€£¢]*\$"
        val p = Pattern.compile(regex)
        val m = p.matcher(str)
        return m.matches()
    }

    /**
     * 按照指定大小显示吐司
     *
     * @param text
     */
    @JvmStatic
    fun showMessageBySize(context: Context, text: CharSequence) {
        if (!TextUtils.isEmpty(text) && !TextUtils.isEmpty(text.toString().trim { it <= ' ' })) {
            val mToast = Toast.makeText(context, "", Toast.LENGTH_SHORT)
            val layout = mToast.view as LinearLayout
            val tv = layout.getChildAt(0) as TextView
            tv.textSize = 20f
            mToast.setGravity(Gravity.CENTER, 0, 0)
            mToast.setText(text)
            mToast.show()
        }
    }

}