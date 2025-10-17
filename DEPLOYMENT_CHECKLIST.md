# 🚀 Production Deployment Checklist

Before deploying this application to production, complete all items in this checklist.

## ✅ Pre-Deployment Checklist

### 1. Security Settings

- [ ] **Change SECRET_KEY**
  ```python
  # In settings.py
  SECRET_KEY = os.environ.get('SECRET_KEY', 'your-new-secret-key')
  ```

- [ ] **Set DEBUG = False**
  ```python
  # In settings.py
  DEBUG = False
  ```

- [ ] **Configure ALLOWED_HOSTS**
  ```python
  # In settings.py
  ALLOWED_HOSTS = ['yourdomain.com', 'www.yourdomain.com', 'your-ip-address']
  ```

- [ ] **Configure CSRF_TRUSTED_ORIGINS** (Django 4.0+)
  ```python
  # In settings.py
  CSRF_TRUSTED_ORIGINS = [
      'https://yourdomain.com',
      'https://www.yourdomain.com'
  ]
  ```

- [ ] **Enable HTTPS**
  ```python
  # In settings.py
  SECURE_SSL_REDIRECT = True
  SESSION_COOKIE_SECURE = True
  CSRF_COOKIE_SECURE = True
  ```

- [ ] **Set Security Headers**
  ```python
  # In settings.py
  SECURE_BROWSER_XSS_FILTER = True
  SECURE_CONTENT_TYPE_NOSNIFF = True
  X_FRAME_OPTIONS = 'DENY'
  SECURE_HSTS_SECONDS = 31536000
  SECURE_HSTS_INCLUDE_SUBDOMAINS = True
  SECURE_HSTS_PRELOAD = True
  ```

### 2. Database Configuration

- [ ] **Switch to Production Database**
  ```python
  # In settings.py
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

- [ ] **Install PostgreSQL Driver**
  ```bash
  pip install psycopg2-binary
  ```

- [ ] **Run Migrations on Production DB**
  ```bash
  python manage.py migrate
  ```

- [ ] **Create Database Backups**
  - Set up automated backup schedule
  - Test restore procedure

### 3. Static Files

- [ ] **Configure Static Files**
  ```python
  # In settings.py
  STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
  STATIC_URL = '/static/'
  ```

- [ ] **Collect Static Files**
  ```bash
  python manage.py collectstatic
  ```

- [ ] **Configure Web Server to Serve Static Files**
  - Nginx or Apache configuration

### 4. Media Files

- [ ] **Configure Cloud Storage** (Recommended)
  ```bash
  pip install django-storages boto3  # For AWS S3
  ```

  ```python
  # In settings.py
  DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
  AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
  AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
  AWS_STORAGE_BUCKET_NAME = os.environ.get('AWS_STORAGE_BUCKET_NAME')
  AWS_S3_REGION_NAME = os.environ.get('AWS_S3_REGION_NAME')
  AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'
  ```

- [ ] **Or Configure Local Media Serving** (Not recommended for production)
  - Ensure proper permissions
  - Set up web server to serve media files

### 5. Environment Variables

- [ ] **Create .env File** (DO NOT commit to git)
  ```
  SECRET_KEY=your-secret-key-here
  DEBUG=False
  ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
  DB_NAME=your_db_name
  DB_USER=your_db_user
  DB_PASSWORD=your_db_password
  DB_HOST=your_db_host
  DB_PORT=5432
  AWS_ACCESS_KEY_ID=your_aws_key
  AWS_SECRET_ACCESS_KEY=your_aws_secret
  AWS_STORAGE_BUCKET_NAME=your_bucket
  ```

- [ ] **Install python-decouple or django-environ**
  ```bash
  pip install python-decouple
  ```

  ```python
  # In settings.py
  from decouple import config
  SECRET_KEY = config('SECRET_KEY')
  DEBUG = config('DEBUG', default=False, cast=bool)
  ```

### 6. Requirements

- [ ] **Update requirements.txt**
  ```bash
  pip freeze > requirements.txt
  ```

- [ ] **Add Production Dependencies**
  ```
  gunicorn==21.2.0
  psycopg2-binary==2.9.9
  django-storages==1.14.2
  boto3==1.29.7
  python-decouple==3.8
  ```

### 7. Logging

- [ ] **Configure Logging**
  ```python
  # In settings.py
  LOGGING = {
      'version': 1,
      'disable_existing_loggers': False,
      'formatters': {
          'verbose': {
              'format': '{levelname} {asctime} {module} {message}',
              'style': '{',
          },
      },
      'handlers': {
          'file': {
              'level': 'ERROR',
              'class': 'logging.FileHandler',
              'filename': '/var/log/django/error.log',
              'formatter': 'verbose',
          },
          'console': {
              'level': 'INFO',
              'class': 'logging.StreamHandler',
              'formatter': 'verbose',
          },
      },
      'root': {
          'handlers': ['console', 'file'],
          'level': 'INFO',
      },
  }
  ```

- [ ] **Create Log Directory**
  ```bash
  mkdir -p /var/log/django
  ```

### 8. Error Pages

- [ ] **Create Custom Error Templates**
  - Create `templates/404.html`
  - Create `templates/500.html`
  - Create `templates/403.html`

### 9. Email Configuration

- [ ] **Configure Email Backend**
  ```python
  # In settings.py
  EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
  EMAIL_HOST = os.environ.get('EMAIL_HOST')
  EMAIL_PORT = os.environ.get('EMAIL_PORT', 587)
  EMAIL_USE_TLS = True
  EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
  EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')
  DEFAULT_FROM_EMAIL = os.environ.get('DEFAULT_FROM_EMAIL')
  ```

- [ ] **Set ADMINS for Error Notifications**
  ```python
  # In settings.py
  ADMINS = [('Admin Name', 'admin@yourdomain.com')]
  ```

### 10. Testing

- [ ] **Run All Tests**
  ```bash
  python manage.py test
  ```

- [ ] **Test with DEBUG=False Locally**
  ```bash
  python manage.py runserver --insecure
  ```

- [ ] **Verify All Functionality**
  - Video upload
  - Video access with password
  - Session expiration
  - Admin access
  - Video deletion

## 🌐 Deployment Options

### Option 1: VPS (DigitalOcean, Linode, AWS EC2)

#### Setup Steps

1. **Provision Server**
   - Ubuntu 22.04 LTS recommended
   - At least 2GB RAM

2. **Install Dependencies**
   ```bash
   sudo apt update
   sudo apt install python3.11 python3.11-venv python3-pip nginx postgresql
   ```

3. **Set Up PostgreSQL**
   ```bash
   sudo -u postgres psql
   CREATE DATABASE video_hosting;
   CREATE USER video_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE video_hosting TO video_user;
   \q
   ```

4. **Clone/Upload Project**
   ```bash
   cd /var/www
   git clone your-repo-url video_hosting
   cd video_hosting
   ```

5. **Create Virtual Environment**
   ```bash
   python3.11 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

