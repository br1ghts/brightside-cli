import sys
import os
import json

try:
    import feedparser
except ImportError:
    print("❌ Missing dependency: feedparser")
    print("💡 Try running: pipx install feedparser or pip install --user feedparser")
    sys.exit(1)

# Dynamically find the config directory
CONFIG_FILE = os.path.join(os.path.dirname(__file__), "../config/news_sources.json")

def load_sources():
    """ Load news sources from JSON config file """
    try:
        with open(CONFIG_FILE, "r") as file:
            return json.load(file)
    except FileNotFoundError:
        print("❌ Error: news_sources.json not found!")
        sys.exit(1)

def fetch_news(category):
    """ Fetch and display news from RSS feeds """
    sources = load_sources()

    if category == "all":
        categories = sources.keys()
    elif category not in sources:
        print(f"❌ Unknown category: {category}")
        print(f"Available categories: {', '.join(sources.keys())}")
        sys.exit(1)
    else:
        categories = [category]

    for cat in categories:
        print(f"\n🔍 Fetching {cat.upper()} news...\n")
        for url in sources[cat]:
            feed = feedparser.parse(url)
            
            # Handle missing fields safely
            title = feed.feed.get("title", "Unknown Source")
            link = feed.feed.get("link", url)

            print(f"📰 {title} ({link})")

            for entry in feed.entries[:5]:  # Get top 5 articles per source
                article_title = entry.get("title", "No title available")
                article_link = entry.get("link", "No link available")
                print(f"  - {article_title} ({article_link})")

        print("\n" + "-" * 50)  # Divider for readability

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("❌ Usage: brightside news <category|all>")
        sys.exit(1)

    category = sys.argv[1]
    fetch_news(category)