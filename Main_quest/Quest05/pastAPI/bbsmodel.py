import cv2
import numpy as np

def resize_img(im, img_size=224):
    old_size = im.shape[:2]  # 원래 이미지 사이즈
    ratio = float(img_size) / max(old_size)
    new_size = tuple([int(x * ratio) for x in old_size])
    
    # 224x224 크기로 조정, 남는 공간은 패딩 추가
    im = cv2.resize(im, (new_size[1], new_size[0]))
    delta_w = img_size - new_size[1]
    delta_h = img_size - new_size[0]
    top, bottom = delta_h // 2, delta_h - (delta_h // 2)
    left, right = delta_w // 2, delta_w - (delta_w // 2)
    new_im = cv2.copyMakeBorder(im, top, bottom, left, right, cv2.BORDER_CONSTANT, value=[0, 0, 0])
    
    print("Image resized and padded to {}x{}".format(img_size, img_size))
    
    return new_im, ratio, top, left

def overlay_transparent(background_img, img_to_overlay_t, x, y, overlay_size=None):
    bg_img = background_img.copy()
    # 투명도가 없는 경우, 투명도 RGBA(4채널)로 색상 변환
    if bg_img.shape[2] == 3:
        bg_img = cv2.cvtColor(bg_img, cv2.COLOR_BGR2BGRA)
    
    if overlay_size is not None:
        img_to_overlay_t = cv2.resize(img_to_overlay_t.copy(), overlay_size)
    
    # 컬러 채널별로 분리하기
    b, g, r, a = cv2.split(img_to_overlay_t)
    
    # 투명도 층: 부드럽게 삽입되도록 blur 처리
    mask = cv2.medianBlur(a, 5)
    h, w, _ = img_to_overlay_t.shape
    
    # 배경 이미지에서 오버레이 될 영역 설정
    roi = bg_img[int(y - h / 2):int(y + h / 2), int(x - w / 2):int(x + w / 2)]
    img1_bg = cv2.bitwise_and(roi.copy(), roi.copy(), mask=cv2.bitwise_not(mask))
    img2_fg = cv2.bitwise_and(img_to_overlay_t, img_to_overlay_t, mask=mask)
    bg_img[int(y - h / 2):int(y + h / 2), int(x - w / 2):int(x + w / 2)] = cv2.add(img1_bg, img2_fg)
    
    # 다시 투명도 층 제거하고 3채널 층으로 변환
    bg_img = cv2.cvtColor(bg_img, cv2.COLOR_BGRA2BGR)
    
    print("Image overlay completed at position ({}, {})".format(x, y))
    
    return bg_img

def validate_image(image):
    """이미지의 유효성을 검사하는 함수"""
    if image is None or image.size == 0:
        return False
    return True

# 이미지 처리 후 유효성 검사 예시
image_path = 'path_to_your_image.jpg'
image = cv2.imread(image_path)

if validate_image(image):
    resized_image, ratio, top, left = resize_img(image)
    print("Image is valid and resized successfully.")
else:
    print("Invalid image data detected.")