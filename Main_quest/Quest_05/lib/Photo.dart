import 'package:flutter/material.dart';

class Photo {
  final int id;
  final String url;
  String title;
  final String detail;

  Photo({
    required this.id,
    required this.url,
    required this.title,
    required this.detail,
  });
}