# import "./nodes/TaskHandling.jac";
# import "./nodes/EmailHandling.jac";
# import "./nodes/GeneralChat.jac";
import "./nodes/VoiceHandling.jac";

enum RoutingNodes { 
    # TASK_HANDLING,
    # EMAIL_HANDLING,
    # GENERAL_CHAT,
    VOICE_HANDLING
}

obj TaskPartition {
    has task: str;
    has agent_type: RoutingNodes;
}

walker task_manager {
    has utterance: str = "";
    has cur_task: TaskPartition = None;

    # LLM decides what agent should run
    def route_to_node(utterance: str) -> RoutingNodes by llm();

    # LLM breaks user instruction into subtasks
    def plan_tasks(main_task: str) -> list[TaskPartition] by llm();

    can execute with `root entry {
        print("=== Jarvis Assistant Activated ===");
        print("Utterance received →", self.utterance);

        # Step 1: Plan subtasks
        subtasks = self.plan_tasks(self.utterance);
        print("[Subtasks planned]:", subtasks);

        # Step 2: Node mapping
        node_map = {
            # RoutingNodes.TASK_HANDLING: TaskHandling,
            # RoutingNodes.EMAIL_HANDLING: EmailHandling,
            # RoutingNodes.GENERAL_CHAT: GeneralChat,
            RoutingNodes.VOICE_HANDLING: VoiceHandling
        };

        # Step 3: Execute subtasks
        for subtask in subtasks {
            node_type = node_map[subtask.agent_type];
            routed_node = [-->(`?node_type)];

            if not routed_node {
                routed_node = here ++> node_type();
            }

            self.cur_task = subtask;
            visit routed_node;

        }

        print("=== Finished Processing ===");
    }
}
