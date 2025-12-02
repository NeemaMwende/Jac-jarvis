node VoiceHandling {
    has wake_phrase: str = "hello jarvis";
    has waiting: bool = false;

    def start_voice_activation() -> str by llm(
        method="ReAct",
        tools=([self.listen_for_wake_word])
    ) {}

    def listen_for_wake_word -> str by tool("listen_for_wake_word");

    can execute with task_manager entry {
        print("[VoiceHandling] Listening for wake word...");
        response = self.start_voice_activation();
        print("Wake word event:", response);

        report {
            "event": response,
            "node": self.__class__.__name__
        };
    }
}
