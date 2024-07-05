import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Quest 2',
      home: MyHomePage(title: '플러터 앱 만들기'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Text 버튼이 눌렸을 때 동작할 내부 함수
  _print() {
    print('버튼이 눌렸습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(   // Stack 위젯을 활용해 아이콘과 제목을 겹치게 한 뒤 정렬
          children: [
            const Align(
              alignment: Alignment.centerLeft,  // 아이콘은 왼쪽 정렬
              child: Icon(Icons.alarm),
            ),
            Center(   // 제목은 가운데 정렬
              child: Text(widget.title),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(  // 버튼 하단에 바깥 여백을 주기 위해 컨테이너 위젯으로 버튼을 감쌈.
              margin: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(onPressed: _print, child: const Text('Text')),
            ),
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.red,
                ),
                Container(
                  width: 240,
                  height: 240,
                  color: Colors.green,
                ),
                Container(
                  width: 180,
                  height: 180,
                  color: Colors.blue,
                ),
                Container(
                  width: 120,
                  height: 120,
                  color: Colors.orange,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.yellow,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
[회고]

- 정권영
1. child, childen 관계, 파이썬에 들여쓰기 방식을 쓰다가 괄호 방식을 쓰니 어디가 끝나는 라인인지  헷갈립니다.
2. 금일 퀘스트를 진행하면서 Container와 Stack의 사용법을 좀 더 자세히 알게 되었고 유익한 시간이었습니다.
3. 그러나 시간이 너무 짧습니다!!!(중요)

- 김주현
1. 처음 AppBar에서 아이콘과 제목을 여러 방식으로 분리를 해서 정렬을 따로 해보려 했으나 잘 안되어서 엄청 헤매었음. 하지만, Stack 위젯이 각각 정렬을 다르게 할 때에도 사용할 수 있다는 것을 이해하고 AppBar에도 적용해서 결국 해결할 수 있었음.
2.  Text 버튼 하단에 여백을 주기 위해 처음에는 버튼과 하단 상자 사이에 SizedBox를 둬서 간격을 벌릴려고 했으나, 생각해보니 Container 위젯에 margin 속성을 이용하면 해결될거 같아 버튼을 Container 위젯으로 감싸고 margin 속성을 주어서 해결함.
3. 처음에 생각한대로 잘 안되어서 엄청 당황하였으나 그래도 차분히 하나 하나 해결해 갈 수 있었습니다.
*/
