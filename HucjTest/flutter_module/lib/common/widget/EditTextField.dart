import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/common/widget/load_image.dart';

class EditTextField extends StatefulWidget {
  const EditTextField(
      {super.key,
      required this.controller,
      this.maxLength = 999999999,
      this.keyboardType = TextInputType.text,
      this.hintText = '',
      this.autoFocus = false,
      this.focusNode,
      this.isInputPwd = false,
      this.keyName,
      this.textStyle,
      this.maxLines = 999999999});

  final TextEditingController controller;
  final int maxLength;
  final TextInputType keyboardType;
  final String hintText;
  final bool autoFocus;

  //主要提供焦点控制功能,用于控制TextField是否占有当前键盘的输入焦点。它是我们和键盘交互的一个句柄（handle）
  final FocusNode? focusNode;
  final bool isInputPwd;
  final String? keyName;
  final TextStyle? textStyle;

  //显示最大行数
  final int maxLines;

  @override
  State<StatefulWidget> createState() => _EditTextField();
}

class _EditTextField extends State<EditTextField> {
  bool _isShowPwd = false;
  bool _isShowDelete = false;

  /*
   * 文本变化监听回调
   */
  void isEmptyCallback() {
    final bool isNotEmpty = widget.controller.text.isNotEmpty;
    // 状态不一样在刷新，避免重复不必要的setState
    if (isNotEmpty != _isShowDelete) {
      setState(() {
        _isShowDelete = !_isShowDelete;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    //获取初始值
    _isShowDelete = widget.controller.text.isNotEmpty;
    //监听输入改变
    widget.controller.addListener(isEmptyCallback);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(isEmptyCallback);
  }

  @override
  Widget build(BuildContext context) {
    //输入框
    Widget textField = TextField(
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      //属性用于设置是否隐藏输入的内容，该属性常用于密码输人框。
      obscureText: widget.isInputPwd && !_isShowPwd,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      style: widget.textStyle,
      textInputAction: TextInputAction.done,
      keyboardType: widget.keyboardType,
      maxLines: widget.isInputPwd && !_isShowPwd ? 1 : widget.maxLines,
      minLines: 1,
      //限制输入
      inputFormatters: (widget.keyboardType == TextInputType.number ||
              widget.keyboardType == TextInputType.phone)
          //\u4e00-\u9fa5是用来判断是不是中文的一个条件
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],

      //InputDecoration 主要为 TextField 提供各种样式排版布局
      decoration: InputDecoration(
        //contentPadding | 内间距，默认值与 border 以及 isDense 有关
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        hintText: widget.hintText,
        //备注文本，位于输入框右下角外侧，与 counter 不能同时使用
        counterText: '',
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 0.8,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
            width: 0.8,
          ),
        ),
      ),
    );

    //clear button
    Widget? clearButton;
    if (_isShowDelete) {
      clearButton = Semantics(
        label: "清空",
        hint: "清空输入框",
        child: GestureDetector(
          child: LoadAssetImage(
            "qyg_shop_icon_delete",
            key: Key('${widget.keyName}_delete'),
            width: 18.0,
            height: 40.0,
          ),
          onTap: () => {widget.controller.text = ''},
        ),
      );
    }

    //pwd hide
    Widget? pwdVisible;
    if (widget.isInputPwd) {
      pwdVisible = Semantics(
        label: '密码可见开关',
        hint: '密码是否可见',
        child: GestureDetector(
          child: LoadAssetImage(
            _isShowPwd ? 'qyg_shop_icon_display' : 'qyg_shop_icon_hide',
            width: 18.0,
            height: 40.0,
          ),
          onTap: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
        ),
      );
    }

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        textField,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: _isShowDelete,
              child: clearButton ?? const SizedBox.shrink(),
            ),
            if (widget.isInputPwd) const SizedBox(width: 15),
            if (widget.isInputPwd) pwdVisible ?? const SizedBox.shrink(),
          ],
        )
      ],
    );
  }
}
