import 'package:flutter/material.dart';

class DialogPageDemo extends StatelessWidget {
  const DialogPageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              // alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black38),
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const Text('普通Dialog',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () async {
                      bool? delete = await _showCommonDialog(context);
                      if (delete == null) {
                        print("取消删除");
                      } else {
                        print("已确认删除");
                        //... 删除文件
                      }
                    },
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              // alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black38),
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const Text('普通Dialog',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      changeLanguage(context);
                    },
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              // alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black38),
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const Text('动态数据Dialog',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      showListDialog(context);
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  /*
   * 普通弹窗
   *
   * AlertDialog
   */
  Future<bool?> _showCommonDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('您确定要删除当前文件吗?'),
            actions: <Widget>[
              TextButton(
                child: const Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("删除"),
                onPressed: () {
                  // ... 执行删除操作
                  Navigator.of(context).pop(true); //关闭对话框
                },
              ),
            ],
          );
        });
  }

  /*
   * SimpleDialog
   */
  Future<void> changeLanguage(BuildContext context) async {
    int? i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("请选择语言"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("中文简体"),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("美国英语"),
                ),
              )
            ],
          );
        });
    if (i != null) {
      print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
    }
  }

  /*
   * 动态dialog
   *
   * dialog
   */
  Future<void> showListDialog(BuildContext context) async {
    int? index = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          var child = Column(
            children: <Widget>[
              const ListTile(title: Text('请选择')),
              Expanded(child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("$index"),
                  onTap: () => Navigator.of(context).pop(index),
                );
              }))
            ],
          );

          return Dialog(child: child);
        });
    if (index != null) {
      print("点击了：$index");
    }
  }

}