6. **Configure Environment Variables**
   ```bash
   nano .env
   # Add all environment variables
   ```

7. **Run Migrations**
   ```bash
   python manage.py migrate
   python manage.py collectstatic
   python manage.py createsuperuser
   ```

8. **Configure Gunicorn**
   ```bash
   gunicorn --bind 0.0.0.0:8000 video_hosting.wsgi
   ```

9. **Create Systemd Service**
   ```bash
   sudo nano /etc/systemd/system/video_hosting.service
   ```

   ```ini
   [Unit]
   Description=Video Hosting Django App
   After=network.target

   [Service]
   User=www-data
   Group=www-data
   WorkingDirectory=/var/www/video_hosting
   Environment="PATH=/var/www/video_hosting/venv/bin"
   ExecStart=/var/www/video_hosting/venv/bin/gunicorn --workers 3 --bind unix:/var/www/video_hosting/video_hosting.sock video_hosting.wsgi:application

   [Install]
   WantedBy=multi-user.target
   ```

   ```bash
   sudo systemctl start video_hosting
   sudo systemctl enable video_hosting
   ```

10. **Configure Nginx**
    ```bash
    sudo nano /etc/nginx/sites-available/video_hosting
    ```

    ```nginx
    server {
        listen 80;
        server_name yourdomain.com www.yourdomain.com;

        location = /favicon.ico { access_log off; log_not_found off; }
        
        location /static/ {
            root /var/www/video_hosting;
        }

        location /media/ {
            root /var/www/video_hosting;
        }

        location / {
            include proxy_params;
            proxy_pass http://unix:/var/www/video_hosting/video_hosting.sock;
        }
    }
    ```

    ```bash
    sudo ln -s /etc/nginx/sites-available/video_hosting /etc/nginx/sites-enabled
    sudo nginx -t
    sudo systemctl restart nginx
    ```

11. **Configure SSL with Let's Encrypt**
    ```bash
    sudo apt install certbot python3-certbot-nginx
    sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
    ```

### Option 2: Platform as a Service (Heroku, Railway, Render)

