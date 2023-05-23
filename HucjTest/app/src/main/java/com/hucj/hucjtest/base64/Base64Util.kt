package com.hucj.hucjtest.base64

import android.text.TextUtils
import java.io.*

/**
 * @author yishengwei
 */
object Base64Util {
    private val legalChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".toCharArray()

    /**
     * 将对象转换成byte数组，并将其进行base64编码
     */
    fun objectToString(any: Any): String {
        var str = ""
        try {
            val baos = ByteArrayOutputStream()
            val oos = ObjectOutputStream(baos)
            oos.writeObject(any)
            str = encodeBASE64(baos.toByteArray())
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return str
    }

    /**
     * 对Base64格式的字符串进行解码
     */
    fun stringToObject(str: String): Any? {
        var obj: Any? = null
        try {
            if (!TextUtils.isEmpty(str)) {
                val base64Bytes = Base64Util.decodeBASE64(str)
                val bais = ByteArrayInputStream(base64Bytes)
                val ois = ObjectInputStream(bais)
                obj = ois.readObject()
            }
        } catch (e: IOException) {
            e.printStackTrace()
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
        }

        return obj
    }

    /**
     * data[]进行编码
     *
     * @param data
     * @return
     */
    fun encodeBASE64(data: ByteArray): String {
        val start = 0
        val len = data.size
        val buf = StringBuilder(data.size * 3 / 2)

        val end = len - 3
        var i = start
        var n = 0

        while (i <= end) {
            val d = (data[i].toInt() and 0x0ff shl 16
                    or (data[i + 1].toInt() and 0x0ff shl 8)
                    or (data[i + 2].toInt() and 0x0ff))

            buf.append(legalChars[d shr 18 and 63])
            buf.append(legalChars[d shr 12 and 63])
            buf.append(legalChars[d shr 6 and 63])
            buf.append(legalChars[d and 63])

            i += 3

            if (n++ >= 14) {
                n = 0
                buf.append(" ")
            }
        }

        if (i == start + len - 2) {
            val d = data[i].toInt() and 0x0ff shl 16 or (data[i + 1].toInt() and 255 shl 8)

            buf.append(legalChars[d shr 18 and 63])
            buf.append(legalChars[d shr 12 and 63])
            buf.append(legalChars[d shr 6 and 63])
            buf.append("=")
        } else if (i == start + len - 1) {
            val d = data[i].toInt() and 0x0ff shl 16

            buf.append(legalChars[d shr 18 and 63])
            buf.append(legalChars[d shr 12 and 63])
            buf.append("==")
        }

        return buf.toString()
    }


    /**
     * Decodes the given Base64 encoded String to a new byte array. The byte
     * array holding the decoded data is returned.
     */

    fun decodeBASE64(s: String): ByteArray {

        var bos: ByteArrayOutputStream? = ByteArrayOutputStream()
        try {
            decode(s, bos)
        } catch (e: IOException) {
            throw RuntimeException()
        }

        val decodedBytes = bos!!.toByteArray()
        try {
            bos.close()
            bos = null
        } catch (ex: IOException) {
            System.err.println("Error while decoding BASE64: " + ex.toString())
        }

        return decodedBytes
    }

    private fun decode(c: Char): Int {
        return when (c) {
            in 'A'..'Z' -> c.toInt() - 65
            in 'a'..'z' -> c.toInt() - 97 + 26
            in '0'..'9' -> c.toInt() - 48 + 26 + 26
            else -> when (c) {
                '+' -> 62
                '/' -> 63
                '=' -> 0
                else -> throw RuntimeException("unexpected code: $c")
            }
        }
    }

    @Throws(IOException::class)
    private fun decode(s: String, os: OutputStream?) {
        var i = 0

        val len = s.length

        while (true) {
            while (i < len && s[i] <= ' ')
                i++

            if (i == len)
                break

            val tri = ((decode(s[i]) shl 18)
                    + (decode(s[i + 1]) shl 12)
                    + (decode(s[i + 2]) shl 6)
                    + decode(s[i + 3]))

            os?.write(tri shr 16 and 255)
            if (s[i + 2] == '=')
                break
            os?.write(tri shr 8 and 255)
            if (s[i + 3] == '=')
                break
            os?.write(tri and 255)

            i += 4
        }
    }
}