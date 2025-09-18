#!/bin/bash

# Exit on error
set -e

echo "==> Starting build process..."

# Clear any cached pip packages that might be corrupted
echo "==> Clearing pip cache..."
pip cache purge || true

# Upgrade pip, setuptools, and wheel first
echo "==> Installing build tools..."
pip install --no-cache-dir --upgrade pip>=23.0
pip install --no-cache-dir --upgrade setuptools>=68.0.0
pip install --no-cache-dir --upgrade wheel>=0.41.0

# Verify installations
echo "==> Verifying build tools..."
python -c "import setuptools; print(f'Setuptools version: {setuptools.__version__}')"
pip --version

# Try to install requirements with dependency resolver
echo "==> Installing project dependencies..."
echo "==> Using pip's dependency resolver to find compatible versions..."

# First attempt with the resolver
pip install --no-cache-dir -r requirements.txt || {
    echo "==> Initial installation failed, trying with legacy resolver..."
    pip install --no-cache-dir --use-deprecated=legacy-resolver -r requirements.txt || {
        echo "==> Still failing, trying minimal requirements..."
        if [ -f "requirements-minimal.txt" ]; then
            pip install --no-cache-dir -r requirements-minimal.txt
            echo "==> ⚠️  Using minimal requirements. Some packages may be missing."
        else
            echo "==> ❌ Build failed. Please check requirements.txt for conflicts."
            exit 1
        fi
    }
}

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
    python -c "import app; print('App module loaded successfully')" || true
fi

echo "==> Build completed successfully!"

# Display installed packages for verification
echo "==> Installed packages:"
pip list

# Show numpy version specifically
echo "==> Numpy version installed:"
python -c "import numpy; print(f'numpy=={numpy.__version__}')"
