import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "";
  String result_1 = "";
  TextEditingController urlController =
  TextEditingController(); // URL을 입력 받는 컨트롤러

  Future<void> fetchData() async {
    try {
      final enteredUrl = urlController.text; // 입력된 URL 가져오기
      final response = await http.get(
        Uri.parse(enteredUrl + "sample"), // 입력된 URL 사용
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result =
          "예측값: ${data['predicted_label']}";
        });
      } else {
        setState(() {
          result = "Failed to fetch data. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  Future<void> fetchData_1() async {
    try {
      final enteredUrl = urlController.text; // 입력된 URL 가져오기
      final response = await http.get(
        Uri.parse(enteredUrl + "sample"), // 입력된 URL 사용
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result_1 =
          "예측 정확도: ${data['prediction_score']}";
        });
      } else {
        setState(() {
          result = "Failed to fetch data. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/jellyfish.jpg',
            width: 200,
            height: 200,
          ),
        ),
        backgroundColor: Color(0xffeaecde), // 앱 바 배경색 설정
        title: Center(child: Text('Jellyfish Classifier')), // 앱 바 제목 설정
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/jellyfish.jpg',
              width: 300,
              height: 300,
            ),
            TextField(
              controller: urlController, // URL 입력을 위한 TextField
              decoration: InputDecoration(labelText: "URL 입력"), // 입력 필드의 라벨
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Row 내부 요소를 가운데 정렬
              children: [
                ElevatedButton(
                  onPressed: fetchData,
                  child: Text("예측결과 버튼"),
                ),
                Text(
                  result,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 50), // 버튼 사이에 간격 추가
                ElevatedButton(
                  onPressed: fetchData_1,
                  child: Text("예측확률 버튼"),
                ),
                Text(
                  result_1,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

'''
회고 : 훈련모델 수정은 엄두도 못내고 어제 오늘 배운 VGG16을 사용하여 실행하였습니다.
       많이 어려워서 기존거 그대로 갖다쓰고 플러터 내용만 좀 수정하였습니다.
       학습이 더 필요한거 같습니다.
```
      
