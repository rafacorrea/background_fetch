import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<UIBackgroundFetchResult> BackgroundFetchHandler();

enum UIBackgroundFetchResult {
  newData,
  noData,
  failed 
}

class BackgroundFetch {
  static BackgroundFetch shared = new BackgroundFetch();

  BackgroundFetchHandler _backgroundFetchHandler;

  static const MethodChannel _channel =
      const MethodChannel('background_fetch');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  BackgroundFetch(){
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print("hello from dart");
    if (call.method == 'BackgroundFetch#performFetch') {
      print("Fetch was called from native side");
      var result = await this._backgroundFetchHandler();
      return result.index;
    }

    return null;
}

  void setBackgroundFetchHandler(BackgroundFetchHandler handler, { Duration withInterval }) {
    _backgroundFetchHandler = handler;
  }
}
