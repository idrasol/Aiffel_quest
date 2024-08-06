import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class DogHeadDetector {
  static Future<Map<String, dynamic>> detectDogHead(String url) async {
    try {
      List<int> imageBytes;

      if (url.startsWith('assets/')) {
        // 로컬 자산의 경우
        ByteData byteData = await rootBundle.load(url);
        imageBytes = byteData.buffer.asUint8List();
      } else if (url.startsWith('/')) {
        // 로컬 파일 시스템의 경우
        final file = File(url);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        } else {
          throw Exception('파일이 존재하지 않습니다.');
        }
      } else {
        // URL에서 이미지를 다운로드
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        } else {
          throw Exception('이미지 다운로드 실패: ${response.statusCode}');
        }
      }

      var uri = Uri.parse('https://b48a-221-145-193-52.ngrok-free.app/detect_dog_head');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

      var serverResponse = await request.send();
      var responseData = await serverResponse.stream.toBytes();
      var responseString = utf8.decode(responseData); // 문자열 디코딩

      if (serverResponse.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(responseString);
        return result;
      } else {
        return {
          'error': 'Error: ${serverResponse.statusCode} - ${serverResponse.reasonPhrase}'
        };
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }
}