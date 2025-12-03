# tool WebToolLLM {
#     can web_search(query: str) -> str;
# }

node WebSearchNode {

    # ---- Option 1: Using MCP tool directly ----
    def search(query: str) -> str by tool("web_search");

    # ---- Option 2: Using Gemini 4.0 with LLM prompt ----
    def llm_search(query: str) -> str by llm(
        "You are a concise search summarizer. "
        "Given the raw search output below, extract: "
        "- one short summary (3–5 sentences), "
        "- one direct URL if available. "
        "RAW_INPUT: {query}"
    );

    can execute with task_manager entry {
        print("=== MCP TOOL SEARCH ===");
        result = self.search("latest AI news");
        print(result);

        print("=== LLM SUMMARIZED SEARCH ===");
        summarized = self.llm_search(result);
        print(summarized);
    }
}
