# 🔧 Fix for Render Deployment Error

## Problem
Your deployment is failing because Render is using Python 3.13, which has compatibility issues with pandas. The error shows:
```
error: too few arguments to function '_PyLong_AsByteArray'
```

## Solution

### Option 1: Specify Python Version (Recommended)

1. **Update runtime.txt**:
```
python-3.11.10
```

2. **In Render Dashboard**:
   - Go to your service → Settings → Environment
   - Add environment variable:
     - Key: `PYTHON_VERSION`
     - Value: `3.11.10`

3. **Trigger a new deploy**:
   - Either push a new commit
   - Or manually redeploy in Render Dashboard

### Option 2: Use Docker (More Control)

1. **Create a Dockerfile** in your project root:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p uploads static/data backups templates

EXPOSE 10000

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "2"]
```

2. **In Render Dashboard**:
   - Change your service type from "Python" to "Docker"
   - Redeploy

### Option 3: Use Minimal Requirements

1. **Create requirements_minimal.txt**:
```txt
Flask==3.0.0
Flask-CORS==4.0.0
gunicorn==21.2.0
pandas==2.0.3
numpy==1.24.3
openpyxl==3.1.2
networkx==3.1
Werkzeug==3.0.1
```

2. **Update render.yaml**:
```yaml
buildCommand: |
  pip install --upgrade pip==24.0
  pip install -r requirements_minimal.txt
```

### Option 4: Force Render to Use Python 3.11

1. **Update your render.yaml**:
```yaml
services:
  - type: web
    name: research-knowledge-graph
    runtime: python
    plan: free
    
    buildCommand: |
      python --version
      pip install --upgrade pip==24.0
      pip install -r requirements.txt --no-build-isolation
    
    startCommand: gunicorn app:app --bind 0.0.0.0:$PORT
    
    envVars:
      - key: PYTHON_VERSION
        value: "3.11"
```

2. **Create a .python-version file**:
```
3.11.10
```

3. **Commit and push**:
```bash
git add runtime.txt .python-version render.yaml
git commit -m "Fix Python version for Render"
git push
```

## Quick Fix Steps

1. **Replace your requirements.txt** with this tested version:
```txt
Flask==3.0.0
Flask-CORS==4.0.0
gunicorn==21.2.0
pandas==2.0.3
numpy==1.24.3
openpyxl==3.1.2
networkx==3.1
Werkzeug==3.0.1
python-dotenv==1.0.0
```

2. **Add runtime.txt** with:
```
python-3.11.10
```

3. **Update render.yaml** build command:
```yaml
buildCommand: |
  pip install --upgrade pip==24.0
  pip install -r requirements.txt
  mkdir -p uploads static/data backups templates
```

4. **Push changes**:
```bash
git add -A
git commit -m "Fix pandas build issue with Python 3.11"
git push
```

## Why This Happens

- **Python 3.13** (October 2024) introduced breaking changes in the C API
- **Pandas** uses Cython which generates C code
- The generated C code is incompatible with Python 3.13's new API
- **Solution**: Use Python 3.11 which is LTS and has excellent package support

## Verification

After deployment, check:
1. Build logs show `Python 3.11.x`
2. No pandas compilation errors
3. Health endpoint responds: `https://your-app.onrender.com/api/health`

## Alternative: Use Render's Python 3 Environment

If Render doesn't respect runtime.txt:

1. **Contact Render Support** to enable Python version selection
2. **Or use their Docker deployment** option for full control
3. **Or migrate to Railway/Fly.io** which have better Python version support

## Still Having Issues?

1. **Clear Render build cache**:
   - Dashboard → Settings → Clear build cache → Redeploy

2. **Use pre-built wheels**:
   ```yaml
   buildCommand: |
     pip install --only-binary :all: -r requirements.txt
   ```

3. **Minimal working setup**:
   - Remove pandas temporarily
   - Deploy basic Flask app
   - Add pandas back with version 2.0.3

## Success Indicators

✅ Build logs show: `Successfully installed pandas-2.0.3`  
✅ No compilation errors  
✅ Health check returns 200 OK  
✅ App loads in browser  

## Contact

If still failing:
- Check Render Status: https://status.render.com
- Render Support: support@render.com
- Include your build logs and this error reference