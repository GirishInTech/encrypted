# Django Video Hosting Platform - Setup Script for Windows PowerShell
# Run this script to automatically set up the entire project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Django Video Hosting Platform - Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Python version
Write-Host "Step 1: Checking Python version..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
Write-Host "Found: $pythonVersion" -ForegroundColor Green
Write-Host ""

# Step 2: Create virtual environment
Write-Host "Step 2: Creating virtual environment..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "Virtual environment already exists. Skipping..." -ForegroundColor Green
} else {
    python -m venv venv
    Write-Host "Virtual environment created successfully!" -ForegroundColor Green
}
Write-Host ""

# Step 3: Activate virtual environment
Write-Host "Step 3: Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1
Write-Host "Virtual environment activated!" -ForegroundColor Green
Write-Host ""

# Step 4: Upgrade pip
Write-Host "Step 4: Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip
Write-Host "Pip upgraded successfully!" -ForegroundColor Green
Write-Host ""

# Step 5: Install dependencies
Write-Host "Step 5: Installing dependencies from requirements.txt..." -ForegroundColor Yellow
pip install -r requirements.txt
Write-Host "Dependencies installed successfully!" -ForegroundColor Green
Write-Host ""

# Step 6: Create migrations
Write-Host "Step 6: Creating database migrations..." -ForegroundColor Yellow
python manage.py makemigrations
Write-Host "Migrations created successfully!" -ForegroundColor Green
Write-Host ""

# Step 7: Apply migrations
Write-Host "Step 7: Applying migrations to database..." -ForegroundColor Yellow
python manage.py migrate
Write-Host "Database migrations applied successfully!" -ForegroundColor Green
Write-Host ""

# Step 8: Create media directories
Write-Host "Step 8: Creating media directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "media\videos" | Out-Null
New-Item -ItemType Directory -Force -Path "media\thumbnails" | Out-Null
Write-Host "Media directories created successfully!" -ForegroundColor Green
Write-Host ""

# Step 9: Create superuser
Write-Host "Step 9: Creating superuser account..." -ForegroundColor Yellow
Write-Host "Please enter your admin credentials:" -ForegroundColor Cyan
python manage.py createsuperuser
Write-Host ""

# Step 10: Done
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start the development server, run:" -ForegroundColor Yellow
Write-Host "    python manage.py runserver" -ForegroundColor White
Write-Host ""
Write-Host "Then open your browser and go to:" -ForegroundColor Yellow
Write-Host "    http://127.0.0.1:8000/" -ForegroundColor White
Write-Host ""
Write-Host "Admin Panel:" -ForegroundColor Yellow
Write-Host "    http://127.0.0.1:8000/admin/" -ForegroundColor White
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Cyan
