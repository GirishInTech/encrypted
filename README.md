# 🎬 Video Hosting Platform with Password Protection

A secure Django web application for hosting password-protected videos. Admin users can upload videos and set unique passwords for each video, while visitors need to enter the correct password to watch any video.

## 🌟 Features

### Admin Features
- **Secure Admin Login**: Only staff members can access admin functionality
- **Video Upload**: Upload videos with custom passwords
- **Video Management**: Delete videos from the platform
- **Dashboard**: View all videos with statistics (views, upload date)
- **Password Protection**: Set unique passwords for each video (stored as hashed values)

### Visitor Features
- **Browse Videos**: View all available videos without login
- **Password-Protected Access**: Enter password to watch specific videos
- **Secure Streaming**: Session-based authentication prevents URL bypassing
- **Video Statistics**: View count for each video

### Security Features
- ✅ **Hashed Passwords**: All video passwords are hashed using Django's password hashers
- ✅ **Session-Based Access Control**: Videos can only be accessed after password verification
- ✅ **Protected URLs**: Direct video URLs are protected and cannot be accessed without valid session
- ✅ **Automatic Session Expiry**: Access sessions expire after 1 hour
- ✅ **Admin-Only Actions**: Upload and delete operations require staff authentication

## 📁 Project Structure

```
video_hosting/
├── manage.py
├── requirements.txt
├── README.md
├── .gitignore
├── db.sqlite3 (created after migrations)
├── media/ (created automatically)
│   ├── videos/
│   └── thumbnails/
├── video_hosting/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
└── videos/
    ├── __init__.py
    ├── admin.py
    ├── apps.py
    ├── models.py
    ├── views.py
    ├── urls.py
    ├── forms.py
    ├── migrations/
    └── templates/
        └── videos/
            ├── base.html
            ├── home.html
            ├── watch.html
            ├── enter_password.html
            ├── view_video.html
            ├── admin_dashboard.html
            ├── upload_video.html
            └── delete_video.html
```

## 🚀 Setup Instructions (PowerShell - Windows 10)

### Step 1: Navigate to Project Directory
```powershell
cd "d:\Girish\encrypted hosting\video_hosting"
```

### Step 2: Create Virtual Environment
```powershell
python -m venv venv
```

### Step 3: Activate Virtual Environment
```powershell
.\venv\Scripts\Activate.ps1
```

**Note**: If you get an execution policy error, run this first:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Step 4: Install Dependencies
```powershell
pip install -r requirements.txt
```

### Step 5: Create Database and Run Migrations
```powershell
python manage.py makemigrations
python manage.py migrate
```

### Step 6: Create Superuser (Admin Account)
```powershell
python manage.py createsuperuser
```

You'll be prompted to enter:
- Username (e.g., `admin`)
- Email (optional, can press Enter to skip)
- Password (e.g., `admin123`)
- Password confirmation

### Step 7: Create Media Directories
```powershell
New-Item -ItemType Directory -Force -Path "media\videos"
New-Item -ItemType Directory -Force -Path "media\thumbnails"
```

### Step 8: Run Development Server
```powershell
python manage.py runserver
```

The application will be available at: **http://127.0.0.1:8000/**

## 📖 Usage Guide

### For Admin Users

#### 1. Login as Admin
- Navigate to: http://127.0.0.1:8000/admin/
- Enter your superuser credentials

#### 2. Upload a Video
**Option A - Via Admin Dashboard:**
- Go to http://127.0.0.1:8000/admin-dashboard/
- Click "Upload New Video"
- Fill in the form:
  - **Title**: Video name (required)
  - **Description**: Optional description
  - **Video File**: Select video file (MP4, WebM, AVI, MOV)
  - **Thumbnail**: Optional thumbnail image
  - **Password**: Set password for this video (required)
  - **Confirm Password**: Confirm the password
- Click "Upload Video"

**Option B - Via Navigation:**
- Click "Upload Video" in the navigation bar
- Follow the same steps as above

