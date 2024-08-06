import uvicorn
from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import xception_prediction_model
import google.generativeai as genai
import logging
import os
import random
from fastapi.staticfiles import StaticFiles
from fastapi.exceptions import RequestValidationError
import cv2
import numpy as np
from vertexai_model import VertexAIModel
from googletrans import Translator
#import dlib

def translate_to_korean(text):
    translator = Translator()
    translation = translator.translate(text, dest='ko')
    return translation.text

# TensorFlow의 특정 최적화 기능 비활성화 (환경 변수 설정)
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

# FastAPI 애플리케이션 생성
app = FastAPI()


# Vertex AI 모델 초기화
vertexai_model = VertexAIModel(project_id="avian-axis-431702-k7", location="us-central1")

# CORS 설정
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 모델을 한 번만 로드합니다.
try:
    model = xception_prediction_model.load_model_custom()
    logger.info("Model loaded successfully")
except Exception as e:
    logger.error("Failed to load model: %s", e)
    raise

# API 키를 직접 설정 (환경 변수에서 가져오는 대신)
api_key = 'AIzaSyAH0o1g3SV1OTx38z2O3tBfid7YE6878tU'  # 실제 API 키로 변경하세요
if not api_key:
    raise ValueError('No GOOGLE_API_KEY found')

# Generative AI 모델 설정
genai.configure(api_key=api_key)

# 개 머리 감지 모델 로드
#try:
#    dog_head_cascade = dlib.cnn_face_detection_model_v1('./dogHeadDetector.dat')  # 실제 경로로 변경
#    logger.info("Dog head detector model loaded successfully")
#except Exception as e:
#    logger.error("Failed to load dog head detector model: %s", e)
#    raise

# 이미지 파일이 저장된 디렉토리 경로
image_dir = 'https://5fef-221-145-193-52.ngrok-free.app/images/'

@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "테스트 실행"

@app.get('/sample')
async def sample_prediction():
    try:
        result = xception_prediction_model.load_and_predict(model, 'sample_data/jellyfish.jpg')
        logger.info("Sample prediction result: %s", result)
        return result
    except Exception as e:
        logger.error("Sample prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")

@app.post("/predict")
async def predict_image(file: UploadFile = File(...)):
    file_location = f"temp_{file.filename}"
    try:
        # 파일을 서버에 저장
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info("File saved at %s", file_location)
        
        # 이미지 예측
        prediction_result = xception_prediction_model.load_and_predict(model, file_location)
        logger.info("Prediction result for %s: %s", file_location, prediction_result)
        
        return prediction_result
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        if os.path.exists(file_location):
            os.remove(file_location)
'''
@app.post("/analyze_image")
async def analyze_image(file: UploadFile = File(...)):
    file_location = f"temp_{file.filename}"
    try:
        # 파일을 서버에 저장
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info("파일이 %s에 저장되었습니다.", file_location)
        
        # Generative AI API에 파일 업로드 및 분석 요청
        sample_file = genai.upload_file(path=file_location, display_name=file.filename)
        logger.info("파일 '%s'이(가) 업로드되었습니다: %s", sample_file.display_name, sample_file.uri)

        # Generative 모델 선택
        model = genai.GenerativeModel('gemini-1.5-pro')  # 적절한 모델 선택

        # 분석 요청 프롬프트 설정
        prompt = "이 이미지를 분석해 주세요"
        response = model.generate_content([sample_file.uri, prompt])
        
        # 분석 결과 로그
        logger.info("분석 결과: %s", response.text)
        analysis_result = response.text

        return JSONResponse(content={"analysis_result": analysis_result})
    except Exception as e:
        logger.error("분석 실패: %s", e)
        raise HTTPException(status_code=500, detail="내부 서버 오류")
    finally:
        if os.path.exists(file_location):
            os.remove(file_location)
'''

@app.post("/generate_image_caption")
async def generate_image_caption(file: UploadFile = File(...)):
    file_location = f"temp_{file.filename}"
    try:
        # 파일을 서버에 저장
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info("File saved at %s", file_location)
        
        # 이미지 캡션 생성
        captions = vertexai_model.generate_captions(file_location, num_results=3, language="en")
        logger.info("Generated captions: %s", captions)

        # 캡션을 한글로 번역
        captions_korean = [translate_to_korean(caption) for caption in captions]
        logger.info("Generated captions in Korean: %s", captions_korean)
        
        return JSONResponse(content={"captions": captions_korean})
    except Exception as e:
        logger.error("Caption generation failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        if os.path.exists(file_location):
            os.remove(file_location)

'''
@app.post("/detect_dog_head")
async def detect_dog_head(file: UploadFile = File(...)):
    file_location = f"temp_{file.filename}"
    output_file_location = f"output_{file.filename}"
    try:
        # 파일을 서버에 저장
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info("File saved at %s", file_location)
        
        # 이미지 파일 로드
        image = cv2.imread(file_location)
        if image is None:
            raise ValueError("Failed to read image")
        
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

        # 개 머리 감지
        dog_heads = dog_head_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

        # 감지 결과를 이미지에 그리기
        for (x, y, w, h) in dog_heads:
            cv2.rectangle(image, (x, y), (x+w, y+h), (0, 255, 0), 2)

        # 결과 이미지를 임시 파일로 저장
        cv2.imwrite(output_file_location, image)
        logger.info("Detection result image saved at %s", output_file_location)

        return JSONResponse(content={"message": "Dog head detection completed", "result_image_url": f"{image_dir}{output_file_location}"})
    except Exception as e:
        logger.error("Dog head detection failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        if os.path.exists(file_location):
            os.remove(file_location)
        if os.path.exists(output_file_location):
            os.remove(output_file_location)
'''
@app.get("/random_images")
async def get_random_images(num_images: int = 10):
    try:
        image_files = [f for f in os.listdir('C:/Study/archive/images') if f.endswith('.jpg')]
        random_image_files = random.sample(image_files, min(num_images, len(image_files)))
        image_urls = [f"{image_dir}{img}" for img in random_image_files]
        
        return JSONResponse(content={"images": image_urls})
    except Exception as e:
        logger.error("Failed to get random images: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")

# 이미지 파일 서빙 엔드포인트 추가
app.mount("/images", StaticFiles(directory="C:/Study/archive/images"), name="images")

# 예외 처리기 추가
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request, exc):
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors(), "body": exc.body},
    )

@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail},
    )

if __name__ == "__main__":
    uvicorn.run(
        "xception_server:app",
        reload=True,
        host="0.0.0.0",
        port=5000,
        log_level="info"
    )