package com.hucj.hucjtest.base64

import org.json.JSONObject
import java.io.Serializable
import java.lang.Exception


data class User(
    var id: Int? = null,
    var userId: Int = 0,
    var shopId: Int = 0,
    var itemId: Int? = null,
    var ident: Int? = null
) : Serializable {

    companion object {
        private val serialVersionUID = 9147680971847280207L
    }

    override fun toString(): String {
        return "User(id=$id, userId=$userId, shopId=$shopId, itemId=$itemId, ident=$ident)"
    }


}


fun main() {

    Thread(object :Runnable{
        override fun run() {
            val user = User()
            val userStr = Base64Util.objectToString(user)

            println("TAG==== $userStr")

            val user1 = ModelUtil.modelA2B(Base64Util.stringToObject(userStr), User::class.java)
            println("TAG" + "==== ${user1.toString()}")
        }

    }).start()
}