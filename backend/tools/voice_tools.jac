toolset VoiceTools {
    can trigger_wake_word;     # event-style tool call
    can listen_for_wake_word;  # long-poll / continuous listener
    can transcribe_audio;
    can speak_text;
}
