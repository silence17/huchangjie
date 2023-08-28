import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../common/widget/MyAppBar.dart';
import '../item/order_item.dart';

class RefreshPage extends StatefulWidget {
  const RefreshPage({super.key});

  @override
  State<StatefulWidget> createState() => _RefreshPage();
}

class _RefreshPage extends State<RefreshPage> {
  int _count = 0;
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: 'Easy_Refresh',
      ),
      body: EasyRefresh(
        controller: _controller,
        refreshOnStart: true,
        onRefresh: _onRefresh,
        onLoad: _loadMore,
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                print('refresh page item index: $index');

                return OrderItem(
                  key: Key('order_item_$index'),
                  index: index,
                  tabIndex: 0,
                );
                // return Text('data');
              },
              childCount: _count,
            ))
          ],
        ),
      ),
    );
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    setState(() {
      _count = 10;
    });
    _controller.finishRefresh();
    _controller.resetFooter();
  }

  void _loadMore() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    setState(() {
      _count += 10;
    });
    _controller.finishLoad(
        _count >= 30 ? IndicatorResult.noMore : IndicatorResult.success);
  }
}
