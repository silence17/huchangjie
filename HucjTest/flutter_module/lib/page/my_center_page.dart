import 'package:flutter/material.dart';
import 'package:flutter_module/bean/order_info_bean.dart';
import 'package:flutter_module/bean/user_info_bean.dart';
import 'package:flutter_module/common/mvp/base_page.dart';
import 'package:flutter_module/common/utils/image_utils.dart';
import 'package:flutter_module/common/widget/load_image.dart';
import 'package:flutter_module/contact/my_center_contact.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../presenter/my_center_presenter.dart';

class MyCenter extends StatefulWidget {
  const MyCenter({super.key});

  @override
  State<StatefulWidget> createState() => _MyCenter();
}

class _MyCenter extends State<MyCenter>
    with BasePageMixin<MyCenter, MyCenterPresenter>
    implements MyCenterContact {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChangeNotifierProvider(
              create: (context) => presenter!.userInfo,
              child: _drawTopView(),
            ),
            //_drawTopView(),
            ChangeNotifierProvider(
              create: (context) => presenter!.orderInfo,
              child: _drawOrderInfo(),
            ),
            _drawMenus(),
          ],
        ),
      ),
    );
  }

  Widget _drawTopView() {
    return Stack(
      children: [
        const LoadAssetImage(
          'crm_top_bg',
          width: double.infinity,
          height: 144,
          fit: BoxFit.fill,
        ),
        Column(
          children: <Widget>[
            _drawTitle(),
            _drawUserInfo(),
          ],
        )
      ],
    );
  }

  Widget _drawTitle() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        IconButton(
            onPressed: () {
              showToast('back');
            },
            icon: const LoadAssetImage(
              'ic_back_black',
              width: 30,
              height: 30,
              fit: BoxFit.fill,
            )),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          child: const Text(
            '蜂采销售系统',
            style: TextStyle(fontSize: 17, color: Color(0xFF333333)),
          ),
        ),
      ],
    );
  }

  Widget _drawUserInfo() {
    return Consumer<UserInfoBean>(builder: (context, provider, child) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, left: 10),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: ImageUtils.getImageProvider(provider.imgUrl,
                  holderImg: 'pic'),
            ),
          ),
          const SizedBox(width: 10),
          //自适应大小
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 9),
                Text(
                  provider.nickName ?? "小明",
                  style:
                      const TextStyle(color: Color(0xFF000000), fontSize: 18),
                ),
                const SizedBox(height: 5),
                const Text(
                  "蜂采优选北京科技有限公司公司(北京国际贸易公司)",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Color(0xFF333333), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            child: Container(
              height: 24,
              padding: const EdgeInsets.only(right: 10, left: 3),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(12.0),
                    bottomStart: Radius.circular(12.0),
                  ),
                  color: Colors.white),
              child: const Row(
                children: [
                  LoadAssetImage(
                    'crm_icon_switch',
                    width: 19,
                    height: 19,
                  ),
                  SizedBox(width: 3),
                  Text(
                    '选择企业',
                    style: TextStyle(
                      color: Color(0xFF1677FF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            onTap: () => {showToast("选择企业")},
          )
        ],
      );
    });
  }

  Widget _drawOrderInfo() {
    return Consumer<OrderInfoBean>(builder: (context, provider, child) {
      var line = Container(
        width: 1,
        color: Colors.white,
        height: 29,
      );

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: 100,
        child: Stack(
          children: [
            const LoadAssetImage(
              'crm_order_bg',
              height: 100,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Flex(
              // crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 14),
                        child: const Text(
                          '当日订单金额',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.center,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 29,
                        child: Text(
                          "¥${provider.curDayTotalAmount}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "昨日： ¥${provider.curDayTotalOrder}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                line,
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 14),
                        child: const Text(
                          '当日订单',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.center,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 29,
                        child: Text(
                          "${provider.curDayTotalAmount}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "昨日： ${provider.curDayTotalOrder}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                line,
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 14),
                        child: const Text(
                          '未处理订单',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.center,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 29,
                        child: Text(
                          "${provider.curDayTotalAmount}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _drawMenus() {
    return Text('_drawMenus');
  }

  @override
  MyCenterPresenter createPresenter() {
    return MyCenterPresenter();
  }
}
