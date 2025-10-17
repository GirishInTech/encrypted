# 🎥 Encrypted Video Hosting Platform

<div align="center">

![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**A secure, cloud-native video hosting platform with end-to-end encryption**

[Features](#-features) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Deployment](#-deployment) • [Documentation](#-documentation)

---

</div>

## ✨ Features

<table>
<tr>
<td width="50%">

### 🔒 Security First
- Password-protected video access
- Encrypted file storage
- CSRF protection
- Session management
- Service account authentication

</td>
<td width="50%">

### ☁️ Cloud-Native
- Google Cloud Run deployment
- Cloud SQL (PostgreSQL)
- Cloud Storage (GCS)
- Scalable architecture
- Production-ready infrastructure

</td>
</tr>
<tr>
<td width="50%">

### 🎬 Video Management
- Secure upload & storage
- Stream-ready playback
- Metadata management
- Access control
- Mobile-optimized player

</td>
<td width="50%">

### 🚀 DevOps Ready
- Docker containerization
- CI/CD compatible
- Health check endpoints
- Environment configuration
- Automated deployments

</td>
</tr>
</table>

---

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Technology Stack](#-technology-stack)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Local Development](#-local-development)
- [Docker Setup](#-docker-setup)
- [Google Cloud Configuration](#-google-cloud-configuration)
- [Database Setup](#-database-setup)
- [Storage Configuration](#-storage-configuration)
- [Cloud Run Deployment](#-cloud-run-deployment)
- [Testing & Troubleshooting](#-testing--troubleshooting)
- [Mobile Optimization](#-mobile-optimization)
- [Security Best Practices](#-security-best-practices)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [Author](#-author)

---

## 🏗 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         User Interface                       │
│                    (Django Templates + JS)                   │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     Application Layer                        │
│                   (Django + Gunicorn)                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Upload     │  │    Auth      │  │   Playback   │      │
│  │   Service    │  │   Service    │  │   Service    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└──────────────┬────────────────────────────┬─────────────────┘
               │                            │
               ▼                            ▼
┌──────────────────────────┐  ┌──────────────────────────┐
│     Cloud SQL            │  │   Cloud Storage (GCS)    │
│   (PostgreSQL)           │  │   (Video Files)          │
│                          │  │                          │
│  • Video Metadata        │  │  • Encrypted Videos      │
│  • User Data             │  │  • Thumbnails            │
│  • Access Controls       │  │  • Static Assets         │
└──────────────────────────┘  └──────────────────────────┘
```

### 🔄 Data Flow

1. **Upload Phase**
   - User uploads video through Django interface
   - Backend validates file type and size
   - Video encrypted and stored in GCS
   - Metadata saved to Cloud SQL

2. **Access Phase**
   - User requests video with password
   - Django validates credentials
   - Generates signed URL from GCS
   - Streams video to player

3. **Playback Phase**
   - Video player loads from GCS
   - Progress tracked in database
   - Mobile-optimized delivery

---

## 🛠 Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Backend** | Django 4.x | Web framework & API |
| **Server** | Gunicorn | WSGI HTTP Server |
| **Database** | PostgreSQL | Relational data storage |
| **Storage** | Google Cloud Storage | Video file storage |
| **Container** | Docker | Application containerization |
| **Cloud Platform** | Google Cloud Run | Serverless deployment |
| **Cloud Database** | Cloud SQL | Managed PostgreSQL |
| **Authentication** | Django Auth | User management |
| **Security** | CSRF Protection | Request validation |

---

## ⚡ Quick Start

### Prerequisites

- Python 3.9+
- Docker Desktop
- Google Cloud SDK
- PostgreSQL (local testing)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/GirishInTech/encrypted.git
cd encrypted

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows PowerShell:
venv\Scripts\Activate.ps1
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Start development server
python manage.py runserver
```

Visit `http://localhost:8000` to see your application running! 🎉

---

## 📁 Project Structure

```
encrypted/
│
├── 📂 video_hosting/              # Main Django project
│   ├── __init__.py
│   ├── settings.py               # Core configuration
│   ├── urls.py                   # URL routing
│   ├── wsgi.py                   # WSGI entry point
│   └── check_connections.py      # Health checks
│
├── 📂 media/                      # Local media (development)
├── 📂 staticfiles/                # Collected static files
│
├── 📄 Dockerfile                  # Container definition
├── 📄 docker-compose.yml          # Local Docker setup
├── 📄 requirements.txt            # Python dependencies
├── 📄 .env.example                # Environment template
├── 📄 .gitignore                  # Git exclusions
├── 📄 manage.py                   # Django CLI
├── 🔑 key.json                    # GCS service account (gitignored)
│
└── 📄 README.md                   # You are here!
```

---

## 💻 Local Development

### Environment Configuration

Create a `.env` file in the project root:

```env
# Django Settings
SECRET_KEY=<YOUR_SECRET_KEY>
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Configuration
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=video_hosting_db
DB_USER=postgres
DB_PASSWORD=<YOUR_DB_PASSWORD>

# Google Cloud Storage
BUCKET_NAME=<YOUR_BUCKET_NAME>
GOOGLE_APPLICATION_CREDENTIALS=key.json

# Security
CSRF_TRUSTED_ORIGINS=http://localhost:8000
```

### Start Cloud SQL Proxy (Optional)

```bash
cloud-sql-proxy <PROJECT_ID>:<REGION>:<INSTANCE_NAME> \
  --address 0.0.0.0 \
  --port 5432
```

### Run System Health Checks

```bash
python video_hosting/check_connections.py
```

Expected output:
```
🔍 Running system health checks...
✅ Database connection successful
✅ GCS bucket accessible
✅ All connections OK! You're good to go 🎉
```

---

## 🐳 Docker Setup

### Build Docker Image

```bash
docker build -t video-hosting-app:latest .
```

### Run Container Locally

```bash
docker run -p 8080:8080 \
  -v "${PWD}/key.json:/app/key.json" \
  --env-file .env \
  video-hosting-app:latest
```

### Docker Compose (Recommended)

```bash
docker-compose up --build
```

Access the application at `http://localhost:8080`

---

## ☁️ Google Cloud Configuration

### 1️⃣ Enable Required APIs

```bash
gcloud services enable \
  run.googleapis.com \
  sqladmin.googleapis.com \
  storage.googleapis.com \
  artifactregistry.googleapis.com
```

### 2️⃣ Create Artifact Registry

```bash
gcloud artifacts repositories create video-hosting-repo \
  --repository-format=docker \
  --location=<REGION> \
  --description="Container repository for video hosting application"
```

> 💡 **Tip:** Replace `<REGION>` with your preferred region (e.g., `us-central1`, `asia-south1`, `europe-west1`)

### 3️⃣ Configure Docker Authentication

```bash
gcloud auth configure-docker <REGION>-docker.pkg.dev
```

### 4️⃣ Build and Push Image

```bash
# Tag the image
docker tag video-hosting-app:latest \
  <REGION>-docker.pkg.dev/<PROJECT_ID>/video-hosting-repo/video-hosting-app:latest

# Push to Artifact Registry
docker push \
  <REGION>-docker.pkg.dev/<PROJECT_ID>/video-hosting-repo/video-hosting-app:latest
```

> 🔑 **Replace placeholders:**
> - `<REGION>` - Your GCP region
> - `<PROJECT_ID>` - Your GCP project ID

---

## 🗄️ Database Setup

### Cloud SQL Configuration

**Environment Variables:**

```env
DB_HOST=/cloudsql/<PROJECT_ID>:<REGION>:<INSTANCE_NAME>
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=<YOUR_DB_PASSWORD>
```

### Create Cloud SQL Instance (if needed)

```bash
gcloud sql instances create <INSTANCE_NAME> \
  --database-version=POSTGRES_14 \
  --tier=db-f1-micro \
  --region=<REGION>
```

### Run Migrations

```bash
# Connect via Cloud SQL Proxy
cloud-sql-proxy <PROJECT_ID>:<REGION>:<INSTANCE_NAME>

# In another terminal
python manage.py migrate
python manage.py createsuperuser
```

---

## 📦 Storage Configuration

### 1️⃣ Create GCS Bucket

```bash
gcloud storage buckets create gs://<YOUR_BUCKET_NAME> \
  --location=<REGION> \
  --uniform-bucket-level-access
```

### 2️⃣ Create Service Account

```bash
gcloud iam service-accounts create media-storage-sa \
  --display-name="Media Storage Service Account"
```

### 3️⃣ Assign Permissions

```bash
# Storage Admin
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:media-storage-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"

# Cloud SQL Client
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:media-storage-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/cloudsql.client"
```

### 4️⃣ Generate Service Account Key

```bash
gcloud iam service-accounts keys create key.json \
  --iam-account=media-storage-sa@<PROJECT_ID>.iam.gserviceaccount.com
```

> ⚠️ **Security Note:** Never commit `key.json` to version control! Add it to `.gitignore`

---

## 🚀 Cloud Run Deployment

### Deploy Service

```bash
gcloud run deploy video-hosting-service \
  --image=<REGION>-docker.pkg.dev/<PROJECT_ID>/video-hosting-repo/video-hosting-app:latest \
  --region=<REGION> \
  --platform=managed \
  --allow-unauthenticated \
  --add-cloudsql-instances=<PROJECT_ID>:<REGION>:<INSTANCE_NAME> \
  --service-account=media-storage-sa@<PROJECT_ID>.iam.gserviceaccount.com \
  --set-env-vars="DB_HOST=/cloudsql/<PROJECT_ID>:<REGION>:<INSTANCE_NAME>,DB_NAME=postgres,DB_USER=postgres,DB_PASSWORD=<YOUR_DB_PASSWORD>,BUCKET_NAME=<YOUR_BUCKET_NAME>,SECRET_KEY=<YOUR_SECRET_KEY>" \
  --memory=512Mi \
  --cpu=1 \
  --timeout=300 \
  --max-instances=10
```

### Update CSRF Settings

After deployment, update `settings.py`:

```python
CSRF_TRUSTED_ORIGINS = [
    'https://<your-service-name>.run.app'
]
```

Then redeploy:

```bash
docker build -t video-hosting-app:latest .
docker push <REGION>-docker.pkg.dev/<PROJECT_ID>/video-hosting-repo/video-hosting-app:latest
gcloud run deploy video-hosting-service --image=<REGION>-docker.pkg.dev/<PROJECT_ID>/video-hosting-repo/video-hosting-app:latest
```

---

## 🧪 Testing & Troubleshooting

### Health Check Endpoint

```bash
curl https://<your-service-name>.run.app/health/
```

Expected response:
```json
{
  "status": "healthy",
  "database": "connected",
  "storage": "accessible"
}
```

### Common Issues

<details>
<summary><b>🔴 CSRF Verification Failed</b></summary>

**Solution:** Add your Cloud Run URL to `CSRF_TRUSTED_ORIGINS` in `settings.py`:

```python
CSRF_TRUSTED_ORIGINS = [
    'https://<your-service-name>.run.app'
]
```
</details>

<details>
<summary><b>🔴 Database Connection Error</b></summary>

**Solution:** Verify Cloud SQL connection string format:

```env
DB_HOST=/cloudsql/<PROJECT_ID>:<REGION>:<INSTANCE_NAME>
```

Ensure Cloud SQL Admin API is enabled:
```bash
gcloud services enable sqladmin.googleapis.com
```
</details>

<details>
<summary><b>🔴 GCS Upload Failure</b></summary>

**Solution:** Check service account permissions:

```bash
gcloud storage buckets add-iam-policy-binding gs://<YOUR_BUCKET_NAME> \
  --member="serviceAccount:media-storage-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
```
</details>

<details>
<summary><b>🔴 Container Won't Start</b></summary>

**Solution:** Check Cloud Run logs:

```bash
gcloud run services logs read video-hosting-service \
  --region=<REGION> \
  --limit=50
```
</details>

---

## 📱 Mobile Optimization

### Features

- ✅ Fully responsive design
- ✅ Touch-optimized controls
- ✅ Adaptive video quality
- ✅ Lazy loading thumbnails
- ✅ Swipe gestures
- ✅ Mobile-first UI

### Testing

```bash
python manage.py test
```

---

## 🔒 Security Best Practices

### Implemented Security Features

- [x] Password-protected video access
- [x] CSRF token validation
- [x] Secure session management
- [x] Environment variable configuration
- [x] Service account authentication
- [x] HTTPS enforcement (Cloud Run)
- [x] SQL injection protection (Django ORM)

### Production Security Settings

Add to `settings.py` for production:

```python
# Security Settings
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
```

### Environment Variables Checklist

- [ ] `SECRET_KEY` - Strong random string
- [ ] `DB_PASSWORD` - Complex database password
- [ ] `BUCKET_NAME` - Private bucket name
- [ ] `key.json` - Never committed to Git
- [ ] All sensitive data in `.env` file

---

## 🗺️ Roadmap

### Phase 1: Core Features ✅
- [x] Video upload & storage
- [x] Password protection
- [x] Cloud deployment
- [x] Mobile optimization

### Phase 2: Enhanced Features 🚧
- [ ] Video transcoding pipeline (Cloud Functions)
- [ ] Multi-quality streaming (HLS)
- [ ] Analytics dashboard
- [ ] User management system

### Phase 3: Advanced Features 🔮
- [ ] JWT-based API
- [ ] CDN integration (Cloud CDN)
- [ ] Real-time notifications
- [ ] Advanced encryption (AES-256)
- [ ] CI/CD with GitHub Actions
- [ ] Automated testing suite
- [ ] Video thumbnails generation
- [ ] Subtitle support

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guide
- Write unit tests for new features
- Update documentation as needed
- Keep commits atomic and descriptive

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

<div align="center">

### **Girish InTech**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/GirishInTech)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:girish.techin@gmail.com)

*Building secure, scalable cloud solutions* ☁️

</div>

---

## 🙏 Acknowledgments

- Django Community
- Google Cloud Platform
- All contributors and supporters

---

<div align="center">

**⭐ Star this repo if you find it helpful!**

Made with ❤️ by [Girish InTech](https://github.com/GirishInTech)

![Views](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FGirishInTech%2Fencrypted&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Views&edge_flat=false)

</div>