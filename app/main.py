from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import base64
import face_recognition
import numpy as np
import io

app = FastAPI()


class ImagePayload(BaseModel):
    profile: str
    front: str
    left: str
    right: str


def decode_image(b64_str):
    return face_recognition.load_image_file(io.BytesIO(base64.b64decode(b64_str)))


@app.post("/verify")
def verify_faces(data: ImagePayload):
    try:
        images = {
            "front": decode_image(data.front),
            "left": decode_image(data.left),
            "right": decode_image(data.right),
        }
        profile_img = decode_image(data.profile)
        known_encoding = face_recognition.face_encodings(profile_img)[0]

        results = {}
        for pose, img in images.items():
            encodings = face_recognition.face_encodings(img)
            if not encodings:
                results[pose] = {"match": False, "reason": "No face found"}
                continue

            match = face_recognition.compare_faces([known_encoding], encodings[0])[0]
            distance = face_recognition.face_distance([known_encoding], encodings[0])[0]
            results[pose] = {
                "match": match,
                "distance": float(distance),
                "confidence": float(1 - distance),
            }

        verified = all([res["match"] for res in results.values()])
        return {"verified": verified, "results": results}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
