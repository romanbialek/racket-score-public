import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../presentation/utils.dart';

abstract class BasePage extends StatefulWidget {}

abstract class BasePageState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  late ScreenOrientation screenOrientation;
  double currentWidth = 0;
  bool isMobile = false;
  bool isDesktop = false;
  bool _isPageInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentWidth = MediaQuery.of(context).size.width;
    isMobile = currentWidth < 650;
    isDesktop = currentWidth > 940;
    screenOrientation = Utils.getScreenOrientation(context);
    if(!_isPageInitialized) {
      loadData();
    }
    _isPageInitialized = true;
  }

  void loadData() {}

  showSnackBar(String text, context) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: AppColors.secondary,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
