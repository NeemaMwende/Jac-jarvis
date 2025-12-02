client VoiceClient {
    uses VoiceServer;

    can listen() {
        return VoiceServer.listen_for_wake_word();
    }

    can speak(text: str) {
        return VoiceServer.speak_text(text=text);
    }
}
