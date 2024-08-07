import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'CatDog.dart';
import 'Photo.dart';
import 'PhotoProvider.dart';
import 'DogHeadResultPage.dart'; // DogHeadResultPage import

class AIScreen extends StatefulWidget {
  final Photo photo; // Photo 객체를 받기 위한 변수

  AIScreen({required this.photo}); // 생성자에서 Photo 객체를 받음

  @override
  _AIScreenState createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  bool _isLoading = false;
  String? _predictedLabel;
  String? _predictionScore;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _predictImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      List<int> imageBytes;

      if (widget.photo.url.startsWith('assets/')) {
        // 로컬 자산의 경우
        ByteData byteData = await rootBundle.load(widget.photo.url);
        imageBytes = byteData.buffer.asUint8List();
      } else if (widget.photo.url.startsWith('/')) {
        // 로컬 파일 시스템의 경우
        final file = File(widget.photo.url);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        } else {
          throw Exception('파일이 존재하지 않습니다.');
        }
      } else {
        // URL에서 이미지를 다운로드
        final response = await http.get(Uri.parse(widget.photo.url));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        } else {
          throw Exception('이미지 다운로드 실패: ${response.statusCode}');
        }
      }

      var uri = Uri.parse('https://04da-221-145-193-52.ngrok-free.app/predict');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

      var serverResponse = await request.send();
      var responseData = await serverResponse.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (serverResponse.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(responseString);
        setState(() {
          _predictedLabel = result['predicted_label'] ?? '예측 레이블 없음';
          _predictionScore = result['prediction_score'] ?? '예측 신뢰도 없음';
          _errorMessage = null;
          _successMessage = '이미지 분석이 성공적으로 완료되었습니다!';

          // Photo 객체의 title 속성 업데이트
          final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
          final photo = photoProvider.photos.firstWhere((p) => p.id == widget.photo.id);
          photo.title = _predictedLabel ?? '기본 레이블'; // 예측된 레이블을 제목으로 설정

          // classification 값 설정
          photo.classification = CatDogClassifier.classify(_predictedLabel ?? '기본 레이블');
        });
      } else {
        setState(() {
          _predictedLabel = null;
          _predictionScore = null;
          _errorMessage = 'Error: ${serverResponse.statusCode} - ${serverResponse.reasonPhrase}';
          _successMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _predictedLabel = null;
        _predictionScore = null;
        _errorMessage = 'Error: $e';
        _successMessage = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToDogHeadDetector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DogHeadResultPage(photo: widget.photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 분석'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getImageWidget(widget.photo.url, width: 300, height: 300),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _predictImage,
                  icon: FaIcon(FontAwesomeIcons.robot, size: 28),
                  label: Text(
                    'AI 분석',
                    style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 20), // 버튼 사이에 간격 추가
                ElevatedButton.icon(
                  onPressed: _navigateToDogHeadDetector,
                  icon: FaIcon(FontAwesomeIcons.paw, size: 28),
                  label: Text(
                    'CATDOG',
                    style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_successMessage != null)
              Text(
                _successMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            if (_predictedLabel != null && _predictionScore != null)
              _buildPredictionResult(_predictedLabel!, _predictionScore!),
            if (_predictedLabel == null && _predictionScore == null && _errorMessage == null && _successMessage == null)
              Text(
                '분석 결과가 여기에 표시됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionResult(String label, String score) {
    // 기존 레이블을 그대로 사용하고, 새로 추가된 CatDogClassifier를 이용해 분류
    final classification = CatDogClassifier.classify(label);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '품   종 : $label',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(
          '분   류 : $classification',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(
          '정확도: $score',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget getImageWidget(String url, {double? width, double? height}) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      try {
        return Image.file(
          File(url),
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Text(
          '이미지 로드 실패',
          style: TextStyle(fontSize: 16, color: Colors.red),
        );
      }
    }
  }
}