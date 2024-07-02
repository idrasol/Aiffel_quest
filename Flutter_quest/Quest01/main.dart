import 'dart:async';

void main() {
  PomodoroTimer pomodoroTimer = PomodoroTimer();
  pomodoroTimer.start();
}

class PomodoroTimer {
  static const int workTime = 25 * 60; // 25 분 업무 시간
  static const int shortRest = 5 * 60; // 5 분 4회차를 제외한 휴식 시간
  static const int longRest = 15 * 60; // 15 분 4회차 휴식 시간
  int currentTime = workTime; // currentTime은 실시간으로 줄어들면서 타이머 역할을 함
  Timer? timer; // null 값이 들어갈 수 있도록 ? 추가
  bool isWorking = true; // 현재 휴식 시간인지 업무 시간인지 체크 true 업무, false 휴식
  int cycleCount = 0; // 반복 회차

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t){
      if (currentTime > 0) { // 설정된 시간이 안 끝났다면
        currentTime--; // 남은 시간을 1씩 빼고
        print('Flutter : ${format(currentTime)}'); // 남은 시간 출력
      }
      else { // 설정된 시간이 끝났다면
        if (isWorking) { // 현재 업무 시간이였다면
          cycleCount++; // 회차를 더하고
          print('$cycleCount 회차 업무 시간 종료. 휴식 시작');
          currentTime = cycleCount % 4 == 0 ? longRest : shortRest; // 4회차라면 15분 휴식 아니라면 5분 휴식
        }
        else{ // 현재 휴식 시간이였다면
          print('휴식 시간 종료. ${cycleCount+1} 회차 업무 시작');
          currentTime = workTime; // 25분을 부여
        }
        isWorking = !isWorking; // 업무 또는 휴식 시간 변경
      }
    });
  }

  String format(int seconds){ // 초 단위를 분 단위로 변환
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7);
  }

}
//회고
유제민 : 머리속에서 어떻게 짤지 고민하는데 시간이 엄청 들었다....막상 짜고나니 간단하게 만들어졌는데 어떻게 짜야 좀 더 좋을지 유연한 생각이 필요하다 느꼈다.
