# 🏗️ System Architecture

## System Flow Diagrams

### 1. Overall System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      User's Browser                          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    Django Application                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              URL Router (urls.py)                     │  │
│  └────────────────────┬─────────────────────────────────┘  │
│                       │                                      │
│         ┌─────────────┴─────────────┐                       │
│         ▼                           ▼                       │
│  ┌─────────────┐           ┌──────────────┐               │
│  │   Public    │           │    Admin     │               │
│  │   Views     │           │    Views     │               │
│  └──────┬──────┘           └──────┬───────┘               │
│         │                          │                        │
│         └──────────┬───────────────┘                        │
│                    ▼                                         │
│         ┌─────────────────────┐                            │
│         │   Models Layer      │                            │
│         │  - Video            │                            │
│         │  - AccessSession    │                            │
│         └──────────┬──────────┘                            │
└────────────────────┼───────────────────────────────────────┘
                     │
        ┌────────────┴───────────┐
        ▼                        ▼
┌──────────────┐        ┌──────────────┐
│   SQLite     │        │    Media     │
│   Database   │        │   Storage    │
└──────────────┘        └──────────────┘
```

### 2. Visitor Workflow (Watch Video)

```
┌─────────┐
│  Start  │
└────┬────┘
     │
     ▼
┌──────────────────┐
│   Visit Home     │
│  (home.html)     │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│ Click "Watch"    │
│  Videos          │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│  Video List      │
│  (watch.html)    │
│  - See all       │
│    videos        │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│  Click Video     │
│  "Enter Pass"    │
└────┬─────────────┘
     │
     ▼
┌──────────────────────┐
│  Password Entry      │
│ (enter_password.html)│
└────┬─────────────────┘
     │
     ▼
┌──────────────────┐      ┌────────────────┐
│  Submit Password │──NO──│  Show Error    │
│                  │      │  Try Again     │
└────┬─────────────┘      └────────────────┘
     │ YES
     ▼
┌──────────────────┐
│  Create Session  │
│  - Store in DB   │
│  - Expires 1hr   │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│  Video Player    │
│ (view_video.html)│
│  - Stream video  │
│  - Increment     │
│    views         │
└────┬─────────────┘
     │
     ▼
┌─────────┐
│   End   │
└─────────┘
```

### 3. Admin Workflow (Upload Video)

```
┌─────────┐
│  Start  │
└────┬────┘
     │
     ▼
┌──────────────────┐
│  Admin Login     │
│  (/admin/)       │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐      ┌────────────────┐
│  Authentication  │──NO──│  Access Denied │
│  Check           │      │  Redirect      │
└────┬─────────────┘      └────────────────┘
     │ YES
     ▼
┌──────────────────┐
│  Admin Dashboard │
│  - View videos   │
│  - Statistics    │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│  Click "Upload"  │
│  Button          │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│  Upload Form     │
│  - Title         │
│  - Video file    │
│  - Password      │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐      ┌────────────────┐
│  Submit Form     │──NO──│  Show Errors   │
│  Validation      │      │                │
└────┬─────────────┘      └────────────────┘
     │ YES
     ▼
┌──────────────────┐
│  Save Video      │
│  - Hash password │
│  - Store file    │
│  - Create record │
└────┬─────────────┘
     │
     ▼
┌──────────────────┐
│  Success Message │
│  Redirect to     │
│  Dashboard       │
└────┬─────────────┘
     │
     ▼
┌─────────┐
│   End   │
└─────────┘
```

### 4. Security Flow (Video Access)

```
┌─────────────────┐
│  User Requests  │
│  Video Stream   │
└────┬────────────┘
     │
     ▼
┌─────────────────────────┐
│  Check Session Exists?  │
└────┬───────────┬────────┘
     │           │
    YES         NO
     │           │
     ▼           ▼
┌─────────┐  ┌──────────────┐
│ Valid?  │  │   Redirect   │
└─┬────┬──┘  │   to Enter   │
  │    │     │   Password   │
 YES  NO     └──────────────┘
  │    │
  │    ▼
  │  ┌──────────────┐
  │  │   Delete     │
  │  │   Session    │
  │  │   Redirect   │
  │  └──────────────┘
  │
  ▼
