import from byllm.lib { Model }
import time;
import from sheets_tool { get_email_from_contacts }

glob llm: Model = Model(model_name="gemini/gemini-2.0-flash");

# ------------------------------
# Task Object
# ------------------------------
node Task {
    has task: str;
    has date: str;
    has time: str;
}

# ------------------------------
# TASK HANDLING NODE
# ------------------------------
node TaskHandling {
    def get_current_time()  -> str {
        return time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime());
    }

    def add_task(task: str, date: str, time: str) -> str {
        task_created = Task(task=task, date=date, time=time);
        self ++> task_created;
        return "Task added successfully";
    }

    def summarize_tasks()  -> str {
        scheduled_tasks = [self-->(`?Task)];
        return str(scheduled_tasks);
    }

    def write_emails()  -> str {
        return "Email writing stub, no content yet.";
    }

    def route_and_run(utterance: str) -> str by llm(
        method="ReAct",
        tools=[
            self.add_task,
            self.get_current_time,
            self.summarize_tasks,
            self.write_emails
        ]
    );

    can execute with task_manager entry {
        print("[TaskHandling Node Activated]");
        response = self.route_and_run(visitor.cur_task.task);
        print("→", response);

        report {
            "utterance": visitor.cur_task.task,
            "response": response,
            "node_type": self.__class__.__name__
        } ;
    }
}
# EMAIL HANDLING NODE
# ------------------------------
# ------------------------------
node EmailHandling {
    def get_email_from_contacts(name: str) -> str {
        return "catherine@example.com";
    }
    #can get_email_from_contacts(name: str) -> str;
    def write_email_content(utterance: str) -> str by llm(
        method="ReAct", tools=[self.get_email_from_contacts]
    );

    def route_and_run(utterance: str) -> str by llm(
        method="ReAct", tools=[self.write_email_content, self.get_email_from_contacts]
    );

    can execute with task_manager entry {
        print("[EmailHandling Node Activated]");
        response = self.route_and_run(visitor.cur_task.task);
        print("→", response);

        report {
            "utterance": visitor.cur_task.task,
            "response": response,
            "node_type": self.__class__.__name__
        } ;
    }
}

# ------------------------------
# ------------------------------
# GENERAL CHAT NODE
# GENERAL CHAT NODE
# ------------------------------
# ------------------------------
node GeneralChat {
    def chat(utterance: str) -> str by llm();
    can execute with task_manager entry {
        print("[GeneralChat Node Activated]");
        response = self.chat(visitor.cur_task.task);
        print("→", response);

        report {
            "utterance": visitor.cur_task.task,
            "response": response,
            "node_type": self.__class__.__name__
        } ;
    }
}

# ------------------------------
# ------------------------------
# ROUTING ENUM
# ROUTING ENUM
# ------------------------------
# ------------------------------
enum RoutingNodes {
    TASK_HANDLING,
    EMAIL_HANDLING,
    GENERAL_CHAT
}

obj TaskPartition {
    has task: str;
    has agent_type: RoutingNodes;
}

# ------------------------------
# ------------------------------
# TASK MANAGER WALKER
# TASK MANAGER WALKER
# ------------------------------
# ------------------------------
walker task_manager {
    has utterance: str = "";
    has cur_task: TaskPartition = None;

    def route_to_node(utterance: str) -> RoutingNodes by llm();
    def plan_tasks(main_task: str) -> list[TaskPartition] by llm();
    can execute with root entry {
        subtasks = self.plan_tasks(self.utterance);
        print("[Planned Subtasks]:", subtasks);

        node_map = {
            RoutingNodes.TASK_HANDLING: TaskHandling,
            RoutingNodes.EMAIL_HANDLING: EmailHandling,
            RoutingNodes.GENERAL_CHAT: GeneralChat
        };

        for subtask in subtasks {
            node_type = node_map[subtask.agent_type];

            routed_node = [-->(`?node_type)];
            if not routed_node {
                routed_node = here ++> node_type();
            }

            self.cur_task = subtask;
            visit routed_node;
        }
    }
}

# ------------------------------
# ------------------------------
# MAIN ENTRY
# MAIN ENTRY
# ------------------------------
# ------------------------------
with entry {
    user_input: str = str(input("Hello Angel how can I help you today? "));
    task_manager(utterance=user_input) spawn root;
}
