import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    hostname = os.environ.get('HOSTNAME', 'unknown')
    return f"""
    <html>
        <head>
            <title>Docker Web App</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 50px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    text-align: center;
                }}
                .container {{
                    background: rgba(0, 0, 0, 0.3);
                    padding: 30px;
                    border-radius: 10px;
                    max-width: 600px;
                    margin: 0 auto;
                }}
                h1 {{ color: #fff; }}
                p {{ font-size: 18px; }}
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🐳 Docker Web Application</h1>
                <p><strong>Welcome!</strong></p>
                <p>Container Hostname: <code>{hostname}</code></p>
                <p>Status: ✅ Running Successfully</p>
            </div>
        </body>
    </html>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
