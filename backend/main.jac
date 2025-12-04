import from byllm.lib { Model }

glob llm: Model = Model(model_name = "gemini/gemini-2.0-flash");

def write_emails(num1: int, num2: int) -> int {
    print("___calling the multiply tool ___");
    return num1 * num2;
}

def set_appointments(num1: int, num2: int) -> int {
    print("___calling the addition tool ___");
    return num1 + num2;
}

def get_time(num1: int, num2: int) -> int {
    print("___calling the subtraction tool ___");
    return num1 - num2;
}

def make_calls(num1: int, num2: int) -> float {
    print("___calling the division tool ___");
    if num2 == 0 {
        print("Enter a number > than 0");
    }
    return num1 / num2;
} 

def general_chat(num1: int, num2: int) -> float {
    print("___calling the division tool ___");
    if num2 == 0 {
        print("Enter a number > than 0");
    }
    return num1 / num2;
}

def browse_the_internet(num1: int, num2: int) -> float {
    print("___calling the division tool ___");
    if num2 == 0 {
        print("Enter a number > than 0");
    }
    return num1 / num2;
}

def voice_activation(num1: int, num2: int) -> float {
    print("___calling the division tool ___");
    if num2 == 0 {
        print("Enter a number > than 0");
    }
    return num1 / num2;
}

walker execute_command{
    has user_message: str;

    def do_math(user_message:str) -> str by llm(
        method = "ReAct",
        tools = [voice_activation, browse_the_internet, general_chat, get_time, write_emails, set_appointments]
    );

    can calculate with `root entry{
        result = self.do_math(self.user_message);
        print("Result: " + result);
    }
}

with entry {
    user_input: str = str(input("Hello, how can i help you today?: "));
    execute_command(
        user_message = user_input
    ) spawn root;
}