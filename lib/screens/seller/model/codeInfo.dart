import 'package:flutter/material.dart';

class codeInfo {
  final String code = "";
  final String codeName = "";
}

ListTile _tile(String code, String codeName) => ListTile(
  title: Text(codeName),
  // subtitle : Text(subtitle),
  // leading: Image.network("https://randomuser.me/api/portraits/men/41.jpg"),
);