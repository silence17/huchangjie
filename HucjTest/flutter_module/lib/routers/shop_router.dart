import 'package:fluro/fluro.dart';

import '../common/routers/i_router.dart';
import '../page/my_center_page.dart';

class MyCenterRouter implements IRouterProvider{

  static String shopPage = '/shop';
  static String shopSettingPage = '/shop/shopSetting';
  static String messagePage = '/shop/message';
  static String freightConfigPage = '/shop/freightConfig';
  static String addressSelectPage = '/shop/addressSelect';
  static String inputTextPage = '/shop/inputText';

  @override
  void initRouter(FluroRouter router) {
    router.define(shopPage, handler: Handler(handlerFunc: (_, __) => const MyCenter()));

  }
}
