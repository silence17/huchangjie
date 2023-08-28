import 'package:flutter/material.dart';
import 'package:flutter_module/common/mvp/base_page.dart';

import '../presenter/my_center_presenter.dart';

class MyCenter extends StatefulWidget {
  const MyCenter({super.key});

  @override
  State<StatefulWidget> createState() => _MyCenter();
}

class _MyCenter extends State<MyCenter>
    with BasePageMixin<MyCenter, MyCenterPresenter> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  MyCenterPresenter createPresenter() {
    return MyCenterPresenter();
  }
}
