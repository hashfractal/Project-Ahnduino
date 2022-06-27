import 'package:flutter/cupertino.dart';

class KowananasLayoutInfo {
  final MediaQueryData mediaQueryData;
  var scaledWidth;
  var scaledHeight;
  var scaledFontSize;
  final _defaultDRP = 3.5;
  var appBarSize = 0.0;

  KowananasLayoutInfo(this.mediaQueryData) {
    scaledWidth = mediaQueryData.size.width / 100.0;
    scaledHeight = mediaQueryData.size.height / 100.0;
    scaledFontSize = mediaQueryData.textScaleFactor * scaledWidth / _defaultDRP;
  }
  getWidth(percent) => scaledWidth * percent;
  getHeight(percent) => scaledHeight * percent;
}

class KowanasLayout extends InheritedWidget {
  final KowananasLayoutInfo? data;

  KowanasLayout({Key? key, @required this.data, @required Widget? child})
      : assert(data != null),
        assert(child != null),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(KowanasLayout oldWidget) => data != oldWidget.data;

  static KowananasLayoutInfo of(context) {
    return context.dependOnInheritedWidgetOfExactType<KowanasLayout>().data;
  }
}
