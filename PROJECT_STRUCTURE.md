# 📁 Project Structure

## Complete Directory Tree

```
video_hosting/
│
├── 📄 manage.py                          # Django management script
├── 📄 requirements.txt                   # Python dependencies
├── 📄 README.md                          # Full documentation
├── 📄 QUICKSTART.md                      # Quick start guide
├── 📄 SETUP.ps1                          # Automated setup script
├── 📄 PROJECT_STRUCTURE.md              # This file
├── 📄 .gitignore                         # Git ignore rules
├── 🗄️ db.sqlite3                         # SQLite database (created after setup)
│
├── 📁 venv/                              # Virtual environment (created during setup)
│
├── 📁 media/                             # User uploaded files
│   ├── 📁 videos/                        # Video files
│   └── 📁 thumbnails/                    # Thumbnail images
│
├── 📁 video_hosting/                     # Main project directory
│   ├── 📄 __init__.py                    # Python package marker
│   ├── 📄 settings.py                    # Django settings
│   ├── 📄 urls.py                        # Main URL configuration
│   ├── 📄 wsgi.py                        # WSGI config for deployment
│   └── 📄 asgi.py                        # ASGI config for async
│
└── 📁 videos/                            # Main application
    ├── 📄 __init__.py                    # Python package marker
    ├── 📄 admin.py                       # Django admin configuration
    ├── 📄 apps.py                        # App configuration
    ├── 📄 models.py                      # Database models
    ├── 📄 views.py                       # View functions
    ├── 📄 urls.py                        # App URL patterns
    ├── 📄 forms.py                       # Django forms
    ├── 📄 tests.py                       # Unit tests
    │
    ├── 📁 migrations/                    # Database migrations
    │   └── 📄 __init__.py
    │
    └── 📁 templates/                     # HTML templates
        └── 📁 videos/
            ├── 📄 base.html              # Base template
            ├── 📄 home.html              # Homepage
            ├── 📄 watch.html             # Video listing
            ├── 📄 enter_password.html    # Password entry
            ├── 📄 view_video.html        # Video player
            ├── 📄 admin_dashboard.html   # Admin dashboard
            ├── 📄 upload_video.html      # Video upload form
            └── 📄 delete_video.html      # Delete confirmation
```

## 📋 File Descriptions

### Root Level Files

| File | Purpose |
|------|---------|
| `manage.py` | Django's command-line utility for administrative tasks |
| `requirements.txt` | Lists all Python package dependencies |
| `README.md` | Complete project documentation and setup guide |
| `QUICKSTART.md` | Quick setup guide with copy-paste commands |
| `SETUP.ps1` | PowerShell script for automated setup |
| `.gitignore` | Specifies files to ignore in version control |
| `db.sqlite3` | SQLite database file (created after migrations) |

### video_hosting/ (Project Configuration)

| File | Purpose |
|------|---------|
| `settings.py` | Django project settings (database, apps, middleware, etc.) |
| `urls.py` | Main URL routing configuration |
| `wsgi.py` | WSGI configuration for production deployment |
| `asgi.py` | ASGI configuration for async capabilities |

### videos/ (Main Application)

| File | Purpose |
|------|---------|
| `models.py` | Database models (Video, VideoAccessSession) |
| `views.py` | View functions for handling requests |
| `urls.py` | URL patterns for the videos app |
| `forms.py` | Django forms (VideoUploadForm, VideoPasswordForm) |
| `admin.py` | Django admin interface configuration |
| `tests.py` | Unit tests for the application |

### Templates

| Template | Purpose |
|----------|---------|
| `base.html` | Base template with common layout and styling |
| `home.html` | Homepage with welcome message and features |
| `watch.html` | Video listing page showing all available videos |
| `enter_password.html` | Password entry form for video access |
| `view_video.html` | Video player page with HTML5 video player |
| `admin_dashboard.html` | Admin dashboard with video management |
| `upload_video.html` | Video upload form for admins |
| `delete_video.html` | Delete confirmation page |

## 🗂️ Key Directories

### media/
Contains all user-uploaded files:
- `videos/`: Stores uploaded video files
- `thumbnails/`: Stores optional thumbnail images

**Note**: This directory is created automatically when files are uploaded.

### venv/
Python virtual environment containing all installed packages. Created during setup.

### migrations/
Contains database migration files that track changes to models over time.

## 🔗 URL Structure

```
/                           → Home page
/watch/                     → Video listing page
/video/<id>/password/       → Password entry for specific video
/video/<id>/view/           → Video player page (requires session)
/video/<id>/stream/         → Video file stream endpoint (protected)
/admin-dashboard/           → Admin dashboard (staff only)
/upload/                    → Video upload page (staff only)
/video/<id>/delete/         → Delete video page (staff only)
/admin/                     → Django admin interface
```

## 📊 Database Structure

### Video Table
- `id` (UUID): Primary key
- `title` (VARCHAR): Video title
- `description` (TEXT): Optional description
- `video_file` (VARCHAR): Path to video file
- `thumbnail` (VARCHAR): Path to thumbnail
- `password_hash` (VARCHAR): Hashed password
- `uploaded_at` (DATETIME): Upload timestamp
- `views` (INTEGER): View count

### VideoAccessSession Table
- `id` (INTEGER): Primary key
- `session_key` (VARCHAR): Session identifier
- `video_id` (UUID): Foreign key to Video
- `created_at` (DATETIME): Creation timestamp
- `expires_at` (DATETIME): Expiration timestamp

## 🔐 Security Features

### Password Protection
- Passwords hashed using Django's `make_password()`
- PBKDF2 algorithm with SHA256
- Stored in `password_hash` field

### Session-Based Access
- `VideoAccessSession` model tracks authorized access
- Session expires after 1 hour
- Prevents URL bypassing

### Admin-Only Views
- `@staff_member_required` decorator
- Only users with `is_staff=True` can access
- Automatic redirect to login for unauthorized users

## 🎨 Frontend Design

### Technology Stack
- **HTML5**: Semantic markup
- **CSS3**: Modern styling with gradients and animations
- **Django Templates**: Server-side rendering
- **No JavaScript**: Pure HTML/CSS implementation

### Design Features
- Responsive layout
- Gradient backgrounds
- Card-based UI
- Modern color scheme (purple/blue)
- Smooth animations and transitions
- Clean typography

## 🔧 Configuration

### Django Settings (settings.py)
- `DEBUG = True`: Development mode
- `ALLOWED_HOSTS`: Localhost only
- `DATABASES`: SQLite configuration
- `MEDIA_ROOT`: Media files location
- `STATIC_ROOT`: Static files location

### Installed Apps
1. Django built-in apps (admin, auth, sessions, etc.)
2. `videos`: Our custom app

### Middleware
- Security middleware
- Session middleware
- CSRF protection
- Authentication middleware

## 📦 Dependencies

### requirements.txt
```
Django==4.2.8      # Web framework
Pillow==10.1.0     # Image processing (for thumbnails)
```

## 🚀 Deployment Considerations

### For Production
1. Set `DEBUG = False`
2. Configure `ALLOWED_HOSTS`
3. Use production database (PostgreSQL)
4. Set up static file serving
5. Configure cloud storage for media files
6. Use environment variables for secrets
7. Enable HTTPS
8. Set up proper logging

## 📝 Notes

- SQLite is suitable for development only
- For production, migrate to PostgreSQL or MySQL
- Media files should be served from cloud storage (S3, GCS) in production
- Consider using a CDN for video streaming at scale
