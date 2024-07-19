import uvicorn  # pip install uvicorn
from fastapi import FastAPI, HTTPException, UploadFile, File  # pip install fastapi
from fastapi.middleware.cors import CORSMiddleware
import vgg16_prediction_model
import logging
import os

os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

# Create the FastAPI application
app = FastAPI()

# CORS configuration
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load the model once
try:
    vgg16_model = vgg16_prediction_model.load_model()
    logger.info("Model loaded successfully")
except Exception as e:
    logger.error("Failed to load model: %s", e)
    raise

# A simple example of a GET request
@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "테스트 실행"

@app.get('/sample')
async def sample_prediction():
    try:
        result = await vgg16_prediction_model.prediction_model(vgg16_model, 'sample_data/jellyfish.jpg')  # Update with actual path
        logger.info("Prediction was requested and done")
        return result
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")

# 이미지 파일을 받는 POST 요청 핸들러 추가
@app.post("/predict")
async def predict_image(file: UploadFile = File(...)):
    file_location = f"temp_{file.filename}"
    try:
        # 받은 이미지를 임시 파일로 저장
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info("File saved at %s", file_location)

        # 이미지 파일을 사용하여 예측 작업 수행
        prediction_result = await vgg16_prediction_model.prediction_model(vgg16_model, file_location)
        logger.info("Prediction done for %s", file_location)
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        # 임시 파일 삭제
        os.remove(file_location)

    return prediction_result

# 서버 실행
if __name__ == "__main__":
    uvicorn.run(
        "server_test:app",
        reload=True,  # 코드 변경 시 서버 자동 재시작
        host="127.0.0.1",  # localhost에서 실행
        port=5000,  # 포트 5000에서 실행
        log_level="info"  # 로그 레벨
    )