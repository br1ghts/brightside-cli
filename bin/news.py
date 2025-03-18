import sys
import os
import json
import requests
from bs4 import BeautifulSoup

# 🎨 ANSI Colors for Styling
COLOR_RED = "\033[91m"
COLOR_GREEN = "\033[92m"
COLOR_YELLOW = "\033[93m"
COLOR_BLUE = "\033[94m"
COLOR_CYAN = "\033[96m"
COLOR_RESET = "\033[0m"

# 🔍 Find the config file
CONFIG_FILE = os.path.join(os.path.dirname(__file__), "../config/news_sources.json")

def load_sources():
    """ Load news sources from JSON config file """
    try:
        with open(CONFIG_FILE, "r") as file:
            return json.load(file)
    except FileNotFoundError:
        print(f"{COLOR_RED}❌ Error: news_sources.json not found!{COLOR_RESET}")
        sys.exit(1)

def fetch_rss_feed(url):
    """ Fetch RSS feed using requests and parse it with BeautifulSoup """
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
    except requests.RequestException:
        print(f"{COLOR_RED}⚠️ Failed to fetch {url}{COLOR_RESET}")
        return None

    soup = BeautifulSoup(response.content, "xml")
    return soup

def fetch_news(category):
    """ Fetch and display news from RSS feeds """
    sources = load_sources()

    if category == "all":
        categories = sources.keys()
    elif category not in sources:
        print(f"{COLOR_RED}❌ Unknown category: {category}{COLOR_RESET}")
        print(f"🔹 Available categories: {', '.join(sources.keys())}\n")
        sys.exit(1)
    else:
        categories = [category]

    print(f"\n📡 {COLOR_CYAN}Fetching {category.upper()} news...{COLOR_RESET}\n")

    for cat in categories:
        print(f"{COLOR_YELLOW}{'='*40}\n🔍 {cat.upper()} NEWS\n{'='*40}{COLOR_RESET}")

        for url in sources[cat]:
            soup = fetch_rss_feed(url)
            if not soup:
                continue

            # Extract feed title and link
            title = soup.find("title").text if soup.find("title") else "Unknown Source"
            link = url
            print(f"\n📰 {COLOR_BLUE}{title}{COLOR_RESET} - {COLOR_CYAN}{link}{COLOR_RESET}")

            # Extract top 5 articles
            items = soup.find_all("item")[:5]
            for item in items:
                article_title = item.find("title").text if item.find("title") else "No title available"
                article_link = item.find("link").text if item.find("link") else "No link available"
                print(f"   {COLOR_GREEN}• {article_title}{COLOR_RESET}")
                print(f"     {COLOR_CYAN}{article_link}{COLOR_RESET}")

        print(f"\n{COLOR_YELLOW}{'-'*40}{COLOR_RESET}")  # Divider for readability

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"{COLOR_RED}❌ Usage: brightside news <category|all>{COLOR_RESET}\n")
        sys.exit(1)

    category = sys.argv[1]
    fetch_news(category)
