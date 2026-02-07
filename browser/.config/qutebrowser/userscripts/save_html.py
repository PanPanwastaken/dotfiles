#!/usr/bin/env python3
"""
Qutebrowser userscript to save current page HTML.

Install:
    cp save_html.py ~/.local/share/qutebrowser/userscripts/
    chmod +x ~/.local/share/qutebrowser/userscripts/save_html.py

Usage in qutebrowser:
    :spawn --userscript save_html.py

The HTML will be saved to /tmp/declan_twitter/page.html
"""
import sys
import os
from pathlib import Path

# Output location
OUTPUT_DIR = Path("/tmp/declan_twitter")
OUTPUT_FILE = OUTPUT_DIR / "page.html"

def main():
    # Create output directory
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    # Read HTML from stdin (qutebrowser pipes page content)
    html = sys.stdin.read()
    
    if not html:
        send_message("error", "No HTML received from stdin")
        return 1
    
    # Save to file
    try:
        OUTPUT_FILE.write_text(html, encoding='utf-8')
        send_message("info", f"Saved {len(html)} chars to {OUTPUT_FILE}")
    except Exception as e:
        send_message("error", f"Failed to save: {e}")
        return 1
    
    return 0


def send_message(level: str, text: str):
    """Send message back to qutebrowser."""
    fifo = os.environ.get('QUTE_FIFO')
    if fifo:
        try:
            with open(fifo, 'w') as f:
                f.write(f'message-{level} "{text}"\n')
        except:
            pass
    
    # Also print for debugging
    print(f"[{level}] {text}", file=sys.stderr)


if __name__ == "__main__":
    sys.exit(main())
