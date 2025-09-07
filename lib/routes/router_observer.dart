import 'package:flutter/material.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('''📄  📄  📄  📄  📄  DidPush  📄  📄  📄  📄  📄 
    \tname:\t${route.settings.name}
    \targuments:\t${route.settings.arguments}  ''');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('''📄  📄  📄  📄  📄  DidPop  📄  📄  📄  📄  📄 
    \tname:\t${route.settings.name}
    \targuments:\t${route.settings.arguments}  ''');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('''📄  📄  📄  📄  📄  DidRemove  📄  📄  📄  📄  📄 
    \tname:\t${route.settings.name}
    \targuments:\t${route.settings.arguments}  ''');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('''📄  📄  📄  📄  📄  DidReplace  📄  📄  📄  📄  📄 
    \tname:\t${newRoute!.settings.name}
    \targuments:\t${newRoute.settings.arguments}  ''');
  }
}
