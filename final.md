# Django Video Hosting Platform - Complete Documentation

> A secure, password-protected video hosting platform built with Django

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Project Structure](#project-structure)
3. [System Architecture](#system-architecture)
4. [Features & Configuration](#features--configuration)
5. [Testing Guide](#testing-guide)
6. [Deployment Checklist](#deployment-checklist)
7. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Automated Setup (Recommended)

```powershell
# Navigate to project directory
cd "d:\Girish\encrypted hosting\video_hosting"

# Run automated setup script
.\SETUP.ps1

# Start the server
python manage.py runserver
```

### Manual Setup

```powershell
# 1. Create virtual environment
python -m venv venv

# 2. Activate virtual environment
.\venv\Scripts\Activate.ps1

# 3. Install dependencies
pip install -r requirements.txt

# 4. Run migrations
python manage.py migrate

# 5. Create superuser
python manage.py createsuperuser

# 6. Start server
python manage.py runserver
```

### First Steps

1. **Access Admin**: http://127.0.0.1:8000/admin/
2. **Upload Video**: Login → Upload page → Fill form
3. **Watch Video**: http://127.0.0.1:8000/watch/ → Enter password

---

## Project Structure

```
video_hosting/
├── 📄 manage.py                    # Django management script
├── 📄 requirements.txt             # Python dependencies
├── 🗄️ db.sqlite3                   # SQLite database
│
├── 📁 venv/                        # Virtual environment
│
├── 📁 media/                       # User uploaded files
│   ├── videos/                     # Video files
│   └── thumbnails/                 # Thumbnail images
│
├── 📁 video_hosting/               # Main project directory
│   ├── __init__.py
│   ├── settings.py                 # Project settings
│   ├── urls.py                     # Root URL configuration
│   ├── wsgi.py                     # WSGI configuration
│   └── asgi.py                     # ASGI configuration
│
└── 📁 videos/                      # Main application
    ├── 📁 migrations/              # Database migrations
    ├── 📁 templates/videos/        # HTML templates
    │   ├── base.html               # Base template
    │   ├── home.html               # Homepage
    │   ├── watch.html              # Video list
    │   ├── enter_password.html     # Password entry
    │   ├── view_video.html         # Video player
    │   ├── admin_dashboard.html    # Admin dashboard
    │   └── upload_video.html       # Upload form
    │
    ├── __init__.py
    ├── admin.py                    # Admin interface config
    ├── apps.py                     # App configuration
    ├── models.py                   # Database models
    ├── views.py                    # View functions
    ├── urls.py                     # App URL patterns
    ├── forms.py                    # Form definitions
    └── tests.py                    # Unit tests
```

### Key Files Explained

**models.py** - Two main models:
- `Video`: Stores video metadata, password hash, view count
- `VideoAccessSession`: Manages temporary access sessions (1-hour expiry)

**views.py** - Core functionality:
- Public views: home, watch list, password entry, video player
- Admin views: dashboard, upload, delete
- Security: session validation, password verification

**forms.py** - User input handling:
- `VideoUploadForm`: Upload videos with passwords
- `VideoPasswordForm`: Password verification

---

## System Architecture

### Overall System Flow

```
User Browser
     ↓
Django Application
     ├─→ URL Router
     ├─→ Views Layer
     ├─→ Models Layer
     └─→ Templates
     ↓
├─→ SQLite Database (metadata)
└─→ Media Storage (video files)
```

### Visitor Workflow

```
Visit Homepage
     ↓
Browse Videos
     ↓
Click Video → Enter Password
     ↓
Verify Password
     ↓
Create Session (1 hour)
     ↓
Watch Video (stream)
```

### Admin Workflow

```
Admin Login
     ↓
Admin Dashboard
     ↓
Upload Video
     ├─→ Fill form (title, file, password)
     ├─→ Validate input
     └─→ Save (hash password, store file)
     ↓
Video Available to Users
```

### Security Layers

```
1. Authentication    → Django Admin Login
2. Authorization     → Session-based Access Control
3. Password Hash     → PBKDF2-SHA256
4. Session Expiry    → 1-hour automatic timeout
5. CSRF Protection   → Django Middleware
6. URL Protection    → Session validation on stream
```

### Password Security Flow

```
User Input: "mypassword123"
     ↓
video.set_password()
     ↓
Django's make_password()
     ↓
PBKDF2 + SHA256 Hashing
     ↓
Hash: "pbkdf2_sha256$260000$..."
     ↓
Stored in Database

Verification:
User Input → check_password() → Compare Hash → True/False
```

### Session Management

```
Correct Password Entered
     ↓
Create VideoAccessSession
     ├─ session_key: Random UUID
     ├─ video: Video reference
     ├─ created_at: Timestamp
     └─ expires_at: Now + 1 hour
     ↓
Store in Database
     ↓
Each Video Request:
     ├─ Validate session_key
     ├─ Check expires_at
     ├─ Allow/Deny access
     └─ Delete if expired
```

### Database Schema

```
┌─────────────────────┐
│       Video         │
├─────────────────────┤
│ id (UUID, PK)       │
│ title               │
│ description         │
│ video_file          │
│ thumbnail           │
│ password_hash       │
│ uploaded_at         │
│ views               │
└──────────┬──────────┘
           │ 1:N
           ↓
┌─────────────────────┐
│ VideoAccessSession  │
├─────────────────────┤
│ id (PK)             │
│ session_key         │
│ video_id (FK)       │
│ created_at          │
│ expires_at          │
└─────────────────────┘
```

---

## Features & Configuration

### Current Features

✅ **Video Management**
- Upload videos with passwords
- Automatic thumbnail generation
- View count tracking
- Admin dashboard with statistics

✅ **Security**
- Password-protected videos
- Session-based access (1-hour expiry)
- PBKDF2-SHA256 password hashing
- CSRF protection

✅ **User Experience**
- Responsive design (mobile-friendly)
- Video.js player with controls
- Clean, modern interface
- Easy navigation

### Mobile Optimization

All pages are fully responsive:

**Breakpoints:**
- Desktop: > 768px
- Tablet: 480px - 768px
- Mobile: < 480px

**Mobile Features:**
- Touch-friendly buttons (min 44x44px)
- Single-column layouts on small screens
- Full-width CTAs on phones
- Optimized video player controls
- Horizontal scroll for tables

**Testing on Mobile:**
```powershell
# Start server for network access
python manage.py runserver 0.0.0.0:8000

# Find your IP
ipconfig  # Look for IPv4 Address

# Open on phone (same WiFi)
http://192.168.x.x:8000
```

### Logout Configuration

**Settings:**
```python
# In settings.py
LOGOUT_REDIRECT_URL = '/'  # Redirect to homepage after logout
```

**Custom Logout View:**
- Logs out user
- Shows success message
- Redirects to homepage

**Usage:**
```
/logout/  → Logout with message → Homepage
```

---

## Testing Guide

### Run All Tests

```powershell
python manage.py test videos
```

### Test Coverage

**Model Tests:**
- Video creation
- Password hashing
- Session management
- Expiry validation

**View Tests:**
- Homepage access
- Video list display
- Password verification
- Admin authentication
- Upload functionality

**Form Tests:**
- Video upload validation
- Password form validation

### Manual Testing Checklist

**Public Features:**
- [ ] Homepage loads
- [ ] Video list displays
- [ ] Password entry works
- [ ] Video playback works
- [ ] Invalid password rejected
- [ ] Session expires after 1 hour

**Admin Features:**
- [ ] Admin login works
- [ ] Dashboard displays stats
- [ ] Upload form accessible
- [ ] Video upload successful
- [ ] Video deletion works
- [ ] Logout redirects home

**Security:**
- [ ] Non-staff cannot access admin
- [ ] Expired sessions rejected
- [ ] Passwords properly hashed
- [ ] CSRF protection active

### Browser Testing

Test in multiple browsers:
- Chrome
- Firefox
- Edge
- Safari (Mac)
- Mobile browsers (iOS Safari, Chrome Android)

---

## Deployment Checklist

### Security Settings

```python
# settings.py - Production Configuration

# 1. Change SECRET_KEY
SECRET_KEY = os.environ.get('SECRET_KEY', 'your-new-secret-key')

# 2. Disable DEBUG
DEBUG = False

# 3. Configure ALLOWED_HOSTS
ALLOWED_HOSTS = ['yourdomain.com', 'www.yourdomain.com']

# 4. CSRF Protection
CSRF_TRUSTED_ORIGINS = [
    'https://yourdomain.com',
    'https://www.yourdomain.com'
]

# 5. Enable HTTPS
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# 6. Security Headers
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
```

### Database Configuration

```python
# Switch to PostgreSQL for production
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}
```

**Install PostgreSQL driver:**
```bash
pip install psycopg2-binary
```

### Static & Media Files

```python
# Static files
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATIC_URL = '/static/'

# Collect static files
python manage.py collectstatic
```

**Cloud Storage (AWS S3):**
```bash
pip install django-storages boto3
```

```python
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = os.environ.get('AWS_STORAGE_BUCKET_NAME')
```

### Environment Variables

Create `.env` file (DO NOT commit):
```
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
DB_NAME=your_db_name
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_HOST=your_db_host
DB_PORT=5432
```

### Production Requirements

```
# requirements.txt additions
gunicorn==21.2.0
psycopg2-binary==2.9.9
django-storages==1.14.2
boto3==1.29.7
python-decouple==3.8
```

### Deployment Architecture

**Production Stack:**
```
User → CDN (Static)
  ↓
Load Balancer
  ↓
App Servers (Gunicorn)
  ↓
PostgreSQL + Cloud Storage (S3)
```

---

## Troubleshooting

### Video Player Issues

#### Black Screen / Won't Play

**Check Browser Console (F12):**

- **404 Error**: Video file missing → Re-upload
- **403 Error**: Session expired → Re-enter password
- **Format Error**: Incompatible codec → Convert to MP4

**Supported Formats:**
- ✅ MP4 (H.264 + AAC) - Best compatibility
- ✅ WebM (VP8/VP9)
- ❌ AVI, MKV - May not work

**Convert Video:**
```bash
# Using FFmpeg
ffmpeg -i input.avi -c:v libx264 -c:a aac output.mp4

# Compress large video
ffmpeg -i input.mp4 -b:v 1M output.mp4
```

#### Session Expired

**Symptoms:**
- 403 Forbidden
- "Access denied" message
- Worked before, now doesn't

**Solution:**
- Re-enter password (sessions last 1 hour)
- Clear cookies
- Try incognito mode

#### Large File Issues

**Solutions:**
1. Compress video
2. Use lower resolution (720p instead of 1080p)
3. Increase upload limits in settings.py:
```python
DATA_UPLOAD_MAX_MEMORY_SIZE = 524288000  # 500 MB
```

### Debugging Commands

**Check uploaded videos:**
```powershell
python manage.py shell
```
```python
from videos.models import Video
for v in Video.objects.all():
    print(f"{v.title}: {v.video_file.path}")
```

**Test video file exists:**
```powershell
dir "media\videos"
```

**Check Video.js loaded:**
```javascript
// In browser console (F12)
typeof videojs  // Should return "function"
```

### Common Fixes

**Video Not Found:**
```powershell
# Verify file exists
dir media\videos\your-video.mp4

# Check database path matches file
python manage.py shell
```

**Format Not Supported:**
```bash
# Convert to web-friendly format
ffmpeg -i input.mp4 -c:v libx264 -c:a aac -strict experimental output.mp4
```

**Player Not Loading:**
- Check internet (Video.js from CDN)
- Try different CDN link
- Download Video.js locally

### Recommended Video Settings

- **Format**: MP4
- **Video Codec**: H.264
- **Audio Codec**: AAC
- **Resolution**: 720p or 1080p
- **Bitrate**: 1-5 Mbps
- **Frame Rate**: 24-30 fps
- **Size**: < 500 MB

---

## Additional Resources

### File Locations

**Configuration:**
- Main settings: `video_hosting/settings.py`
- URLs: `video_hosting/urls.py`, `videos/urls.py`
- Models: `videos/models.py`
- Views: `videos/views.py`

**Templates:**
- Base: `videos/templates/videos/base.html`
- Homepage: `videos/templates/videos/home.html`
- Player: `videos/templates/videos/view_video.html`

**Static Files:**
- CSS: `videos/static/videos/css/`
- JS: `videos/static/videos/js/`

### Support

**Browser Compatibility:**
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

**Python Version:**
- Python 3.8+

**Django Version:**
- Django 4.2+

---

**Last Updated**: October 2025  
**Version**: 1.0  
**License**: MIT