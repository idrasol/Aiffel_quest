# AIFFEL Campus Code Peer Review Templete
> - 코더 : 정권영
> - 리뷰어 : 김주현, 이유진
  
  
# PRT(Peer Review Template)
[O]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
* Segmentation의 정확도가 조금 떨어지긴 하지만, 완성된 코드가 제출되었음.   
  
[O]  **2. 핵심적이거나 복잡하고 이해하기 어려운 부분에 작성된 설명을 보고 해당 코드가 잘 이해되었나요?**
* 필요한 부분마다 적절한 주석이 추가되어 있어 이해하는데 있어 어려움이 없음. 
  
[O]  **3. 에러가 난 부분을 디버깅하여 “문제를 해결한 기록”을 남겼나요? 또는 “새로운 시도 및 추가 실험”을 해봤나요?**
* 파이토치 기반의 DeepLabV3 모델 중에서도 ResNet50, ResNet101, Mobilenet 등 여러 모델을 사용해 실험함.
  ```python
  import torch
  #model = torch.hub.load('pytorch/vision:v0.10.0', 'deeplabv3_resnet50', pretrained=True)
  # 또는 아래 중 하나
  #model = torch.hub.load('pytorch/vision:v0.10.0', 'deeplabv3_resnet101', pretrained=True)
  model = torch.hub.load('pytorch/vision:v0.10.0', 'deeplabv3_mobilenet_v3_large', pretrained=True)
  model.eval()
  ```  
  
[O]  **4. 회고를 잘 작성했나요?**
* 주피터 노트북 파일 하단에 아쉬운 부분을 포함해 회고가 잘 작성되어 있음.   
  
[O]  **5. 코드가 간결하고 효율적인가요?**
* 간결하게 잘 작성되어 있음.  
  
  
# 참고 링크 및 코드 개선
```
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```
