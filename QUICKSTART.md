# 🚀 Quick Start Guide

Get your video hosting platform running in 5 minutes!

## Copy-Paste Commands (PowerShell)

### Option 1: Automated Setup (Recommended)

```powershell
# Navigate to project directory
cd "d:\Girish\encrypted hosting\video_hosting"

# Run automated setup script
.\SETUP.ps1

# Start the server
python manage.py runserver
```

### Option 2: Manual Setup

```powershell
# 1. Navigate to project directory
cd "d:\Girish\encrypted hosting\video_hosting"

# 2. Create virtual environment
python -m venv venv

# 3. Activate virtual environment
.\venv\Scripts\Activate.ps1

# 4. Install packages
pip install -r requirements.txt

# 5. Run migrations
python manage.py makemigrations
python manage.py migrate

# 6. Create media directories
New-Item -ItemType Directory -Force -Path "media\videos"
New-Item -ItemType Directory -Force -Path "media\thumbnails"

# 7. Create superuser
python manage.py createsuperuser

# 8. Start server
python manage.py runserver
```

## 🎯 Quick Access URLs

After starting the server:

- **Homepage**: http://127.0.0.1:8000/
- **Watch Videos**: http://127.0.0.1:8000/watch/
- **Admin Login**: http://127.0.0.1:8000/admin/
- **Admin Dashboard**: http://127.0.0.1:8000/admin-dashboard/
- **Upload Video**: http://127.0.0.1:8000/upload/

## 🔑 First Time Setup

### Create Admin Account

When prompted by `createsuperuser`:
```
Username: admin
Email address: (press Enter to skip)
Password: admin123
Password (again): admin123
```

## 📹 Upload Your First Video

1. Login: http://127.0.0.1:8000/admin/
   - Username: `admin`
   - Password: `admin123`

2. Go to: http://127.0.0.1:8000/upload/

3. Fill the form:
   - **Title**: My First Video
   - **Description**: This is a test video
   - **Video File**: Select your video
   - **Password**: test123
   - **Confirm Password**: test123

4. Click "Upload Video"

## 👀 Watch as Visitor

1. Open incognito window

2. Go to: http://127.0.0.1:8000/watch/

3. Click on "My First Video"

4. Enter password: `test123`

5. Enjoy the video!

## ⚠️ Troubleshooting

### Error: "execution policy"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "Port already in use"
```powershell
# Use a different port
python manage.py runserver 8001
```

### Error: "Module not found"
```powershell
# Ensure virtual environment is activated
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## 🧪 Run Tests

```powershell
python manage.py test videos
```

## 🛑 Stop Server

Press `Ctrl + C` in the PowerShell window

## 📚 Need More Help?

Read the full documentation in `README.md`
