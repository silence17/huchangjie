import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/actual/OrderListPage.dart';
import 'package:flutter_module/utils/my_flexible_space_bar.dart';
import 'package:flutter_module/utils/screen_utils.dart';
import 'package:flutter_module/utils/theme_utils.dart';
import 'package:flutter_module/widget/load_image.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../provider/OrderPageProvider.dart';
import '../res/colors.dart';
import '../utils/image_utils.dart';
import '../widget/my_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage>
    with
        AutomaticKeepAliveClientMixin<OrderPage>,
        SingleTickerProviderStateMixin {
  //切换页面发送通知，在OrderListPage.dart中接收刷新页面
  OrderPageProvider provider = OrderPageProvider();
  final PageController _pageController = PageController();

  //tab bar
  TabController? _tabController;
  int _lastReportedPage = 0;

  Future<void> _onPageChange(int index) async {
    provider.setIndex(index);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 预先缓存剩余切换图片
      precacheImage(ImageUtils.getAssetImage('xdd_n'), context);
      precacheImage(ImageUtils.getAssetImage('dps_s'), context);
      precacheImage(ImageUtils.getAssetImage('dwc_s'), context);
      precacheImage(ImageUtils.getAssetImage('ywc_s'), context);
      precacheImage(ImageUtils.getAssetImage('yqx_s'), context);
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<OrderPageProvider>(
      create: (_) => provider,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            NestedScrollView(
              key: const Key('order_list'),

              ///ScrollPhysics 的作用是 确定可滚动控件的物理特性。ClampingScrollPhysics:防止滚动超出边界，夹住 。
              physics: const ClampingScrollPhysics(),

              ///页面滚动头部处理
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return _sliverBuilder(context);
              },
              body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  print('notification.depth:  ${notification.depth}');

                  /// PageView的onPageChanged是监听ScrollUpdateNotification，会造成滑动中卡顿。这里修改为监听滚动结束再更新
                  if (notification.depth == 0 &&
                      notification is ScrollEndNotification) {
                    final PageMetrics metrics =
                        notification.metrics as PageMetrics;

                    print('ScrollNotification####################');
                    print('pixels = ${metrics.pixels}');
                    print('atEdge = ${metrics.atEdge}');
                    print('axis = ${metrics.axis}');
                    print('axisDirection = ${metrics.axisDirection}');
                    print('extentAfter = ${metrics.extentAfter}');
                    print('extentBefore = ${metrics.extentBefore}');
                    print('extentInside = ${metrics.extentInside}');
                    print('maxScrollExtent = ${metrics.maxScrollExtent}');
                    print('minScrollExtent = ${metrics.minScrollExtent}');
                    print('viewportDimension = ${metrics.viewportDimension}');
                    print('outOfRange = ${metrics.outOfRange}');
                    print('page = ${metrics.page}');
                    print('ScrollNotification####################');

                    //四舍五入算法
                    final int currentPage = (metrics.page ?? 0).round();
                    if (currentPage != _lastReportedPage) {
                      _lastReportedPage = currentPage;
                      _onPageChange(currentPage);
                    }
                  }

                  ///返回值true表示消费掉当前通知不再向上一级NotificationListener传递通知，false则会再向上一级NotificationListener传递通知；
                  ///这里需要注意的是通知是由下而上去传递的，所以才会称作冒泡通知
                  return false;
                },
                child: PageView.builder(
                  key: const Key('pageView'),
                  itemCount: 5,
                  controller: _pageController,
                  itemBuilder: (context, index) => OrderListPage(index: index),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      /// 可参考https://www.jianshu.com/p/3eeef0c27c2f
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),

        ///NestedScrollView折叠部分使用SliverAppBar来实现
        sliver: SliverAppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          // 不随着滑动隐藏标题
          expandedHeight: 120.0,
          // 固定在顶部
          // pinned 为true 时 SliverAppBar 会固定在 NestedScrollView 的顶部
          pinned: true,
          flexibleSpace: MyFlexibleSpaceBar(
            background: LoadAssetImage(
              'order_bg',
              width: context.width,
              height: 120.0,
              fit: BoxFit.fill,
            ),
            centerTitle: true,
            titlePadding:
                const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
            collapseMode: CollapseMode.pin,
            title: Text(
              '订单',
              style: TextStyle(color: ThemeUtils.getIconColor(context)),
            ),
          ),
          actions: [
            IconButton(
                tooltip: '搜索',
                onPressed: () {
                  showToast('search title');
                },
                icon: LoadAssetImage(
                  'icon_search',
                  width: 22.0,
                  height: 22.0,
                  color: ThemeUtils.getIconColor(context),
                )),
          ],
        ),
      ),
      //可以根据滚动而变大变小的组件，SliverAppBar就是基于这个实现的
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              color: null,
              image: DecorationImage(
                image: ImageUtils.getAssetImage('order_bg1'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyCard(
                child: Container(
                  height: 80.0,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    labelColor: Colours.text,
                    unselectedLabelColor: Colours.text,
                    labelStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    indicatorColor: Colors.transparent,
                    tabs: const <Widget>[
                      _TabView(0, '新订单'),
                      _TabView(1, '待配送'),
                      _TabView(2, '待完成'),
                      _TabView(3, '已完成'),
                      _TabView(4, '已取消'),
                    ],
                    onTap: (index) {
                      if (!mounted) {
                        return;
                      }
                      _pageController.jumpToPage(index);
                    },
                  ),
                ),
              ),
            ),
          ),
          80.0,
        ),
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}

class _TabView extends StatelessWidget {
  const _TabView(this.index, this.text);

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final List<List<String>> imgList = context.isDark ? darkImg : img;
    return Stack(
      children: <Widget>[
        Container(
          width: 46.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              /// 使用context.select替代Consumer
              LoadAssetImage(
                context.select<OrderPageProvider, int>(
                            (value) => value.index) ==
                        index
                    ? imgList[index][0]
                    : imgList[index][1],
                width: 24.0,
                height: 24.0,
              ),
              const SizedBox(height: 4),
              Text(text),
            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: index < 3
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.5, vertical: 2.0),
                    child: Text(
                      '10',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}

List<List<String>> img = [
  ['xdd_s', 'xdd_n'],
  ['dps_s', 'dps_n'],
  ['dwc_s', 'dwc_n'],
  ['ywc_s', 'ywc_n'],
  ['yqx_s', 'yqx_n']
];

List<List<String>> darkImg = [
  ['dark/icon_xdd_s', 'dark/icon_xdd_n'],
  ['dark/icon_dps_s', 'dark/icon_dps_n'],
  ['dark/icon_dwc_s', 'dark/icon_dwc_n'],
  ['dark/icon_ywc_s', 'dark/icon_ywc_n'],
  ['dark/icon_yqx_s', 'dark/icon_yqx_n']
];

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.widget, this.height);

  final Widget widget;
  final double height;

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
