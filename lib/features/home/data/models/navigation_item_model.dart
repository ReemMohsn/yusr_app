import 'package:flutter/material.dart';

class NavigationItemModel {
  final String label;
  // final String inActiveIconPath;
  final String activeIconPath;
  final Widget page;

  NavigationItemModel({
    required this.label,
    required this.activeIconPath,
    // required this.inActiveIconPath,
    required this.page,
  });
}
