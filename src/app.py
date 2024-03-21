import time

from flask import Flask, redirect, render_template
from flask_vite import Vite

app = Flask(__name__)
vite = Vite(app)

# Define the pages as a list of dictionaries
pages = [
    {"path": "/hello", "title": "Hello"},
    {"path": "/clipboard", "title": "Clipboard"},
    {"path": "/slideshow", "title": "Slideshow"},
    {"path": "/content-loader", "title": "Content Loader"},
    {"path": "/tabs", "title": "Tabs"},
]


@app.route("/")
def home():
    return redirect(pages[0]["path"])


@app.route("/uptime")
def uptime():
    return f'<span data-content-loader-target="item">{time.time()}</span>'


@app.route("/<page>")
def show_page(page):
    # Find the current page from the pages list using the requested path
    # Flask's request.path includes the leading slash, adjust accordingly
    current_page = next((p for p in pages if p["path"] == f"/{page}"), None)
    if current_page:
        return render_template(f"{page}.html", pages=pages, current_page=current_page)
    else:
        return "Page not found", 404
