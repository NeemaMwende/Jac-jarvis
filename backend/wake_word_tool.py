import speech_recognition as sr
import logging
import pyttsx3
import time

logging.basicConfig(level=logging.DEBUG)

recognizer = sr.Recognizer()
mic = sr.Microphone(device_index=None)  # Use default or set MIC_INDEX

def listen_for_wake_word():
    with mic as source:
        recognizer.adjust_for_ambient_noise(source)
        logging.info("🎤 Listening for wake word...")
        audio = recognizer.listen(source)
    try:
        transcript = recognizer.recognize_google(audio).lower() # type: ignore
        logging.info(f"🗣 Heard: {transcript}")
        if "hello jarvis" in transcript:
            return "wake_word_detected"
    except sr.UnknownValueError:
        logging.warning("⚠️ Could not understand audio.")
    except Exception as e:
        logging.error(f"❌ Recognition error: {e}")
    return "no_wake_word"

def speak_text(text: str):
    logging.info(f"Jac says: {text}")
    try:
        engine = pyttsx3.init()
        engine.say(text)
        engine.runAndWait()
        time.sleep(0.3)
    except Exception as e:
        logging.error(f"❌ TTS failed: {e}")
    return text