┌──────────────┐
│  Stream      │
│  Video File  │
└──────────────┘
```

### 5. Data Flow Diagram

```
┌─────────────┐
│    Admin    │
└──────┬──────┘
       │
       │ Upload Video + Password
       │
       ▼
┌─────────────────────────────┐
│  Django Backend             │
│  1. Hash Password           │
│  2. Save Video File         │
│  3. Create DB Record        │
└──────┬──────────────────────┘
       │
       ▼
┌─────────────────────────────┐
│  Storage                    │
│  - Database: metadata       │
│  - Filesystem: video file   │
└──────┬──────────────────────┘
       │
       │ Video Available
       │
       ▼
┌─────────────┐
│   Visitor   │
└──────┬──────┘
       │
       │ Request Video
       │
       ▼
┌─────────────────────────────┐
│  Password Verification      │
│  1. User enters password    │
│  2. Check against hash      │
│  3. Create session if valid │
└──────┬──────────────────────┘
       │
       ▼
┌─────────────────────────────┐
│  Session Management         │
│  - Store session key        │
│  - Set expiry time          │
│  - Link to video            │
└──────┬──────────────────────┘
       │
       ▼
┌─────────────────────────────┐
│  Video Streaming            │
│  1. Verify session          │
│  2. Stream video file       │
│  3. Increment view count    │
└─────────────────────────────┘
```

## Component Interactions

### URL Routing Flow

```
Browser Request
    ↓
Django URLconf (video_hosting/urls.py)
    ↓
App URLconf (videos/urls.py)
    ↓
View Function (videos/views.py)
    ↓
    ├─→ Models (videos/models.py)
    │   ├─→ Database Query
    │   └─→ Data Manipulation
    │
    ├─→ Forms (videos/forms.py)
    │   ├─→ Validation
    │   └─→ Data Processing
    │
    └─→ Template (videos/templates/)
        └─→ Rendered HTML
            ↓
        Browser Response
```

### Password Security Flow

```
User Input: "mypassword123"
    ↓
Form Validation
    ↓
video.set_password("mypassword123")
    ↓
Django's make_password()
    ↓
PBKDF2 Algorithm + SHA256
    ↓
Generated Hash: "pbkdf2_sha256$260000$..."
    ↓
Stored in Database (password_hash field)

Later, when verifying:

User Input: "mypassword123"
    ↓
video.check_password("mypassword123")
    ↓
Django's check_password()
    ↓
Compare with stored hash
    ↓
Return True/False
```

### Session Management Flow

```
User Enters Correct Password
    ↓
Generate/Get Session Key
    ↓
Create VideoAccessSession
    ├─ session_key: "abc123..."
    ├─ video: Video object
    ├─ created_at: Now
    └─ expires_at: Now + 1 hour
    ↓
Store in Database
    ↓
User Can Access Video
    ↓
On Each Video Request:
    ├─ Get session_key from cookie
    ├─ Query VideoAccessSession
    ├─ Check expires_at > now
    ├─ If valid: Allow access
    └─ If expired: Deny & redirect
```

## Database Relationships

```
┌───────────────────────────┐
│         Video             │
├───────────────────────────┤
│ id (UUID, PK)             │
│ title                     │
│ description               │
│ video_file                │
│ thumbnail                 │
│ password_hash             │
│ uploaded_at               │
│ views                     │
└────────────┬──────────────┘
             │
             │ 1:N relationship
             │
             ▼
┌───────────────────────────┐
│   VideoAccessSession      │
├───────────────────────────┤
│ id (PK)                   │
│ session_key               │
│ video_id (FK)             │◄───┐
│ created_at                │    │
│ expires_at                │    │
└───────────────────────────┘    │
                                 │
                        Foreign Key
                        References Video.id
```

## Request-Response Cycle

### Public Request Example

```
1. User visits: http://127.0.0.1:8000/watch/
   ↓
2. Django URLconf matches: path('watch/', views.watch_list)
   ↓
3. views.watch_list() executes:
   ├─ videos = Video.objects.all()
   ├─ context = {'videos': videos}
   └─ return render(request, 'videos/watch.html', context)
   ↓
