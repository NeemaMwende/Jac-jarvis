import "../mcp_client.jac";

node VoiceHandling {
    has wake_phrase: str = "hello jarvis";

    def listen_for_wake_word -> str by tool("listen_for_wake_word");
    def speak(text: str) -> str by tool("speak_text");

    can execute with task_manager entry {
        print("[VoiceHandling] Listening for wake word...");
        result = self.listen_for_wake_word();
        if (result == "wake_word_detected") {
            print("Wake word detected! Responding...");
            self.speak("Yes ma'am");
        }
        report {
            "event": result,
            "node": self.__class__.__name__
        };
    }
}
