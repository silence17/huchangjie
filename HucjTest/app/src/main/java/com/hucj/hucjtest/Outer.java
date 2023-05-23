package com.hucj.hucjtest;

/**
 * @ProjectName: jdjch
 * @Author: huchangjie1
 * @CreateDate: 2022/9/24
 * @Version: 1.0
 * @Description:
 */
class Outer {

    void method() {
        //定义在内部，或者在形参
        int num = 3;
        class Inner {
            void show() {
                System.out.println("show.." + num);
            }
        }
        Inner in = new Inner();
        in.show();
    }
}

class Test {
    public static void main(String[] args) {
        //编译失败
        //Cannot refer to a non-final variable num inside an inner class defined in a different method
        new Outer().method();
    }
}