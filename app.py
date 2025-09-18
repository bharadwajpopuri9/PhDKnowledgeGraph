import os
import pandas as pd
from flask import Flask, render_template, request, jsonify, send_file, redirect, url_for
from datetime import datetime
import json
from werkzeug.utils import secure_filename
import io
import base64
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
app.config['UPLOAD_FOLDER'] = 'data'
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'research-project-2025')

# Create necessary directories
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.makedirs('static', exist_ok=True)
os.makedirs('templates', exist_ok=True)

# Global variable to store the research data
research_data = None
data_summary = None

@app.route('/')
def index():
    """Main landing page with research overview"""
    return render_template('index.html', 
                         data_loaded=(research_data is not None),
                         data_summary=data_summary)

@app.route('/health')
def health():
    """Health check for Render"""
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    """Handle file uploads and display data"""
    global research_data, data_summary
    
    if request.method == 'POST':
        if 'file' not in request.files:
            return redirect(url_for('upload', error='No file selected'))
        
        file = request.files['file']
        if file.filename == '':
            return redirect(url_for('upload', error='No file selected'))
        
        if file and file.filename.endswith(('.xlsx', '.xls', '.csv')):
            try:
                # Save and read the file
                filename = secure_filename(file.filename)
                filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                file.save(filepath)
                
                # Read data based on file type
                if filename.endswith('.csv'):
                    research_data = pd.read_csv(filepath)
                else:
                    research_data = pd.read_excel(filepath)
                
                # Generate summary statistics
                data_summary = {
                    'filename': filename,
                    'rows': len(research_data),
                    'columns': len(research_data.columns),
                    'column_names': research_data.columns.tolist(),
                    'upload_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                }
                
                # Clean the data (handle NaN values)
                research_data = research_data.fillna('')
                
                return redirect(url_for('analysis'))
            except Exception as e:
                return redirect(url_for('upload', error=str(e)))
        else:
            return redirect(url_for('upload', error='Invalid file type'))
    
    # GET request - show upload form
    error = request.args.get('error')
    return render_template('upload.html', error=error, data_summary=data_summary)

@app.route('/analysis')
def analysis():
    """Display data analysis and visualizations"""
    if research_data is None:
        return redirect(url_for('upload'))
    
    # Prepare data for display
    table_html = research_data.head(20).to_html(classes='table table-striped table-hover', index=False)
    
    # Generate basic statistics
    stats = {}
    for col in research_data.select_dtypes(include=['number']).columns:
        stats[col] = {
            'mean': round(research_data[col].mean(), 2) if pd.notna(research_data[col].mean()) else 'N/A',
            'std': round(research_data[col].std(), 2) if pd.notna(research_data[col].std()) else 'N/A',
            'min': round(research_data[col].min(), 2) if pd.notna(research_data[col].min()) else 'N/A',
            'max': round(research_data[col].max(), 2) if pd.notna(research_data[col].max()) else 'N/A'
        }
    
    # Generate a simple visualization if possible
    chart_url = None
    if len(research_data.select_dtypes(include=['number']).columns) > 0:
        try:
            fig, ax = plt.subplots(figsize=(10, 6))
            numeric_cols = research_data.select_dtypes(include=['number']).columns[:5]  # First 5 numeric columns
            research_data[numeric_cols].boxplot(ax=ax)
            ax.set_title('Data Distribution Overview')
            ax.set_xlabel('Variables')
            ax.set_ylabel('Values')
            plt.xticks(rotation=45, ha='right')
            plt.tight_layout()
            
            # Convert plot to base64 string
            img = io.BytesIO()
            plt.savefig(img, format='png')
            img.seek(0)
            chart_url = base64.b64encode(img.getvalue()).decode()
            plt.close()
        except:
            pass
    
    return render_template('analysis.html', 
                         table=table_html,
                         stats=stats,
                         data_summary=data_summary,
                         chart_url=chart_url)

@app.route('/search')
def search():
    """Search within the research data"""
    if research_data is None:
        return redirect(url_for('upload'))
    
    query = request.args.get('q', '')
    if query:
        # Search across all string columns
        mask = research_data.astype(str).apply(lambda x: x.str.contains(query, case=False, na=False)).any(axis=1)
        results = research_data[mask]
        results_html = results.to_html(classes='table table-striped', index=False) if not results.empty else None
    else:
        results_html = None
    
    return render_template('search.html', 
                         query=query, 
                         results=results_html,
                         data_summary=data_summary)

@app.route('/api/data')
def api_data():
    """API endpoint to get raw data as JSON"""
    if research_data is None:
        return jsonify({'error': 'No data loaded'}), 404
    
    # Return first 100 rows as JSON
    return jsonify(research_data.head(100).to_dict(orient='records'))

@app.route('/download')
def download():
    """Download the processed data"""
    if research_data is None:
        return redirect(url_for('upload'))
    
    # Create CSV in memory
    output = io.StringIO()
    research_data.to_csv(output, index=False)
    output.seek(0)
    
    return send_file(
        io.BytesIO(output.getvalue().encode()),
        mimetype='text/csv',
        as_attachment=True,
        download_name=f'processed_data_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
    )

@app.errorhandler(404)
def not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(500)
def server_error(e):
    return render_template('500.html'), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
