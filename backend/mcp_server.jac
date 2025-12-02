import * as tools from "./tools/voice_tools.jac";

tool_server VoiceServer {
    expose tools.VoiceTools.listen_for_wake_word as "listen_for_wake_word";
    expose tools.VoiceTools.trigger_wake_word as "trigger_wake_word";
    expose tools.VoiceTools.transcribe_audio as "transcribe_audio";
    expose tools.VoiceTools.speak_text as "speak_text";
}
