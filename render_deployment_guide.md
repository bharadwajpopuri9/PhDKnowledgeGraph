# 🚀 Deploy Research Knowledge Graph to Render

This guide will walk you through deploying your Research Knowledge Graph visualization application to Render.

## 📋 Prerequisites

1. **GitHub Account**: [Sign up here](https://github.com/join)
2. **Render Account**: [Sign up here](https://render.com/register) - Free tier available
3. **Git installed**: Check with `git --version`

## 🗂️ Project Structure

Ensure your project has the following structure:

```
research-knowledge-graph/
├── app.py                    # Flask application (production-ready version)
├── requirements.txt          # Python dependencies
├── render.yaml              # Render configuration
├── runtime.txt              # Python version
├── .env.example             # Environment variables template
├── deploy.sh               # Deployment script
├── templates/
│   └── index.html          # Frontend template
├── static/                 # Static files (created automatically)
│   └── data/
├── uploads/                # Upload directory (created automatically)
├── backups/                # Backup directory (created automatically)
└── data_manager.py         # Data management utility
```

## 🔧 Step 1: Prepare Your Code

### 1.1 Use the Production-Ready Files

Replace your development files with the production versions:

1. **app.py**: Use the production-ready version with security headers and optimizations
2. **requirements.txt**: Use the production requirements with gunicorn
3. **index.html**: Ensure it's in the `templates/` folder

### 1.2 Create Environment Configuration

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your settings (for local testing only)
# Render will use environment variables from its dashboard
```

### 1.3 Test Locally

```bash
# Install dependencies
pip install -r requirements.txt

# Run the app
python app.py

# Visit http://localhost:5000 to verify it works
```

## 📦 Step 2: Push to GitHub

### 2.1 Initialize Git Repository

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - Research Knowledge Graph"
```

### 2.2 Create GitHub Repository

1. Go to [GitHub](https://github.com/new)
2. Create a new repository (e.g., `research-knowledge-graph`)
3. Keep it public or private (Render works with both)
4. Don't initialize with README (you already have files)

### 2.3 Push Your Code

```bash
# Add remote origin (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/research-knowledge-graph.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## 🚢 Step 3: Deploy to Render

### Option A: Deploy with render.yaml (Recommended)

1. **Go to Render Dashboard**: https://dashboard.render.com/

2. **Create New Web Service**:
   - Click "New +" → "Web Service"
   - Select "Build and deploy from a Git repository"
   - Click "Next"

3. **Connect GitHub**:
   - Click "Connect GitHub"
   - Authorize Render to access your repositories
   - Select your `research-knowledge-graph` repository

4. **Render will detect render.yaml**:
   - It will automatically use the configuration from `render.yaml`
   - Review the settings:
     - **Name**: Choose a unique name (e.g., `research-knowledge-graph`)
     - **Region**: Select closest to your users
     - **Branch**: `main`
     - **Runtime**: Python 3
     - **Build Command**: Auto-detected from render.yaml
     - **Start Command**: Auto-detected from render.yaml

5. **Create Web Service**:
   - Click "Create Web Service"
   - Render will start building and deploying your app

### Option B: Manual Configuration

If you prefer to configure manually:

1. **New Web Service** → Connect your GitHub repo

2. **Configure settings**:
   ```
   Name: research-knowledge-graph
   Environment: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: gunicorn app:app --bind 0.0.0.0:$PORT --workers 2 --timeout 120
   Plan: Free (or Starter for better performance)
   ```

3. **Add Environment Variables**:
   - Click "Environment" tab
   - Add these variables:
     ```
     FLASK_ENV=production
     FLASK_DEBUG=False
     SECRET_KEY=<click-generate>
     MAX_CONTENT_LENGTH=16777216
     ```

## 🔐 Step 4: Configure Environment Variables

In Render Dashboard → Your Service → Environment:

### Required Variables:

| Variable | Value | Description |
|----------|-------|-------------|
| `SECRET_KEY` | Click "Generate" | Flask secret key for sessions |
| `FLASK_ENV` | `production` | Flask environment |
| `FLASK_DEBUG` | `False` | Disable debug mode |
| `MAX_CONTENT_LENGTH` | `16777216` | Max upload size (16MB) |
| `CORS_ORIGINS` | `*` | Allowed origins (restrict in production) |

### Optional Variables:

| Variable | Value | Description |
|----------|-------|-------------|
| `LOG_LEVEL` | `INFO` | Logging level |
| `GRAPH_NODE_LIMIT` | `10000` | Maximum nodes to prevent memory issues |
| `GRAPH_EDGE_LIMIT` | `50000` | Maximum edges |

## ✅ Step 5: Verify Deployment

### 5.1 Check Build Logs

1. Go to Render Dashboard → Your Service → Logs
2. Watch the build process
3. Look for "Build successful" message

### 5.2 Access Your App

Your app will be available at:
```
https://YOUR-APP-NAME.onrender.com
```

### 5.3 Test Functionality

1. **Health Check**: Visit `https://YOUR-APP-NAME.onrender.com/api/health`
2. **Main Page**: Visit `https://YOUR-APP-NAME.onrender.com`
3. **Upload Test**: Try uploading your Excel file
4. **Graph Visualization**: Verify 3D graph renders correctly

## 🔄 Step 6: Continuous Deployment

### Automatic Deploys

With render.yaml configured:
- Every push to `main` branch triggers automatic deployment
- Monitor deployments in Render Dashboard → Deploys

### Manual Deploy

To trigger manual deployment:
1. Render Dashboard → Your Service → Manual Deploy
2. Click "Deploy latest commit"

### Using GitHub Actions

1. Get your Render API key:
   - Account Settings → API Keys → Create API Key

2. Add to GitHub Secrets:
   - Repository → Settings → Secrets → Actions
   - Add `RENDER_API_KEY` and `RENDER_SERVICE_ID`

3. GitHub Actions will now run tests and deploy automatically

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. **Build Fails**
```
Error: Module not found
```
**Solution**: Check requirements.txt has all dependencies

#### 2. **Template Not Found**
```
Error: Template not found: index.html
```
**Solution**: Ensure templates/ directory exists and contains index.html

#### 3. **Port Binding Error**
```
Error: Cannot bind to port
```
**Solution**: Use `$PORT` environment variable, not hardcoded port

#### 4. **Memory Issues**
```
Error: Memory quota exceeded
```
**Solution**: 
- Upgrade to paid plan for more memory
- Reduce node/edge limits in environment variables
- Optimize data processing

#### 5. **File Upload Fails**
```
Error: Request entity too large
```
**Solution**: Check MAX_CONTENT_LENGTH environment variable

### Viewing Logs

1. **Build Logs**: Render Dashboard → Your Service → Logs → Build
2. **Runtime Logs**: Render Dashboard → Your Service → Logs → Runtime
3. **Shell Access** (Paid plans): Render Dashboard → Your Service → Shell

## 📊 Monitoring

### Health Monitoring

- Render automatically monitors `/api/health` endpoint
- Set up alerts: Settings → Notifications

### Performance Metrics

- View in Render Dashboard → Metrics
- Monitor: Response time, Memory usage, CPU usage

### Custom Monitoring

Add to your app.py:
```python
# Integrate with monitoring services
# Sentry, DataDog, New Relic, etc.
```

## 🔒 Security Best Practices

1. **Environment Variables**: Never commit `.env` file
2. **Secret Key**: Use Render's generated secret key
3. **CORS**: Restrict origins in production
4. **HTTPS**: Render provides automatic SSL
5. **Headers**: Security headers are included in production app
6. **File Validation**: Always validate uploaded files

## 💰 Render Pricing

### Free Tier
- ✅ Perfect for testing and small projects
- 512 MB RAM
- 0.1 CPU
- Spins down after 15 min inactivity
- Limited to 750 hours/month

### Starter ($7/month)
- ✅ Recommended for production
- 512 MB RAM
- 0.5 CPU
- Always on
- Custom domains

### Standard ($25/month)
- For higher traffic
- 2 GB RAM
- 1.0 CPU
- Autoscaling available

## 🆘 Getting Help

### Resources

- **Render Docs**: https://render.com/docs
- **Render Community**: https://community.render.com
- **Flask Docs**: https://flask.palletsprojects.com
- **Project Issues**: Create issue in your GitHub repo

### Support Channels

- **Render Support**: support@render.com
- **Status Page**: https://status.render.com

## 🎉 Success Checklist

- [ ] Code pushed to GitHub
- [ ] Render account created
- [ ] Web service deployed
- [ ] Environment variables configured
- [ ] Health check passing
- [ ] File upload working
- [ ] 3D graph rendering
- [ ] Data management features working
- [ ] Automatic deploys enabled

## 📈 Next Steps

1. **Add Custom Domain**: Settings → Custom Domains
2. **Enable Auto-Scaling**: Settings → Scaling (paid plans)
3. **Set Up Monitoring**: Integrate Sentry or DataDog
4. **Add Database**: For persistent storage, add PostgreSQL
5. **Implement Caching**: Add Redis for better performance
6. **Add CDN**: Use Cloudflare for static assets

---

**Congratulations! Your Research Knowledge Graph is now live on Render! 🎊**

Visit your app at: `https://YOUR-APP-NAME.onrender.com`