package com.hucj.hucjtest.coroutine

import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
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

    fun coroutineRun() {
        runBlocking {
            val coroutineExceptionHandler = CoroutineExceptionHandler(handler = { _, exception ->
                println("coroutineContext: 协程上下文异常啦: ${exception.message} ...")
            })
            val scope =
                CoroutineScope(Job() + Dispatchers.Main + CoroutineName("我的协程CoroutineScope") + coroutineExceptionHandler)
            val job = scope.launch(Dispatchers.IO) {
                println("======1:${coroutineContext[Job]}  ${Thread.currentThread().name}")
                val result = async {
                    println("======2:${coroutineContext[Job]}  ${Thread.currentThread().name}")
                    "OK"
                }
                result.await()
            }

            job.join()
        }
    }
}