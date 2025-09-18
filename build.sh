#!/bin/bash

# Exit on error
set -e

echo "==> Starting build process..."

# Clear any cached pip packages that might be corrupted
echo "==> Clearing pip cache..."
pip cache purge || true

# Upgrade pip, setuptools, and wheel first
echo "==> Installing build tools..."
pip install --no-cache-dir --upgrade pip==23.3.1
pip install --no-cache-dir --upgrade setuptools==68.2.2
pip install --no-cache-dir --upgrade wheel==0.41.3

# Verify installations
echo "==> Verifying build tools..."
python -c "import setuptools; print(f'Setuptools version: {setuptools.__version__}')"
pip --version

# Install requirements with proper flags
echo "==> Installing project dependencies..."
pip install --no-cache-dir --no-deps -r requirements.txt
pip install --no-cache-dir -r requirements.txt

# Create necessary directories
echo "==> Setting up project structure..."
mkdir -p static templates data logs

# Run any data preprocessing or setup
if [ -f "setup.py" ]; then
    echo "==> Running setup.py..."
    python setup.py install
fi

if [ -f "app.py" ]; then
    echo "==> Verifying app imports..."
    python -c "import app; print('App module loaded successfully')"
fi

echo "==> Build completed successfully!"

# Display installed packages for verification
echo "==> Installed packages:"
pip list
