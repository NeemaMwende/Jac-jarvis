import logging
import time
import pyttsx3
import speech_recognition as sr

logging.basicConfig(level=logging.DEBUG)

MIC_INDEX = None
WAKE_WORD = "hello jarvis"

recognizer = sr.Recognizer()
mic = sr.Microphone(device_index=MIC_INDEX)

def listen_for_wake_word():
    """Listens once and returns 'wake_word_detected' if the wake word is heard."""
    with mic as source:
        recognizer.adjust_for_ambient_noise(source)
        logging.info("🎤 Listening for wake word...")
        audio = recognizer.listen(source)

    try:
        transcript = recognizer.recognize_google(audio).lower() # type: ignore
        logging.info(f"🗣 Heard: {transcript}")
        if WAKE_WORD in transcript:
            logging.info("✅ Wake word detected!")
            return "wake_word_detected"
    except sr.UnknownValueError:
        logging.warning("⚠️ Could not understand audio.")
    except Exception as e:
        logging.error(f"❌ Recognition error: {e}")
    return "no_wake_word"

def speak_text(text: str):
    """Uses pyttsx3 to speak the given text"""
    logging.info(f"🗣 Speaking: {text}")
    try:
        engine = pyttsx3.init()
        # Optionally pick a voice
        for voice in engine.getProperty("voices"):
            if "jamie" in voice.name.lower():  # Example: female voice
                engine.setProperty("voice", voice.id)
                break
        engine.setProperty("rate", 180)
        engine.setProperty("volume", 1.0)
        engine.say(text)
        engine.runAndWait()
        time.sleep(0.3)
    except Exception as e:
        logging.error(f"❌ TTS failed: {e}")
    return text