#### Heroku Deployment

1. **Install Heroku CLI**

2. **Create Procfile**
   ```
   web: gunicorn video_hosting.wsgi
   release: python manage.py migrate
   ```

3. **Create runtime.txt**
   ```
   python-3.11.7
   ```

4. **Configure Settings for Heroku**
   ```python
   # Add to settings.py
   import dj_database_url
   
   DATABASES['default'] = dj_database_url.config(
       default=os.environ.get('DATABASE_URL')
   )
   ```

5. **Deploy**
   ```bash
   heroku create your-app-name
   heroku addons:create heroku-postgresql:mini
   git push heroku main
   heroku run python manage.py createsuperuser
   ```

### Option 3: Containerization (Docker)

1. **Create Dockerfile**
   ```dockerfile
   FROM python:3.11-slim
   
   WORKDIR /app
   
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   
   COPY . .
   
   RUN python manage.py collectstatic --noinput
   
   EXPOSE 8000
   
   CMD ["gunicorn", "--bind", "0.0.0.0:8000", "video_hosting.wsgi"]
   ```

2. **Create docker-compose.yml**
   ```yaml
   version: '3.8'
   
   services:
     db:
       image: postgres:15
       environment:
         POSTGRES_DB: video_hosting
         POSTGRES_USER: video_user
         POSTGRES_PASSWORD: your_password
       volumes:
         - postgres_data:/var/lib/postgresql/data
   
     web:
       build: .
       command: gunicorn video_hosting.wsgi:application --bind 0.0.0.0:8000
       volumes:
         - ./media:/app/media
       ports:
         - "8000:8000"
       depends_on:
         - db
       environment:
         - SECRET_KEY=your_secret_key
         - DEBUG=False
         - DB_NAME=video_hosting
         - DB_USER=video_user
         - DB_PASSWORD=your_password
         - DB_HOST=db
   
   volumes:
     postgres_data:
   ```

3. **Deploy**
   ```bash
   docker-compose up -d
   docker-compose exec web python manage.py migrate
   docker-compose exec web python manage.py createsuperuser
   ```

## 📊 Post-Deployment Checklist

- [ ] **Verify All Pages Load**
  - Homepage
  - Video listing
  - Admin pages
  - Password entry

- [ ] **Test Core Functionality**
  - Admin login
  - Video upload
  - Password protection
  - Video streaming
  - Video deletion

- [ ] **Check Security**
  - HTTPS enabled
  - Password hashing working
  - Session management
  - Admin-only access enforced

- [ ] **Monitor Performance**
  - Page load times
  - Video streaming speed
  - Database queries

- [ ] **Set Up Monitoring**
  - Error tracking (Sentry)
  - Uptime monitoring (Pingdom, UptimeRobot)
  - Performance monitoring (New Relic, DataDog)

- [ ] **Configure Backups**
  - Database backups
  - Media file backups
  - Backup schedule
  - Test restore process

- [ ] **Document**
  - Server credentials
  - Deployment process
  - Recovery procedures
  - Contact information

## 🔍 Monitoring & Maintenance

### Regular Tasks

**Daily:**
- Check error logs
- Monitor disk space
- Verify backups completed

**Weekly:**
- Review access logs
- Check for security updates
- Test backup restore

**Monthly:**
- Update dependencies
- Review performance metrics
- Clean up expired sessions

### Useful Commands

**Check Logs:**
```bash
# Application logs
tail -f /var/log/django/error.log

# Nginx logs
tail -f /var/nginx/error.log

# System logs
journalctl -u video_hosting -f
```

**Database Backup:**
```bash
pg_dump -U video_user video_hosting > backup_$(date +%Y%m%d).sql
```

**Restart Services:**
```bash
sudo systemctl restart video_hosting
sudo systemctl restart nginx
```

## 🆘 Troubleshooting

**Issue: 502 Bad Gateway**
- Check if Gunicorn is running: `sudo systemctl status video_hosting`
- Check socket file exists
- Check Nginx error logs

**Issue: Static Files Not Loading**
- Verify `collectstatic` was run
- Check Nginx configuration
- Verify file permissions

**Issue: Database Connection Error**
- Check database credentials
- Verify database is running
- Check firewall rules

**Issue: Media Files Not Accessible**
- Check media file permissions
- Verify storage configuration
- Check cloud storage credentials

## 📝 Final Notes

- Always test in a staging environment first
- Keep backups before making changes
- Document any custom configurations
- Monitor application after deployment
- Have a rollback plan ready

---

**Good luck with your deployment! 🚀**
