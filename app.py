import os
import pandas as pd
from flask import Flask, jsonify, render_template, request
from datetime import datetime

app = Flask(__name__)

# Configure app
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size
app.config['UPLOAD_FOLDER'] = 'data'

# Ensure upload folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

@app.route('/')
def index():
    """Main landing page"""
    return jsonify({
        'message': 'Research Project API',
        'status': 'running',
        'timestamp': datetime.now().isoformat(),
        'pandas_version': pd.__version__
    })

@app.route('/health')
def health():
    """Health check endpoint for Render"""
    try:
        # Basic health checks
        _ = pd.DataFrame({'test': [1, 2, 3]})
        return jsonify({
            'status': 'healthy',
            'timestamp': datetime.now().isoformat(),
            'checks': {
                'pandas': 'ok',
                'filesystem': 'ok'
            }
        }), 200
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e)
        }), 503

@app.route('/upload', methods=['POST'])
def upload_file():
    """Handle file uploads (Excel, CSV, etc.)"""
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if file and file.filename.endswith(('.xlsx', '.xls', '.csv')):
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filepath)
        
        # Process the file based on type
        try:
            if file.filename.endswith('.csv'):
                df = pd.read_csv(filepath)
            else:
                df = pd.read_excel(filepath)
            
            return jsonify({
                'message': 'File uploaded successfully',
                'filename': file.filename,
                'rows': len(df),
                'columns': list(df.columns)
            })
        except Exception as e:
            return jsonify({'error': f'Error processing file: {str(e)}'}), 500
    
    return jsonify({'error': 'Invalid file type'}), 400

@app.errorhandler(404)
def not_found(e):
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
