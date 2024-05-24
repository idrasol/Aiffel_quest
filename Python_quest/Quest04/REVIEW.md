# AIFFEL Campus Code Peer Review Templete
- 코더 : 정권영
- 리뷰어 : 서은재


# PRT(Peer Review Template)
[o]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
- 문제에서 요구하는 기능이 정상적으로 작동하는지? 정상적으로 작동합니다.
    - 해당 조건을 만족하는 부분의 코드 및 결과물을 근거로 첨부
```
import math
# 연산자를 반복하기 위해서 for문과 while문 중에서 계속 반복을 해야하기 때문에 while문으로 try-except 문을 감쌌습니다.
while True:
  try:
    num1 = float(input("첫번째 정수를 입력해주세요:"))
    num2 = float(input("두번째 정수를 입력해주세요:"))
    oprator = input("연산자 +,-, /, *, ** 입력해주세요:")

  except:
    print("입력한 값이 정수가 아닙니다. 다시 입력해주세요")
    continue

  else:
    if oprator == '+':
      print("결과는:", num1+num2)
    elif oprator == '-':
      print("결과는:", num1-num2)
    elif oprator == '/':
      if num2 == 0:
          print("두 번째 정수가 0입니다. 계산할 수 없습니다.")
      else:
          print("결과는:", num1/num2)
    elif oprator == '*':
      print("결과는:", num1*num2)
    elif oprator == '**':
      print("결과는:", math.pow(num1,num2))
  # math모듈을 추가안해도 ** 제곱근은 정상출력되는데 math.pow를 사용하여 결과값을 출력했습니다.
    else:
      raise Exception('잘못된 연산자를 입력하셨습니다.')
  # raise Exception 입력하여 잘못된 연산자 메시지출력을 원했는데 구글 코렙에서는 출력 안되네요
  # 각 조건마다 break를 추가하여 루프를 종료시켰는데 finally를 추가하게 되어서 break구문은 지웠습니다.

  finally:
    while True:
        yor = str(input("계속 계산하시겠습니까?(y/n)")).lower()
  # y/n를 대문자 입력시 동일하게 처리했습니다.
        if yor == 'y':
          continue
        elif yor == 'n':
          print("종료합니다.")
          break
   # 사용자가 y/n 외에 입력할 때 처리 방법도 고민 필요합니다.
        else:
          print("다시 입력해주세요")
          continue
    break
```

[o]  **2. 핵심적이거나 복잡하고 이해하기 어려운 부분에 작성된 설명을 보고 해당 코드가 잘 이해되었나요?**
- 해당 코드 블럭에 doc string/annotation/markdown이 달려 있는지 확인
- 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
- 주석을 보고 코드 이해가 잘 되었는지 확인? 네, 코드 이해가 잘 됩니다~
    - 잘 작성되었다고 생각되는 부분을 근거로 첨부합니다.
    - raise exception을 except 전에 사용한 후 except 처리해주면 더 좋을 것 같습니다~
```
# raise Exception 입력하여 잘못된 연산자 메시지출력을 원했는데 구글 코렙에서는 출력 안되네요
else:
    raise Exception('잘못된 연산자를 입력하셨습니다.')
```
        
[]  **3. 에러가 난 부분을 디버깅하여 “문제를 해결한 기록”을 남겼나요? 또는 “새로운 시도 및 추가 실험”을 해봤나요?**
- 문제 원인 및 해결 과정을 잘 기록하였는지 확인
- 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 실험이 기록되어 있는지 확인
    - 잘 작성되었다고 생각되는 부분을 캡쳐해 근거로 첨부합니다.
    - 아래 부분에 대해서 새로운 시도가 있으면 좋을 것 같습니다~
```
# 사용자가 y/n 외에 입력할 때 처리 방법도 고민 필요합니다.
else:
    print("다시 입력해주세요")
    continue
```
        
[o]  **4. 회고를 잘 작성했나요?**
- 프로젝트 결과물에 대해 배운점과 아쉬운점, 느낀점 등이 상세히 기록 되어 있나요? 상세히 기록되어 있습니다!
- 딥러닝 모델의 경우, 인풋이 들어가 최종적으로 아웃풋이 나오기까지의 전체 흐름을 도식화하여 모델 아키텍쳐에 대한 이해를 돕고 있는지 확인


# 참고 링크 및 코드 개선
```
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```
