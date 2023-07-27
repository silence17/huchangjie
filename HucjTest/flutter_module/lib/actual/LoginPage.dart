import 'package:flutter/material.dart';
import 'package:flutter_module/widget/EditTextField.dart';
import 'package:flutter_module/widget/MyAppBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

/*
 * ChangeNotifier是 Flutter SDK 中的一个简单的类。
 * 它用于向监听器发送通知。换言之，如果被定义为 ChangeNotifier，你可以订阅它的状态变化。（这和大家所熟悉的观察者模式相类似）
 */
class _LoginPage extends State<LoginPage> {
  //TextEdit控制器
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: '登陆',
        isBack: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _buildBody,
        ),
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        EditTextField(
          key: const Key('phone'),
          keyName: 'phone',
          focusNode: _nodeText1,
          isInputPwd: false,
          controller: _nameController,
          keyboardType: TextInputType.phone,
          hintText: '请输入手机号',
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
      ];
}
