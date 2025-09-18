# Fix Render Deployment: Python 3.13 + Pandas Compatibility Issue

## Problem
Your Render deployment is failing because pandas cannot compile with Python 3.13.4. The error shows:
```
error: too few arguments to function '_PyLong_AsByteArray'
```

This is due to breaking changes in Python 3.13's C API that pandas hasn't adapted to yet.

## Solution Options

### Option 1: Downgrade Python (Recommended - Quick Fix)

#### Step 1: Create/Update `runtime.txt`
Create a file named `runtime.txt` in your project root:
```
python-3.11.9
```

#### Step 2: Update `requirements.txt`
Pin your scientific packages to stable versions:
```txt
# Core Flask app
Flask==3.0.0
Flask-CORS==4.0.0
gunicorn==21.2.0

# Data processing (compatible with Python 3.11)
pandas>=2.0.3,<2.2.0
numpy>=1.24.3,<1.26.0
networkx>=3.1
openpyxl>=3.1.0

# Visualization
plotly>=5.15.0
matplotlib>=3.7.0

# Optional: Add any other packages you need
scikit-learn>=1.3.0,<1.4.0
scipy>=1.11.0,<1.12.0
```

### Option 2: Use Pre-built Wheels (Alternative)

If you must use Python 3.12, update your `requirements.txt`:
```txt
# Use specific pandas version that has Python 3.12 wheels
pandas==2.1.4
numpy==1.25.2
```

### Option 3: Docker Approach (Most Reliable)

Create a `Dockerfile`:
```dockerfile
FROM python:3.11.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Run application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

## Render Configuration

### If using `runtime.txt` (Option 1):
1. Add `runtime.txt` with `python-3.11.9`
2. Update `requirements.txt` with pinned versions
3. Commit and push changes
4. Render will automatically use Python 3.11.9

### If using Docker (Option 3):
1. In Render dashboard, set:
   - **Runtime**: Docker
   - **Dockerfile Path**: `./Dockerfile`
   - **Build Command**: (leave empty)
   - **Start Command**: (leave empty, uses CMD from Dockerfile)

## Testing Locally

Before deploying, test locally:

```bash
# Create virtual environment with Python 3.11
python3.11 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Test your Flask app
python app.py
```

## Additional Render Settings

In your Render service settings:
- **Build Command**: `pip install -r requirements.txt`
- **Start Command**: `gunicorn app:app --bind 0.0.0.0:$PORT`
- **Environment Variables**: Add any needed env vars

## Why This Happens

Python 3.13 introduced breaking changes to internal C APIs:
- `_PyLong_AsByteArray` function signature changed
- Many C extensions (like pandas' Cython code) haven't updated yet
- Pre-compiled wheels aren't available for Python 3.13

## Long-term Solution

Eventually, pandas will release Python 3.13 compatible versions. Monitor:
- pandas GitHub releases
- PyPI for pandas versions with Python 3.13 support

For now, Python 3.11.9 is the most stable choice for data science applications.

## Quick Checklist

- [ ] Create `runtime.txt` with `python-3.11.9`
- [ ] Update `requirements.txt` with pinned versions
- [ ] Commit and push changes
- [ ] Redeploy on Render
- [ ] Check build logs for success

## If You Still Have Issues

1. Check Render build logs for other dependency conflicts
2. Ensure all scientific packages are compatible
3. Consider using conda-pack for complex dependency management
4. Contact me with specific error messages if problems persist
