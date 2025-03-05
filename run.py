import os
import sys
import webbrowser
from threading import Timer
from app import app

def open_browser():
    webbrowser.open_new('http://localhost:5000/')

if __name__ == '__main__':
    # Determine if application is a script file or frozen exe
    if getattr(sys, 'frozen', False):
        template_folder = os.path.join(sys._MEIPASS, 'templates')
        static_folder = os.path.join(sys._MEIPASS, 'static')
        app.template_folder = template_folder
        app.static_folder = static_folder
    
    # Open browser after a short delay
    Timer(1.5, open_browser).start()
    
    # Start Flask app
    app.run(host='localhost', port=5000)