#### 3. Manage Videos
- Go to Admin Dashboard: http://127.0.0.1:8000/admin-dashboard/
- View all uploaded videos with statistics
- Click "View" to watch a video (you'll need to enter the password)
- Click "Delete" to remove a video permanently

#### 4. Delete a Video
- From Admin Dashboard, click "Delete" button next to any video
- Confirm deletion on the warning page
- Video file and all data will be permanently removed

### For Visitors (Public Users)

#### 1. Browse Videos
- Visit: http://127.0.0.1:8000/watch/
- See all available videos with titles, descriptions, and view counts

#### 2. Watch a Video
- Click "Enter Password to Watch" on any video card
- Enter the password set by admin
- If correct, you'll be redirected to the video player
- Video will play in the browser
- Your access is valid for 1 hour

#### 3. Direct URL Access
- Even if you copy the video URL and paste it in a new tab
- You'll still need to enter the password first
- This ensures security and prevents unauthorized sharing

## 🔐 Security Implementation Details

### Password Hashing
- Video passwords are hashed using Django's `make_password()` function
- Uses PBKDF2 algorithm with SHA256 hash
- Passwords are never stored in plaintext

### Session-Based Access Control
- When a user enters correct password, a `VideoAccessSession` is created
- Session links the user's session key with the video
- Session expires after 1 hour
- Video streaming endpoint checks for valid session before serving video

### URL Protection
- Direct access to `/video/<id>/stream/` is blocked without valid session
- Returns `403 Forbidden` if session is invalid or expired
- Prevents URL sharing and unauthorized access

### Admin-Only Views
- Upload and delete views use `@staff_member_required` decorator
- Automatically redirects non-staff users to login page
- Only users with `is_staff=True` can access these views

## 🧪 Testing the Application

### Test Scenario 1: Upload and Watch Video

1. **Login as Admin**
   ```
   URL: http://127.0.0.1:8000/admin/
   Username: admin
   Password: admin123
   ```

2. **Upload a Test Video**
   - Go to: http://127.0.0.1:8000/upload/
   - Title: "Sample Video"
   - Password: "test123"
   - Upload a video file from your computer
   - Submit the form

3. **Watch as Visitor**
   - Open an incognito/private browser window
   - Go to: http://127.0.0.1:8000/watch/
   - Click on "Sample Video"
   - Enter password: "test123"
   - Video should play successfully

### Test Scenario 2: Security Verification

1. **Try Direct URL Access**
   - After watching a video, copy the video stream URL
   - Open a new incognito window
   - Paste the URL directly
   - You should get "Access denied" message

2. **Try Admin Features as Visitor**
   - In incognito window, try to access: http://127.0.0.1:8000/upload/
   - You should be redirected to admin login

3. **Test Wrong Password**
   - Go to a video's password page
   - Enter incorrect password
   - Should show "Incorrect password" error

### Test Scenario 3: Delete Video

1. **Login as Admin**
2. **Go to Admin Dashboard**: http://127.0.0.1:8000/admin-dashboard/
3. **Click Delete** on any video
4. **Confirm deletion**
5. **Verify** video is removed from list and file is deleted

## 🛠️ Troubleshooting

### Issue: "No module named 'videos'"
**Solution**: Make sure you're in the correct directory and Django app is installed:
```powershell
python manage.py migrate
```

### Issue: "TemplateDoesNotExist"
**Solution**: Ensure templates are in the correct location:
```
videos/templates/videos/*.html
```

### Issue: "403 Forbidden" when accessing video
**Solution**: Enter the correct password first. Session may have expired (1-hour limit).

### Issue: Media files not showing
**Solution**: Ensure `DEBUG = True` in settings.py for local development.

### Issue: Can't activate virtual environment
**Solution**: Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📊 Database Models

### Video Model
- `id`: UUID (primary key)
- `title`: CharField (max 200 chars)
- `description`: TextField (optional)
- `video_file`: FileField (uploads to media/videos/)
- `thumbnail`: ImageField (optional, uploads to media/thumbnails/)
- `password_hash`: CharField (128 chars, stores hashed password)
- `uploaded_at`: DateTimeField (auto-generated)
- `views`: IntegerField (default 0)

### VideoAccessSession Model
- `session_key`: CharField (40 chars)
- `video`: ForeignKey to Video
- `created_at`: DateTimeField (auto-generated)
- `expires_at`: DateTimeField (1 hour from creation)

## 🔄 Future Enhancements

- ✨ Google Cloud Storage integration for video hosting
- ✨ Signed URLs for temporary video access
- ✨ Video transcoding for multiple resolutions
- ✨ User accounts with personal video libraries
- ✨ Video categories and tags
- ✨ Search and filter functionality
- ✨ Video analytics and detailed statistics
- ✨ Bulk video upload
- ✨ Password strength requirements
- ✨ Email notifications for video sharing

## 📝 Environment Variables (For Production)

When deploying to production, set these environment variables:

```
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=your-domain.com,www.your-domain.com
DATABASE_URL=your-database-url
```

## 🤝 Support

For issues or questions:
1. Check the Troubleshooting section
2. Review Django documentation: https://docs.djangoproject.com/
3. Check Python version: `python --version` (should be 3.11+)

## 📄 License

This project is for educational and personal use.

---

**Made with ❤️ using Django 4.2**
