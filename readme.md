# 🧬 Research Knowledge Graph Visualizer

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-3.0-green.svg)](https://flask.palletsprojects.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Deploy to Render](https://img.shields.io/badge/Deploy%20to-Render-46E3B7.svg)](https://render.com/)

A powerful 3D interactive knowledge graph visualization tool for academic research synthesis matrices, specifically designed for metabolomics-based multi-cancer detection research. Transform your Excel-based literature reviews into explorable, three-dimensional networks that reveal hidden connections and research patterns.

![Knowledge Graph Demo](https://via.placeholder.com/800x400.png?text=3D+Knowledge+Graph+Visualization)

## ✨ Features

### 🎯 Core Capabilities
- **3D Interactive Visualization**: Navigate through your research data in an immersive 3D space using WebGL
- **Multi-Entity Graph Structure**: Visualizes papers, concepts, methodologies, authors, and research layers
- **Temporal Research Evolution**: Track how research progressed from foundation (2011-2019) to current contributions (2024-2025)
- **Smart Entity Extraction**: Automatically identifies and categorizes research elements from your synthesis matrix
- **Real-time Search & Filter**: Find specific papers, concepts, or authors instantly
- **Data Management Tools**: Remove duplicates, merge similar papers, and clean your dataset

### 🔬 Research-Specific Features
- **Literature Map Integration**: Built-in understanding of metabolomics cancer detection research structure
- **Concept Categorization**: 10+ predefined categories including metabolomics, cancer types, ML methods, biomarkers
- **Challenge Tracking**: Identifies and visualizes research gaps and challenges
- **Author Network Analysis**: Discover collaboration patterns and key researchers
- **Community Detection**: Automatic clustering of related research using graph algorithms
- **Centrality Metrics**: Node importance based on degree, betweenness, and eigenvector centrality

### 📊 Visualization Features
- **Dynamic Node Sizing**: Entity importance reflected through node size
- **Color-Coded Categories**: Different colors for papers, concepts, methods, chapters
- **Animated Link Particles**: Visualize relationship flow between entities
- **Community Boundaries**: See research clusters and their interconnections
- **Temporal Layers**: Research organized by time periods and evolution

## 🚀 Quick Start

### Prerequisites
- Python 3.8+ 
- Modern web browser with WebGL support
- 4GB RAM minimum (8GB recommended for large datasets)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/research-knowledge-graph.git
cd research-knowledge-graph
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Run the application**
```bash
python app.py
```

5. **Open your browser**
Navigate to `http://localhost:5000`

## 📁 Project Structure

```
research-knowledge-graph/
├── app.py                    # Main Flask application with graph processing
├── data_manager.py           # Utility for data cleaning and management
├── requirements.txt          # Python dependencies
├── render.yaml              # Render deployment configuration
├── deploy.sh                # Deployment automation script
├── templates/
│   └── index.html           # 3D visualization frontend
├── static/
│   └── data/               # Processed graph data (auto-created)
├── uploads/                # Excel file uploads (auto-created)
├── backups/                # Automatic backups (auto-created)
├── .github/
│   └── workflows/
│       └── deploy.yml      # CI/CD pipeline
└── docs/
    └── DEPLOY_TO_RENDER.md # Deployment guide
```

## 📊 Data Format

Your Excel synthesis matrix should contain these columns:

| Column Name | Description | Required |
|------------|-------------|----------|
| **Citation (APA 7 Format)** | Full citation in APA format | Yes |
| **TOPIC/MAIN IDEA** | Main research topic or focus | Yes |
| **SOURCE (AUTHOR, DATE)** | Author names and publication date | Yes |
| **POPULATION OF STUDY** | Study demographics and sample | No |
| **RESULTS/CONCLUSIONS** | Key findings | Yes |
| **LIMITATIONS** | Study limitations | No |
| **Chapter Association** | Chapter grouping (1-4) | No |
| **CONNECTION TO OTHER STUDIES** | Related research | No |
| **RELATION TO RESEARCH PROJECT** | Project relevance | No |

### Sample Data Structure
```excel
| S.No | SOURCE | TOPIC | POPULATION | RESULTS | ... |
|------|--------|-------|------------|---------|-----|
| 1 | Vaida (2024) | ML for breast cancer | 185 patients | 98% AUC | ... |
| 2 | Wishart (2016) | HMDB development | Database | 220,000 metabolites | ... |
```

## 🎮 Usage Guide

### Basic Workflow

1. **Upload Your Data**
   - Click "Choose File" and select your Excel synthesis matrix
   - Click "Process & Visualize" to generate the graph

2. **Navigate the Graph**
   - **Left Click + Drag**: Rotate the graph
   - **Right Click + Drag**: Pan the view  
   - **Scroll**: Zoom in/out
   - **Click Node**: View detailed information

3. **Search and Filter**
   - Use the search bar to find specific entities
   - Toggle entity types (Papers, Concepts, Methods, Chapters)
   - Enable/disable visual features (labels, particles, rotation)

4. **Data Management**
   - **Remove Duplicates**: Clean exact duplicate nodes/edges
   - **Merge Similar Papers**: Intelligently combine similar entries
   - **View Statistics**: See graph composition and metrics
   - **Clear All Data**: Reset with automatic backup

### Advanced Features

#### Temporal Analysis
The system automatically organizes research into temporal layers:
- **Foundation (2011-2019)**: Early metabolomics and statistical foundations
- **Challenge Identification (2021-2023)**: Small sample problems, reproducibility
- **Methodological Innovations (2022-2024)**: ML/AI advances, synthetic data
- **Current Contributions (2024-2025)**: Your dissertation and recent work

#### Community Detection
Automatic clustering reveals research themes:
- Papers in the same community share common concepts
- Community boundaries show research silos
- Cross-community links indicate interdisciplinary work

## 🔧 API Reference

### Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Main application page |
| `/api/upload` | POST | Upload and process Excel file |
| `/api/graph` | GET | Get current graph data |
| `/api/search` | POST | Search nodes by query |
| `/api/node/<id>` | GET | Get node details |
| `/api/timeline` | GET | Get temporal timeline |
| `/api/data/stats` | GET | Get graph statistics |
| `/api/data/deduplicate` | POST | Remove duplicates |
| `/api/data/merge-duplicates` | POST | Merge similar papers |
| `/api/data/clear` | POST | Clear all data |
| `/api/health` | GET | Health check endpoint |

### Graph Data Structure

```json
{
  "nodes": [
    {
      "id": "paper_1",
      "label": "Vaida (2024)",
      "type": "paper",
      "group": "papers",
      "size": 10,
      "metadata": {
        "title": "ML for breast cancer detection",
        "year": 2024,
        "layer": "challenge_identification"
      }
    }
  ],
  "links": [
    {
      "source": "paper_1",
      "target": "concept_ml",
      "type": "studies",
      "weight": 0.9
    }
  ],
  "metadata": {
    "total_nodes": 150,
    "total_edges": 450,
    "communities": 12
  }
}
```

## 🛠️ Configuration

### Environment Variables

Create a `.env` file with:

```env
# Flask Configuration
FLASK_ENV=development
FLASK_DEBUG=True
SECRET_KEY=your-secret-key-here

# File Upload
MAX_CONTENT_LENGTH=16777216  # 16MB
UPLOAD_FOLDER=uploads

# Graph Limits
GRAPH_NODE_LIMIT=10000
GRAPH_EDGE_LIMIT=50000

# Logging
LOG_LEVEL=INFO
```

### Customization

#### Modify Concept Categories
Edit in `app.py`:
```python
self.concept_categories = {
    'your_category': ['keyword1', 'keyword2'],
    # Add more categories
}
```

#### Change Color Scheme
Edit in `index.html`:
```javascript
const nodeColors = {
    paper: '#3B82F6',      // Blue
    concept: '#10B981',    // Green
    // Customize colors
};
```

## 🚢 Deployment

### Deploy to Render (Recommended)

1. Push code to GitHub
2. Connect to Render
3. Deploy with one click

See [DEPLOY_TO_RENDER.md](docs/DEPLOY_TO_RENDER.md) for detailed instructions.

### Deploy with Docker

```bash
# Build image
docker build -t research-graph .

# Run container
docker run -p 5000:5000 research-graph
```

### Deploy to Other Platforms

- **Heroku**: Use included `Procfile`
- **AWS**: Deploy as Elastic Beanstalk application
- **Google Cloud**: Use App Engine configuration
- **Azure**: Deploy as App Service

## 🧹 Data Management

### Command-Line Utilities

```bash
# Remove duplicates
python data_manager.py deduplicate

# Merge similar papers
python data_manager.py merge

# Create backup
python data_manager.py backup

# View statistics
python data_manager.py stats

# Clear all data
python data_manager.py clear
```

### Backup System

- Automatic backups before destructive operations
- Timestamped backup files in `backups/` directory
- Restore from any backup point

## 📈 Performance Optimization

### For Large Datasets (1000+ papers)

1. **Increase memory allocation**
```bash
export NODE_OPTIONS="--max-old-space-size=8192"
```

2. **Enable pagination**
```python
# In app.py
CHUNK_SIZE = 500  # Process in chunks
```

3. **Use production server**
```bash
gunicorn app:app --workers 4 --timeout 120
```

### Browser Performance

- Chrome/Edge recommended for best WebGL performance
- Close other tabs to free memory
- Disable unnecessary visual effects for large graphs

## 🧪 Testing

```bash
# Install test dependencies
pip install pytest pytest-flask pytest-cov

# Run tests
pytest tests/

# Run with coverage
pytest --cov=app tests/
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow PEP 8 for Python code
- Use meaningful variable names
- Add docstrings to functions
- Comment complex logic

## 📚 Research Context

This tool was developed for metabolomics-based multi-cancer detection research, addressing key challenges:

### Foundation Research (2011-2019)
- Statistical methods (Austin 2011)
- HMDB development (Wishart 2016, 2019)
- Early metabolomics applications (Jasbi 2019)

### Critical Challenges (2021-2023)
- Small sample problems (Schmidt 2021, Vaida 2024)
- Reproducibility issues (Mendez 2023)
- Statistical power requirements (Chen 2023, Kim 2023)

### Methodological Innovations (2022-2024)
- Feature engineering (Popuri 2023)
- Synthetic data augmentation (VAE, CTGAN approaches)
- Multi-omics integration (Huang 2024, Deng 2024)

### Current Contributions (2024-2025)
- Biologically-constrained synthetic data generation
- VAE + CTGAN hybrid approaches
- Clinical validation frameworks

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Graph not loading | Check browser console, ensure WebGL enabled |
| Upload fails | Verify Excel format, check file size < 16MB |
| Duplicate data | Use "Remove Duplicates" or "Merge Similar Papers" |
| Poor performance | Filter nodes, disable particles, use Chrome |
| Memory errors | Reduce dataset size or upgrade server resources |

### Getting Help

- Check [FAQ](docs/FAQ.md)
- Open an [Issue](https://github.com/yourusername/research-knowledge-graph/issues)
- Contact: your.email@example.com

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Three.js** and **3d-force-graph** for 3D visualization capabilities
- **NetworkX** for graph algorithms and analysis
- **Flask** community for excellent documentation
- **Render** for deployment platform
- Research community for metabolomics cancer detection advances

## 📖 Citation

If you use this tool in your research, please cite:

```bibtex
@software{research_knowledge_graph_2025,
  title = {Research Knowledge Graph Visualizer},
  author = {Popuri, Bharadwaj},
  year = {2025},
  url = {https://github.com/yourusername/research-knowledge-graph},
  description = {3D interactive visualization for research synthesis matrices}
}
```

## 🚀 Roadmap

### Version 2.0 (Q2 2025)
- [ ] AI-powered insight generation
- [ ] Real-time collaboration features
- [ ] Integration with citation databases (PubMed, Google Scholar)
- [ ] Export to common graph formats (GraphML, GEXF)

### Version 3.0 (Q4 2025)
- [ ] Machine learning predictions for research gaps
- [ ] Automated literature review generation
- [ ] Multi-language support
- [ ] Mobile app development

## 📊 Stats

- **Papers Processed**: 108+ research papers
- **Concepts Identified**: 10+ category types
- **Research Layers**: 4 temporal periods
- **Graph Metrics**: Degree, betweenness, eigenvector centrality
- **Visualization**: Real-time 3D WebGL rendering

---

**Built with ❤️ for the research community**

*Transforming literature reviews into living knowledge networks*