# # ============================================================================
# # BACKEND: Data Models and Walkers
# # ============================================================================
# node Todo {
#     has text: str;
#     has done: bool = False;
# }

# walker create_todo {
#     has text: str;

#     can create with `root entry {
#         new_todo = here ++> Todo(text=self.text);
#         report new_todo ;
#     }
# }

# # ============================================================================
# # FRONTEND: Components, State, and Events
# # ============================================================================
# cl import from react {
#     useState
# }

# cl {
#     def app()  -> any {
#         let [todos, setTodos] = useState([]);
#         let [input, setInput] = useState("");

#         # Event Handler
#         async def addTodo()  -> None {
#             if not input.trim() {
#                 return;
#             }
#             response = root spawn create_todo(text=input.trim());
#             new_todo = response.reports[0][0];
#             setTodos(todos.concat([new_todo]));
#             setInput("");
#         }

#         return <div>
#             <h2>
#                 My Todos
#             </h2>
#             <input
#                 value={input}
#                 onChange={lambda  e: any  -> None{ setInput(e.target.value);} }
#                 onKeyPress={lambda  e: any  -> None{ if e.key == "Enter" {
#                     addTodo();
#                 }} }
#             />
#             <button
#                 onClick={addTodo}
#             >
#                 Add Todo
#             </button>
#             <div>
#                 {todos.map(
#                     lambda  todo: any  -> any{ return <div
#                         key={todo._jac_id}
#                     >
#                         <span>
#                             {todo.text}
#                         </span>
#                     </div>; }
#                 )}
#             </div>
#         </div>;
#     }
# }

# cl import from react { useState, useEffect }
# cl import from "@jac-client/utils" { Router, Routes, Route, Link }

# cl {
#     # Page Components
#     def Home()  -> any {
#         return <div>
#             <h1>
#                 Home Page
#             </h1>
#             <p>
#                 Welcome to the home page!
#             </p>
#         </div>;
#     }

#     def About()  -> any {
#         return <div>
#             <h1>
#                 ℹ About Page
#             </h1>
#             <p>
#                 Learn more about our application.
#             </p>
#         </div>;
#     }

#     def Contact()  -> any {
#         return <div>
#             <h1>
#                 Contact Page
#             </h1>
#             <p>
#                 Email: contact@example.com
#             </p>
#         </div>;
#     }

#     # Main App with React Router
#     def app()  -> any {
#         return <Router>
#             <div>
#                 <nav>
#                     <Link to="/">
#                         Home
#                     </Link>
#                     {" | "}
#                     <Link to="/about">
#                         About
#                     </Link>
#                     {" | "}
#                     <Link to="/contact">
#                         Contact
#                     </Link>
#                 </nav>
#                 <Routes>
#                     <Route
#                         path="/"
#                         element={<Home />}
#                     />
#                     <Route
#                         path="/about"
#                         element={<About />}
#                     />
#                     <Route
#                         path="/contact"
#                         element={<Contact />}
#                     />
#                 </Routes>
#             </div>
#         </Router>;
#     }
# }
cl import from "@jac-client/utils" { useNavigate }

cl {
    def LoginForm()  -> any {
        let [username, setUsername] = useState("");
        let [password, setPassword] = useState("");
        let navigate = useNavigate();

        async def handleLogin(e: any) -> None {
            e.preventDefault();
            success = await jacLogin(username, password);
            if success {
                navigate("/dashboard");  # Navigate after successful login
            } else {
                alert("Login failed");
            }
        }

        return <form
            onSubmit={handleLogin}
        >
            <input
                type="text"
                value={username}
                onChange={lambda  e: any  -> None{ setUsername(e.target.value);} }
                placeholder="Username"
            />
            <input
                type="password"
                value={password}
                onChange={lambda  e: any  -> None{ setPassword(e.target.value);} }
                placeholder="Password"
            />
            <button type="submit">
                Login
            </button>
        </form>;
    }
}
