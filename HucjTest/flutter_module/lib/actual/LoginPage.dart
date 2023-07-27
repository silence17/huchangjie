import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/res/constant.dart';
import 'package:flutter_module/utils/SpUtil.dart';
import 'package:flutter_module/widget/EditTextField.dart';
import 'package:flutter_module/widget/MyAppBar.dart';
import 'package:flutter_module/widget/my_button.dart';
import 'package:oktoast/oktoast.dart';

import '../utils/ChangeNotifierMixin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

/*
 * ChangeNotifier是 Flutter SDK 中的一个简单的类。
 * 它用于向监听器发送通知。换言之，如果被定义为 ChangeNotifier，你可以订阅它的状态变化。（这和大家所熟悉的观察者模式相类似）
 */
class _LoginPage extends State<LoginPage> with ChangeNotifierMixin {
  //TextEdit控制器
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  //是否能点击
  bool _clickable = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 显示状态栏和导航栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    _nameController.text = SpUtil.getString(Constant.phone) ?? '';
  }

  @override
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>>{
      _nameController: callbacks,
      _pwdController: callbacks
    };
  }

  /*
   * 用户名、密码合法性校验
   */
  void _verify() {
    final String name = _nameController.text;
    final String pwd = _pwdController.text;

    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (pwd.isEmpty || pwd.length < 6) {
      clickable = false;
    }

    if (_clickable != clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: '登陆',
        isBack: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: _buildBody,
        ),
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        SizedBox(
          height: 100,
          child: EditTextField(
            key: const Key('phone'),
            keyName: 'phone',
            focusNode: _nodeText1,
            isInputPwd: false,
            controller: _nameController,
            keyboardType: TextInputType.phone,
            hintText: '请输入手机号',
            textStyle: const TextStyle(fontSize: 13),
            maxLines: 1,
          ),
        ),
        EditTextField(
          key: const Key('password'),
          keyName: 'password',
          focusNode: _nodeText2,
          isInputPwd: true,
          controller: _pwdController,
          keyboardType: TextInputType.visiblePassword,
          hintText: '请输入密码',
        ),
        const SizedBox(
          height: 30,
        ),
        MyButton(
          onPressed: _clickable ? _login : null,
          text: '登陆',
        )
      ];

  /*
   * 登陆
   */
  _login() {
    showToast('登陆成功');
  }
}
