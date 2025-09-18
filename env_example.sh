# Environment Variables for Research Knowledge Graph
# Copy this file to .env and update with your values

# Flask Configuration
FLASK_APP=app.py
FLASK_ENV=production
FLASK_DEBUG=False
SECRET_KEY=your-secret-key-here-change-this-in-production

# Server Configuration
PORT=10000
HOST=0.0.0.0

# File Upload Settings
MAX_CONTENT_LENGTH=16777216  # 16MB in bytes
UPLOAD_FOLDER=uploads
ALLOWED_EXTENSIONS=xlsx,xls,csv

# CORS Settings
CORS_ORIGINS=*  # Change to specific domains in production

# Data Storage
DATA_PATH=static/data
BACKUP_PATH=backups

# Redis Configuration (for rate limiting - optional)
# REDIS_URL=redis://localhost:6379

# Logging
LOG_LEVEL=INFO
LOG_FORMAT=json

# Performance
GRAPH_NODE_LIMIT=10000  # Maximum nodes to prevent memory issues
GRAPH_EDGE_LIMIT=50000  # Maximum edges

# Optional: External Services
# SENTRY_DSN=your-sentry-dsn-for-error-tracking
# ANALYTICS_ID=your-google-analytics-id

# Optional: Database URL (for future enhancements)
# DATABASE_URL=postgresql://user:password@host:port/database

# Security
SECURE_HEADERS=True
SESSION_COOKIE_SECURE=True
SESSION_COOKIE_HTTPONLY=True
SESSION_COOKIE_SAMESITE=Lax