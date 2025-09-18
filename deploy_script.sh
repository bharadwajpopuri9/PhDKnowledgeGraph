#!/bin/bash

# Research Knowledge Graph - Render Deployment Script
# This script prepares and deploys the application to Render

set -e  # Exit on error

echo "🚀 Research Knowledge Graph - Deployment Script"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_warning "Not in a git repository. Initializing..."
    git init
    print_status "Git repository initialized"
fi

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Flask
instance/
.webassets-cache

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Project specific
uploads/
static/data/
backups/
*.xlsx
*.xls
*.csv
graph_data.json

# Logs
*.log
logs/

# Testing
.pytest_cache/
.coverage
htmlcov/

# Temporary files
tmp/
temp/
EOF
    print_status ".gitignore created"
fi

# Check for required files
echo ""
echo "Checking required files..."

REQUIRED_FILES=(
    "app.py"
    "requirements.txt"
    "templates/index.html"
    "render.yaml"
)

MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
        print_error "Missing: $file"
    else
        print_status "Found: $file"
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    echo ""
    print_error "Missing required files. Please ensure all files are present."
    exit 1
fi

# Create directories if they don't exist
echo ""
echo "Creating necessary directories..."

DIRECTORIES=(
    "uploads"
    "static/data"
    "backups"
    "templates"
)

for dir in "${DIRECTORIES[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_status "Created: $dir"
    else
        print_status "Exists: $dir"
    fi
done

# Create a .env file from .env.example if it doesn't exist
if [ ! -f .env ] && [ -f .env.example ]; then
    cp .env.example .env
    print_status "Created .env from .env.example"
    print_warning "Please update .env with your configuration"
fi

# Add and commit files to git
echo ""
echo "Preparing git repository..."

git add .
git commit -m "Deploy Research Knowledge Graph to Render" || true

# Check if render.yaml exists and is valid
if [ -f render.yaml ]; then
    print_status "render.yaml found"
else
    print_error "render.yaml not found"
    exit 1
fi

# Instructions for manual deployment
echo ""
echo "============================================="
echo "📋 DEPLOYMENT INSTRUCTIONS FOR RENDER"
echo "============================================="
echo ""
echo "1. Create a Render account (if you haven't already):"
echo "   ${GREEN}https://render.com/register${NC}"
echo ""
echo "2. Install Render CLI (optional but recommended):"
echo "   ${YELLOW}curl -sSL https://render.com/cli.sh | sh${NC}"
echo ""
echo "3. Push your code to GitHub:"
echo "   a. Create a new repository on GitHub"
echo "   b. Run these commands:"
echo "      ${YELLOW}git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git${NC}"
echo "      ${YELLOW}git branch -M main${NC}"
echo "      ${YELLOW}git push -u origin main${NC}"
echo ""
echo "4. Deploy on Render:"
echo "   Option A - Using Render Dashboard:"
echo "   a. Go to ${GREEN}https://dashboard.render.com${NC}"
echo "   b. Click 'New +' → 'Web Service'"
echo "   c. Connect your GitHub repository"
echo "   d. Render will auto-detect the render.yaml file"
echo "   e. Click 'Create Web Service'"
echo ""
echo "   Option B - Using Render CLI:"
echo "   ${YELLOW}render create${NC}"
echo ""
echo "5. Environment Variables to set in Render Dashboard:"
echo "   - SECRET_KEY: (Render will auto-generate if using render.yaml)"
echo "   - FLASK_ENV: production"
echo "   - Any other variables from .env.example"
echo ""
echo "6. Your app will be available at:"
echo "   ${GREEN}https://YOUR-APP-NAME.onrender.com${NC}"
echo ""
echo "============================================="
echo "📝 POST-DEPLOYMENT CHECKLIST"
echo "============================================="
echo ""
echo "[ ] Test the health endpoint: /api/health"
echo "[ ] Upload a test Excel file"
echo "[ ] Verify 3D graph visualization works"
echo "[ ] Check data management features"
echo "[ ] Monitor logs in Render dashboard"
echo ""
echo "============================================="
echo "🎉 Ready for deployment!"
echo "============================================="

# Create a simple deployment info file
cat > DEPLOYMENT.md << 'EOF'
# Deployment Information

## Service Details
- **Platform**: Render
- **Service Type**: Web Service
- **Runtime**: Python 3.11
- **Framework**: Flask with Gunicorn

## URLs
- **Production**: https://YOUR-APP-NAME.onrender.com
- **Health Check**: https://YOUR-APP-NAME.onrender.com/api/health

## Monitoring
- View logs: Render Dashboard → Your Service → Logs
- View metrics: Render Dashboard → Your Service → Metrics

## Troubleshooting

### If deployment fails:
1. Check build logs in Render dashboard
2. Verify all dependencies in requirements.txt
3. Ensure templates/index.html exists
4. Check Python version compatibility

### If app crashes:
1. Check runtime logs
2. Verify environment variables are set
3. Check file upload size limits
4. Monitor memory usage

### Common Issues:
- **Template not found**: Ensure templates/ directory exists
- **Module not found**: Check requirements.txt
- **Port binding**: Render provides PORT env variable automatically
- **Static files**: Ensure static/ directory structure is correct

## Updating the Application

1. Make changes locally
2. Test thoroughly
3. Commit and push to GitHub
4. Render will auto-deploy (if enabled)

Or manually trigger deploy:
```bash
git push origin main
```

## Backup and Recovery

Backups are stored in the `backups/` directory.
To recover data:
1. Access Render Shell
2. Navigate to backups/
3. Copy desired backup to static/data/graph_data.json

## Support

For issues specific to:
- **Render platform**: https://render.com/docs
- **Application**: Check application logs and error messages
EOF

print_status "Created DEPLOYMENT.md with additional information"

echo ""
echo "Run ${YELLOW}cat DEPLOYMENT.md${NC} to view deployment documentation"
echo ""

# Final check
echo "============================================="
read -p "Ready to proceed with deployment? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Great! Follow the instructions above to complete deployment."
else
    print_warning "Deployment cancelled. Run this script again when ready."
fi