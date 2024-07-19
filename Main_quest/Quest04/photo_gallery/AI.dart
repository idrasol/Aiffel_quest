import 'dart:convert';  // JSON 데이터 처리 및 파싱을 위한 패키지
import 'dart:io';  // 파일 작업을 위한 패키지
import 'package:flutter/material.dart';  // Flutter UI 구성 요소를 위한 패키지
import 'package:http/http.dart' as http;  // HTTP 요청을 위한 패키지
import 'package:flutter/services.dart';  // 애셋 파일 접근을 위한 패키지
import 'main.dart';  // 'main.dart' 파일에서 정의된 'Photo' 클래스를 가져오기 위한 패키지

// AIScreen 클래스 정의 - 이미지 분석 결과를 표시하는 화면
class AIScreen extends StatefulWidget {
  final Photo photo;  // 분석할 이미지 정보를 담고 있는 'Photo' 객체

  // 생성자 - 필수로 'photo'를 요구함
  AIScreen({required this.photo});

  @override
  _AIScreenState createState() => _AIScreenState();  // 상태 클래스를 생성하여 연결
}

// 상태 관리 클래스 - AIScreen의 상태를 관리
class _AIScreenState extends State<AIScreen> {
  bool _isLoading = false;  // 로딩 상태를 나타내는 플래그
  String? _predictedLabel;  // 예측된 레이블
  String? _predictionScore;  // 예측된 신뢰도 점수

  // 이미지 분석을 수행하는 비동기 메소드
  Future<void> _predictImage(String imagePath) async {
    setState(() {
      _isLoading = true;  // 분석 시작 시 로딩 상태를 활성화
    });

    try {
      List<int> imageBytes;

      // 이미지 경로에 따라 처리 방식 결정
      if (imagePath.startsWith('images/')) {
        // 애셋 이미지 처리
        ByteData byteData = await rootBundle.load(imagePath);  // 애셋에서 이미지 로드
        imageBytes = byteData.buffer.asUint8List();  // 바이트 배열로 변환
      } else {
        // 파일 시스템 이미지 처리
        File imageFile = File(imagePath);  // 파일 객체 생성
        if (imageFile.existsSync()) {
          imageBytes = await imageFile.readAsBytes();  // 파일을 바이트 배열로 읽기
        } else {
          // 파일이 존재하지 않는 경우 에러 메시지 설정
          setState(() {
            _predictedLabel = '파일이 존재하지 않습니다.';
            _isLoading = false;
          });
          return;
        }
      }

      // 서버 URL을 URI 객체로 생성
      var uri = Uri.parse('https://c112-221-145-193-52.ngrok-free.app/predict');  // 실제 서버 주소로 변경 필요
      var request = http.MultipartRequest('POST', uri);  // POST 요청 생성
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));  // 파일 추가

      var response = await request.send();  // 요청 전송
      var responseData = await response.stream.toBytes();  // 응답 데이터 수신
      var responseString = String.fromCharCodes(responseData);  // 바이트를 문자열로 변환

      if (response.statusCode == 200) {
        // 서버 응답이 성공적이면 JSON을 디코딩
        final Map<String, dynamic> result = json.decode(responseString);
        setState(() {
          _predictedLabel = result['predicted_label'];  // 예측된 레이블 저장
          _predictionScore = result['prediction_score'];  // 예측된 신뢰도 점수 저장
        });
      } else {
        // 응답 상태 코드가 200이 아닌 경우 에러 메시지 설정
        setState(() {
          _predictedLabel = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      // 예외가 발생한 경우 에러 메시지 설정
      setState(() {
        _predictedLabel = 'Error: $e';
      });
    } finally {
      // 로딩 상태 해제
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 분석 결과'),  // 화면 상단의 제목
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()  // 로딩 중일 때 스피너 표시
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬
          children: [
            // 'widget.photo.url'을 통해 이미지 위젯 가져오기
            getImageWidget(widget.photo.url, width: 300, height: 300),
            SizedBox(height: 20),  // 위젯 간의 간격
            ElevatedButton(
              onPressed: () => _predictImage(widget.photo.url),  // 버튼 클릭 시 이미지 분석 수행
              child: Text('이미지 분석'),
            ),
            SizedBox(height: 20),  // 위젯 간의 간격
            // 예측 결과 또는 기본 메시지 표시
            if (_predictedLabel != null && _predictionScore != null)
              _buildPredictionResult(_predictedLabel!, _predictionScore!),
            if (_predictedLabel == null && _predictionScore == null)
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

  // 예측 결과를 포맷하여 표시하는 위젯
  Widget _buildPredictionResult(String label, String score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // 열의 시작 위치 정렬
      children: [
        Text(
          '이미지 분석 결과: $label',  // 예측된 레이블 표시
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),  // 위젯 간의 간격
        Text(
          '정확도: $score',  // 예측 신뢰도 점수 표시
          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ],
    );
  }
}