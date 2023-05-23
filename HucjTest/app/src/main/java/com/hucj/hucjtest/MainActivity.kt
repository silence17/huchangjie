package com.hucj.hucjtest

import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.content.Intent
import android.os.*
import android.util.Log
import android.view.View
import android.view.animation.BounceInterpolator
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.hucj.hucjtest.dialogmanager.FiveActivity
import com.hucj.hucjtest.flutter.FlutterExampleActivity
import com.hucj.testlib.CommonUtil


class MainActivity : AppCompatActivity() {

    private var handle: MyHandle = MyHandle()

    private var view: View? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<DancingView>(R.id.dancing_view).startAnimations();
        val view = findViewById<TextView>(R.id.hello)
        view.setOnClickListener {
            CommonUtil.printLog()
        }

        val objectAnimator: ObjectAnimator = ObjectAnimator.ofFloat(view, "translationY", 300f, 0f)
//        val objectAnimator1 = ObjectAnimator.ofFloat(view, "alpha", 0.1f, 1f)
        val animatorSet = AnimatorSet()
        animatorSet.playSequentially(objectAnimator)
        animatorSet.duration = 2000
        animatorSet.interpolator = BounceInterpolator()
        animatorSet.start()

        findViewById<Button>(R.id.jump)
            .setOnClickListener {

                Handler(Looper.getMainLooper()).sendEmptyMessage(1)


                val labels: MutableList<String> = mutableListOf<String>()
                var last: String? = labels.last()

                startActivity(Intent(this, MemoryTestActivity::class.java))
            }
        findViewById<Button>(R.id.jump3)
            .setOnClickListener {

                startActivity(Intent(this, ThreeActivity::class.java))
            }
        findViewById<Button>(R.id.check_memory)
            .setOnClickListener {
                handle.sendEmptyMessage(0)
            }
        findViewById<Button>(R.id.memory_shake)
            .setOnClickListener {
                startActivity(Intent(this, FourActivity::class.java))
            }
        findViewById<Button>(R.id.dialog_test)
            .setOnClickListener {
                startActivity(Intent(this, FiveActivity::class.java))
            }

        findViewById<Button>(R.id.base64_test)
            .setOnClickListener {

//                Thread(object : Runnable {
//                    override fun run() {
////                        val user = Personal("123", "Token")
////                        val userStr =
////                            "rO0ABXNyACFjb20uaHVjai5odWNqdGVzdC5iYXNlNjQuUGVyc29uYWxnr7av HSsllgIAAkwABG5hbWV0ABJMamF2YS9sYW5nL1N0cmluZztMAAZ1c2VySWRx AH4AAXhwdAAFVG9rZW50AAMxMjM="
//
////                        val user = User()
//                        val userStr = "rO0ABXNyAB1jb20uaHVjai5odWNqdGVzdC5iYXNlNjQuVXNlcn7zF2CdjqZP AgAESQAGc2hvcElkSQAGdXNlcklkTAACaWR0ABNMamF2YS9sYW5nL0ludGVn ZXI7TAAGaXRlbUlkcQB+AAF4cAAAAAAAAAAAcHA="
//
////                        val userStr = Base64Util.objectToString(user)
//
//                        Log.e("TAG", "==== $userStr")
//
//                        val obj = Base64Util.stringToObject(userStr)
//                        Log.e("TAG", "base64转Obj： ${obj}")
//                    }
//
//                }).start()

                val user = User1()
            }
        findViewById<View>(R.id.flutter_btn).setOnClickListener {

//            startActivity(
//                withNewEngine()
//                    .initialRoute("/third")
//                    .build(this)
//            )

            //添加flutter回调
//            val intent = FlutterExampleActivity
//                .withNewEngine()
//                .initialRoute("/second")
//                .build(this);
//            intent.setClass(this, FlutterExampleActivity::class.java)
//            startActivity(intent)

            startActivity(Intent(this, FlutterExampleActivity::class.java))

        }
    }

    data class User1(var name: String? = null, var age: Int? = null, var shopId: String? = null) {
        var authStatus: String? = null
    }

    override fun onSaveInstanceState(outState: Bundle, outPersistentState: PersistableBundle) {
        super.onSaveInstanceState(outState, outPersistentState)

        Log.e("====", "++++");
    }


    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)

        Log.e("====", "++++1");
    }


    internal class MyHandle : Handler(Looper.getMainLooper()) {

        override fun handleMessage(msg: Message) {
            super.handleMessage(msg)

            //app已经占用，但实际并未使用的内存
            val free = Runtime.getRuntime().freeMemory()

            //app可用的最大内存
            val javaMax = Runtime.getRuntime().maxMemory()
            //app已占用的内存
            val javaTotal = Runtime.getRuntime().totalMemory()
            val javaUsed = javaTotal - Runtime.getRuntime().freeMemory()
            // Java 内存使用超过最大限制的 85%
            val proportion = javaUsed.toFloat() / javaMax
            Log.e("===========", "javaMax:  $javaMax")
            Log.e("===========", "javaTotal:  $javaTotal")
            Log.e("===========", "free:  $free")
            Log.e("===========", "javaUsed:  $javaUsed")
            Log.e("===========", "proportion:  $proportion")
        }
    }

}