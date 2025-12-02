import "/home/neemah/jac_jarvis/backend/mcp_server.jac";

node VoiceHandling {
    # Call MCP Python tools
    def listen_for_wake_word -> str by tool("listen_for_wake_word");
    def speak(text: str) -> str by tool("speak_text");

    can execute with task_manager entry {
        print("[VoiceHandling] Listening for wake word...");
        result = self.listen_for_wake_word();

        if (result == "wake_word_detected") {
            print("Wake word detected! Responding...");
            self.speak("Yes ma'am");
        } else {
            print("No wake word detected.");
        }

        report {
            "event": result,
            "node": self.__class__.__name__
        };
    }
}
