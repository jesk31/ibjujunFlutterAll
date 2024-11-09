import 'package:flutter/material.dart';

class Inspection {
  final String title = "";
  final String subtitle = "";
  final String imageUrl = "";

}

ListTile _tile(String title, String subtitle) => ListTile(
  title: Text(title),
  subtitle : Text(subtitle),
  leading: Image.network("https://randomuser.me/api/portraits/men/41.jpg"),
);