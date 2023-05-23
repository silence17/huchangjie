import 'package:flutter/material.dart';

/*
 * StatefulWidget生命周期
 */
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;

  void _incrementCounter() {
    //需要刷新 UI 时
    setState(() {
      _counter++;
    });
  }

  void _jumpOtherPage() {
    print("jump other page");

    Navigator.of(context).pushNamed('/second');
  }

  /*
   * 当State 对象插入视图树之后
   * 此函数只会被调用一次，子类通常会重写此方法，在其中进行初始化操作.比如加载网络数据，重写此方法时一定要调用 「super.initState()」
   *
   */
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  ///State 对象的依赖关系发生变化后
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  ///当 widget 配置发生变化时，如调用 setState 触发
  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  ///widget 不可见时
  @override
  void deactivate() {
    super.deactivate();
  }

  /*
   * widget 被永久移除
   * 调用完「dispose」后，「mounted」 属性被设置为 false，
   * 也代表组件生命周期的结束，此时再调用 「setState」 方法将会抛出异常。
   */
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /*
   * 应用生命周期回调
   */
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //resumed、inactive、paused、detached
    if (state == AppLifecycleState.resumed) {
      //应用程序可见且响应用户输入
      print("didChangeAppLifecycleState:   $state");
    } else if (state == AppLifecycleState.inactive) {
      //应用程序处于非激活状态，无法响应用户输入。
      //在iOS上，打电话、响应TouchID请求、进入应用程序切换器或控制中心都处于此状态。在Android上，分屏应用，打电话，弹出系统对话框或其他窗口等。
      print("didChangeAppLifecycleState:   $state");
    } else if (state == AppLifecycleState.paused) {
      //应用程序不可见且无法响应用户输入，运行在后台。
      //处于此状态时，引擎将不会调用 「Window.onBeginFrame」 和 「Window.onDrawFrame」。
      print("didChangeAppLifecycleState:   $state");
    } else if (state == AppLifecycleState.detached) {
      //应用程序仍寄存在 Flutter 引擎上，但与平台 View 分离。
      //处于此状态的时机：引擎首次加载到附加到一个平台 View 的过程中，或者由于执行 Navigator pop ，view 被销毁。
      print("didChangeAppLifecycleState:   $state");
    }
  }

  /*
   * State 改动之后。在方法中创建各种组件，绘制到屏幕上
   * 此方法中应该只包含构建组件的代码，不应该包含其他额外的功能，尤其是耗时任务
   * 调用时机：
   *  调用 「initState」 方法后。
   *  调用 「didUpdateWidget」 方法后。
   *  收到对 「setState」 的调用后。
   *  此 「State」 对象的依存关系发生更改后（例如，依赖的 「InheritedWidget」 发生了更改）。
   *  调用 「deactivate」 之后，然后将 「State」 对象重新插入树的另一个位置。
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // 可以使用 BoxDecoration 来进行装饰，如背景，边框，或阴影等。 Container 还可以设置外边距、内边距和尺寸的约束条件等
            Container(
                width: 200,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.blue[100]),
                child: IconButton(
                    onPressed: _jumpOtherPage,
                    icon: const Icon(Icons.abc),
                    padding: const EdgeInsets.all(30))),

            buildRow(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /*
   * 图片加载
   */
  Widget buildRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        //超出部分，可裁剪
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black38),
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10)),
        //margin: const EdgeInsets.all(50),
        child: Image.asset('images/pic1.jpg'),
      ),
      Image.asset(
        'images/pic3.jpg',
        fit: BoxFit.cover,
      ),
      //主要应用在 对子控件的大小的一些约束，能强制子控件具有特定宽度、高度,使子控件设置的宽高失效
      //1.限制子元素控件的大小
      //2.设置两个控件之间的距离
      SizedBox(
          width: 50,
          height: 80,
          child: Image.network(
              'https://scpic.chinaz.net/files/default/imgs/2023-05-18/dcd04bf152731868.jpg')),
    ]);
  }
}
