package com.hucj.hucjtest.coroutine

import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

fun main(args: Array<String>) {
    CoroutineClass().coroutineRun()
    println("main在class外执行!")
}

/**
 * 协程测试类
 */
class CoroutineClass {

    @OptIn(DelicateCoroutinesApi::class)
    fun coroutineRun() {
        runBlocking {
            val coroutineExceptionHandler = CoroutineExceptionHandler(handler = { _, exception ->

                println("异常: ${exception.message}")
            })

            // 协程上下文CoroutineContext 主要用来定义协程行为的元素
            // 协程CoroutineContext上下文组成公式  =  Job+默认值 +  继承的CoroutineContext  +参数
            //
            // SupervisorJob() 与 supervisorScope的区别:
            //   SupervisorJob()：
            //    val supervisor = CoroutineScope(SupervisorJob())
            //    一个子协程的运行失败不会影响其他的子协程的运行,也不会将异常传递给它的父级，他会让子协程自己处理异常。
            //   supervisorScope:当作业自身执行失败的时候,其所有子协程都会被全部取消
            val scope =
                CoroutineScope(Job() + Dispatchers.Main + CoroutineName("我的协程CoroutineScope") + coroutineExceptionHandler)
            val job = scope.launch(Dispatchers.IO) {
                println("======1:${coroutineContext[Job]}  ${Thread.currentThread().name}  ${Thread.currentThread().id}")
                val result = async {
                    println("======2:${coroutineContext[Job]}  ${Thread.currentThread().name} ${Thread.currentThread().id}")
                    "OK"
                }
                result.await()


                launch {
                    println("======3:  ${Thread.currentThread().id}")
                    throw IllegalArgumentException()
                }
                println("======4:  ${Thread.currentThread().id}")
            }

            job.join()
            //子协程取消时,这个取消CancellationException异常 不会往上抛给父协程的,不会影响不会取消父协程。
            job.cancel()
        }
    }
}