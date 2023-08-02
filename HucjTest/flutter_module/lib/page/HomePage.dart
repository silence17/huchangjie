import 'dart:io';

import 'package:dio/dio.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../widget/point/PointerMoveIndicator.dart';

/*
 * StatefulWidget生命周期
 */
class MyHomePage extends StatefulWidget {
  /*
   * 标识required，标识必须传入
   */
  const MyHomePage({super.key, required this.title});

  final String title;

  /// =>是return语句的简写
  /// 生命周期内执行一次
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int _counter = 0;
  String _response = '';

  void _incrementCounter() async {
    //需要刷新 UI 时,触发 Widget 的重新构建
    setState(() {
      _counter++;
    });

    await (await _getLocalFile()).writeAsString('$_counter');
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  /*
   * 发送网络请求使用 dart io库
   */
  void _request() async {
    Dio dio = Dio();
    String url =
        // 'https://restapi.amap.com/v3/weather/weatherInfo?city=110101&key=45a48b4e81791fd4bfbb05f8975d42b7';
        'https://restapi.amap.com/v3/weather/weatherInfo?key=45a48b4e81791fd4bfbb05f8975d42b7&city=110000&extensions=base';

    Response response = await dio.get(url);
    var data = response.data.toString();
    setState(() {
      _response = data;
    });
  }

  /*
   * 当State 对象插入视图树之后
   * 此函数只会被调用一次，子类通常会重写此方法，在其中进行初始化操作.比如加载网络数据，重写此方法时一定要调用 「super.initState()」
   *
   * 类似于 Android 的 onCreate
   * 所以在这里 View 并没有渲染，但是这时 StatefulWidget 已经被加载到渲染树里了，这时 StatefulWidget 的 mount 的值会变为 true
   */
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //从文件中读取点击数量
    _readFile().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  /*
   * State 对象的依赖关系发生变化后
   *
   *  didChangeDependencies 方法会在 initState 方法之后立即调用，
   * 之后当 StatefulWidget 刷新的时候，就不会调用了，除非你的 StatefulWidget 依赖的 InheritedWidget 发生变化之后，didChangeDependencies 才会调用，
   * 所以 didChangeDependencies 有可能会被调用多次。
   */
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
   * 用于开发阶段，热重载的时候会被调用，之后会重新构建；
   */
  @override
  void reassemble() {
    super.reassemble();
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
    super.build(context);
    final wordPair = WordPair.random();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),

            ConstrainedBox(
                // 盒模型
                constraints: const BoxConstraints(minWidth: 100),
                child: Text(
                  '$_counter',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      background: Paint()..color = Colors.grey),
                )),

            Text('随机数：$wordPair'),

            // 可以使用 BoxDecoration 来进行装饰，如背景，边框，或阴影等。 Container 还可以设置外边距、内边距和尺寸的约束条件等
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blue[100]),
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: _request,
                  child: Text(_response),
                ),
              ),
            ),

            buildRow(),
            const Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue, child: Text('A')),
                  label: Text('Hamilton'),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue, child: Text('M')),
                  label: Text('Lafayette'),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue, child: Text('H')),
                  label: Text('Mulligan'),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue, child: Text('J')),
                  label: Text('Laurens'),
                ),
              ],
            ),
            const SizedBox(
              width: double.infinity,
              child: PointerMoveIndicator(),
            )
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
    //MainAxisAlignment和CrossAxisAlignment，分别代表主轴对齐和纵轴对齐
    //MainAxisSize.min表示尽可能少的占用水平空间
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //表示尽可能多的占用水平方向的空间，此时无论子 widgets 实际占用多少水平空间，Row的宽度始终等于水平方向的最大宽度
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            //超出部分，可裁剪
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.black38),
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10)),
            //margin: const EdgeInsets.all(50),
            child: Image.asset('assets/images/pic1.jpg'),
          ),

          //没有点击事件的view，可以使用GestureDetector包裹
          GestureDetector(
            child: Image.asset(
              'assets/images/pic3.jpg',
              fit: BoxFit.cover,
            ),
            onTap: () {
              //Navigator.of(context).pushNamed('/five');
              Navigator.of(context).pushNamed('/seven');
            },
          ),

          //主要应用在 对子控件的大小的一些约束，能强制子控件具有特定宽度、高度,使子控件设置的宽高失效
          //1.限制子元素控件的大小
          //2.设置两个控件之间的距离
          GestureDetector(
            child: SizedBox(
                width: 50,
                height: 80,
                child: Image.network(
                    'https://scpic.chinaz.net/files/default/imgs/2023-05-18/dcd04bf152731868.jpg')),
            onTap: () {
              Navigator.of(context).pushNamed('/six');
            },
          ),
        ]);
  }

  /*
   * 使用TabBarView+AutomaticKeepAliveClientMixin这种方式既实现了页面状态的保持，
   * 又具有类似惰性求值的功能，对于未使用的页面状态不会进行实例化，减小了应用初始化时的开销。
   */
  @override
  bool get wantKeepAlive => true;

  /*
   * 获取文件
   */
  Future<File> _getLocalFile() async {
    //获取应用目录
    //在 iOS 上，这对应于NSDocumentDirectory。在 Android 上，这是AppData目录。
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/counter.txt');
  }

  /*
   * 读取文件
   */
  Future<int> _readFile() async {
    try {
      File file = await _getLocalFile();
      //读取点击次数
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }
}
