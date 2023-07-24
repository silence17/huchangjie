import 'package:flutter/material.dart';
import 'package:flutter_module/widget/point/DragView.dart';

class PointerPage extends StatefulWidget {
  const PointerPage({super.key});

  @override
  State<StatefulWidget> createState() => _PointerPage();
}

class _PointerPage extends State<PointerPage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          color: Colors.black12,
          child: const Column(
            children: <Widget>[
              Text("Pointer page"),
              DragView(),
            ],
          ),
        ),
      ),
    );
  }
}
