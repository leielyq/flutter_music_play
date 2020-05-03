// 提供五套可选主题色
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class App {
  static Profile profile = Profile();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
//  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static bool get isRelease => true;

  static get platform => defaultTargetPlatform;

  static bool get isiOS => platform == TargetPlatform.iOS;

}

class Profile {}