4. Template Engine processes watch.html
   ├─ Extends base.html
   ├─ Loops through videos
   └─ Generates HTML
   ↓
5. HTTP Response sent to browser
   ↓
6. Browser renders page
```

### Admin Request Example

```
1. Admin visits: http://127.0.0.1:8000/upload/
   ↓
2. Django URLconf matches: path('upload/', views.upload_video)
   ↓
3. @staff_member_required decorator checks:
   ├─ Is user authenticated?
   ├─ Is user.is_staff = True?
   └─ If NO: Redirect to login
   ↓
4. views.upload_video() executes:
   ├─ GET request: Display empty form
   └─ POST request:
       ├─ Validate form data
       ├─ Hash password
       ├─ Save video file
       ├─ Create database record
       └─ Redirect to dashboard
   ↓
5. Template rendered and returned
```

## File Storage Architecture

```
project_root/
│
├── media/
│   ├── videos/
│   │   ├── video1.mp4
│   │   ├── video2.mp4
│   │   └── video3.mp4
│   │
│   └── thumbnails/
│       ├── thumb1.jpg
│       ├── thumb2.jpg
│       └── thumb3.jpg
│
└── db.sqlite3
    └── Contains:
        ├── Video records (metadata + file paths)
        └── VideoAccessSession records
```

## Security Layers

```
Layer 1: Authentication
    ├─ Django Admin Login
    └─ Staff Member Required Decorator

Layer 2: Authorization
    ├─ Session-based Access Control
    └─ VideoAccessSession Model

Layer 3: Password Protection
    ├─ Hashed Passwords (PBKDF2)
    └─ No Plaintext Storage

Layer 4: URL Protection
    ├─ Session Validation on Stream
    └─ 403 Forbidden if Invalid

Layer 5: CSRF Protection
    ├─ Django Middleware
    └─ Token on All Forms

Layer 6: Session Expiry
    ├─ Automatic Timeout (1 hour)
    └─ Cleanup of Expired Sessions
```

## Deployment Architecture

### Current (Development)
```
┌─────────────────────────┐
│   Windows 10 Machine    │
│                         │
│  ┌───────────────────┐  │
│  │  Django Dev Server │  │
│  │  (port 8000)       │  │
│  └───────────────────┘  │
│           ↓             │
│  ┌───────────────────┐  │
│  │  SQLite Database  │  │
│  └───────────────────┘  │
│           ↓             │
│  ┌───────────────────┐  │
│  │  Local Media      │  │
│  │  Storage          │  │
│  └───────────────────┘  │
└─────────────────────────┘
```

### Future (Production - Suggested)
```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────┐
│   CDN       │
│  (Static)   │
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│  Load Balancer   │
└──────┬───────────┘
       │
       ├─────────┬─────────┐
       ▼         ▼         ▼
   ┌─────┐   ┌─────┐   ┌─────┐
   │App  │   │App  │   │App  │
   │Srv 1│   │Srv 2│   │Srv 3│
   └──┬──┘   └──┬──┘   └──┬──┘
      │         │         │
      └────┬────┴────┬────┘
           ▼         ▼
      ┌─────────┐ ┌──────────┐
      │PostgreSQL│ │  Cloud   │
      │ Database│ │  Storage │
      └─────────┘ └──────────┘
```

## Performance Considerations

### Current Bottlenecks
1. SQLite (single-threaded writes)
2. Local file serving (no CDN)
3. Synchronous video processing
4. No caching layer

### Optimization Strategies
1. **Database**: Migrate to PostgreSQL
2. **Storage**: Use S3/GCS with CDN
3. **Caching**: Implement Redis
4. **Processing**: Add Celery for async tasks
5. **Search**: Add Elasticsearch for large catalogs

## Scalability Path

```
Stage 1: Current (Development)
    └─ Single server, SQLite, local storage
         ↓
Stage 2: Small Production
    └─ VPS, PostgreSQL, local storage
         ↓
Stage 3: Medium Scale
    └─ Multiple servers, PostgreSQL, S3 storage
         ↓
Stage 4: Large Scale
    └─ Load balanced, PostgreSQL cluster, CDN, caching
```

---

**This architecture provides a secure, maintainable, and scalable foundation for video hosting!**
