from langchain.tools import tool
from ddgs import DDGS
import requests
from bs4 import BeautifulSoup

def _fetch_page_text(url: str) -> str:
    try:
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
    with DDGS() as ddgs: # type: ignore
        results = list(ddgs.text(query, region="us-en", max_results=5))

    if not results:
        return f"No results found for: {query}"

    wiki = next((r for r in results if "wikipedia.org" in r["href"]), results[0])

    url = wiki["href"]
    text = _fetch_page_text(url)

    return f"""
Top result for: {query}

URL: {url}

Summary:
{text}
"""
