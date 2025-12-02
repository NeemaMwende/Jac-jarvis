import "/home/neemah/jac_jarvis/backend/nodes/VoiceHandling.jac";

walker task_manager {
    has utterance: str = "start voice mode";
    has cur_task: str = None;

    can execute with `root entry {
        print("=== Jarvis Voice Assistant Starting ===");

        # Create and visit the VoiceHandling node
        voice_node = here ++> VoiceHandling();
        visit voice_node;

        print("=== Voice Handling Done ===");
    }
}
