from langchain.tools import tool
from ddgs import DDGS # type: ignore
import requests
from bs4 import BeautifulSoup # type: ignore
def _fetch_page_text(url: str) -> str:
    """Download webpage content with browser headers and return clean text."""
    try:
        # If DuckDuckGo redirect, extract the real URL
        if "duckduckgo.com/l/?" in url and "uddg=" in url:
            import urllib.parse
            parsed = urllib.parse.parse_qs(url.split("?")[1])
            url = urllib.parse.unquote(parsed.get("uddg", [""])[0])

        headers = {
            "User-Agent": (
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/119.0 Safari/537.36"
            )
        }

        resp = requests.get(url, timeout=10, headers=headers)
        resp.raise_for_status()

    except Exception as e:
        return f"I found a result but could not retrieve the webpage. Reason: {e}"

    soup = BeautifulSoup(resp.text, "html.parser")

    for tag in soup(["script", "style"]):
        tag.extract()

    text = " ".join(soup.get_text(separator=" ").split())

    return text[:1500] + "..." if len(text) > 1500 else text


@tool("web_search", return_direct=False)
def web_search(query: str) -> str:
    """
    Searches DuckDuckGo and returns readable content from the top result.
    
    Use this when the user wants:
    - real-time information
    - answers requiring web browsing
    - summaries of web pages

    Input: natural language search query
    """
    with DDGS() as ddgs:
        results = ddgs.text(query, region="us-en", max_results=5)
        results_list = list(results)

    if not results_list:
        return f"No results found for: {query}"

    # Prefer Wikipedia if available
    wiki = next((r for r in results_list if "wikipedia.org" in r["href"]), results_list[0])

    title = wiki["title"]
    url = wiki["href"]

    page_text = _fetch_page_text(url)

    return (
        
        # f"🔍 **Search Query:** {query}\n"
        f"Certainly maam, here's the top result for: \"{query}\"\n\n"
        # f"🏷 **Top Result:** {title}\n"
        # f"🔗 **URL:** {url}\n\n"
        f"📄 **Extracted Content:**\n{page_text}"
    )


if __name__ == "__main__":
    print(web_search.invoke("How many continents are there?"))
