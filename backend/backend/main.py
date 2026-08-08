# backend/main.py
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import os
from dotenv import load_dotenv

# .env फाइल से API Keys लोड करना
load_dotenv()

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Real-time Neural Speech Bridge Server is Running!"}

@app.websocket("/ws/translate")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    print("Client Connected for Real-time Translation!")
    
    try:
        while True:
            # 1. फ्रंट-एंड (फ्लटर ऐप) से लाइव ऑडियो चंक (Binary Data) रिसीव करना
            audio_chunk = await websocket.receive_bytes()
            
            # TODO: यहाँ पर आगे हम अपना AI पाइपलाइन जोड़ेंगे:
            # - Whisper API (Audio to Text)
            # - Translation Model (Text Translation)
            # - ElevenLabs / TTS API (Text to Audio & Voice Cloning)
            
            # अभी टेस्टिंग के लिए जो ऑडियो मिला है, वही वापस भेज रहे हैं
            processed_audio_chunk = audio_chunk 
            
            # 2. ट्रांसलेटेड ऑडियो चंक वापस फ्रंट-एंड (इयरफोन) पर भेजना
            await websocket.send_bytes(processed_audio_chunk)
            
    except WebSocketDisconnect:
        print("Client Disconnected.")
    except Exception as e:
        print(f"Error occurred: {e}")
