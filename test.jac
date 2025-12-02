node TaskHandling {
    def get_current_time()  -> str {
        return time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime());
    }

    def add_task(task: str, date: str, time: str) -> str {
        task_created = Task(task=task, date=date, time=time);
        self ++> task_created;
        return "Task added successfully";
    }

    def summarize_tasks -> str {
        scheduled_tasks = [self-->(`?Task)];
        return str(scheduled_tasks);
    }

    def route_and_run(utterance: str) -> str by llm(
        method="ReAct",
        tools=([self.add_task, self.get_current_time, self.summarize_tasks])
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

node EmailHandling {
    def write_email_content(utterance: str) -> str by llm();
    def route_and_run(utterance: str) -> str by llm(
        method="ReAct", tools=([self.write_email_content])
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

enum RoutingNodes { TASK_HANDLING, EMAIL_HANDLING, GENERAL_CHAT }

obj TaskPartition {
    has task: str;
    has agent_type: RoutingNodes;
}

walker task_manager {
    has utterance: str = "";
    has cur_task: TaskPartition = None;

    def route_to_node(utterance: str) -> RoutingNodes by llm();
    def plan_tasks(main_task: str) -> list[TaskPartition] by llm();
    can execute with `root entry {
        # Step 1: Plan - decompose the user's request
        subtasks = self.plan_tasks(self.utterance);
        print("[Planned Subtasks]:", subtasks);

        # Step 2: Map agent types to node classes
        node_map = {
            RoutingNodes.TASK_HANDLING: TaskHandling,
            RoutingNodes.EMAIL_HANDLING: EmailHandling,
            RoutingNodes.GENERAL_CHAT: GeneralChat
        };

        # Step 3: Execute - route and visit each agent
        for subtask in subtasks {
            node_type = node_map[subtask.agent_type];
            routed_node = [-->(`?node_type)];  # Check if agent exists
            if not routed_node {
                routed_node = here ++> node_type();  # Create if doesn't exist
            }
            self.cur_task = subtask;  # Pass subtask to agent
            visit routed_node;  # Trigger agent's can execute ability

        }
    }
}
