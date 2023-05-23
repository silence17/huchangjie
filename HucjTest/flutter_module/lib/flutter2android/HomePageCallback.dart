import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage2 extends StatefulWidget {
  ///构造方法
  const MyHomePage2({super.key, required this.title});

  final String title;

  ///生命周期回调方法
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  static const MethodChannel _methodChannel = MethodChannel("com.supermax");

  int _counter = 0;
  Map<String, String> map = {"Android": "好兄弟，我来了"};

  void _incrementCounter() {
    setState(() {
      _counter++;
      _jumpAndroid();
    });
  }

  _jumpAndroid() async {
    print("来了吗");
    _methodChannel.invokeMethod("withoutParams", map);
  }

  /*
   * Android 调用Flutter
   */
  Future<dynamic> flutterMethod(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "call3":
        print("我是参数" + methodCall.arguments.toString());
        break;
    }
  }

  @override
  void initState() {
    _methodChannel.setMethodCallHandler(flutterMethod);
    super.initState();
  }

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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
