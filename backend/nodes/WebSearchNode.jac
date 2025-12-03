node WebSearchNode {
    def search(query: str) -> str by tool("web_search");

    can execute with task_manager entry {
        result = self.search("latest AI news");
        print(result);
    }
} 


