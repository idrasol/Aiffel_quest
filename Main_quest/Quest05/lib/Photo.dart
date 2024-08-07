import 'package:flutter/material.dart';

class Photo {
  final int id;
  String url;
  String title;
  final String detail;
  String classification;

  Photo({
    required this.id,
    required this.url,
    required this.title,
    required this.detail,
    required this.classification,
  });
}