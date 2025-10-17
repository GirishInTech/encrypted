# 🎬 Video Player Troubleshooting Guide

## Issue: Black Screen / Video Not Playing

### Quick Fixes

#### 1. **Check Browser Console**
Press `F12` → Go to "Console" tab → Look for errors

Common errors and solutions:

**Error: "404 Not Found"**
- Video file doesn't exist
- Check if video was uploaded correctly
- Verify file path in database

**Error: "403 Forbidden"**
- Session expired (1 hour limit)
- Re-enter password
- Check if session is valid

**Error: "Video format not supported"**
- Video format incompatible
- Convert to MP4 (H.264 codec)
- Use online converter or FFmpeg

#### 2. **Check Network Tab**
Press `F12` → Go to "Network" tab → Reload page

Look for the video request:
- **Status 200**: Video loading (good!)
- **Status 403**: Access denied (re-enter password)
- **Status 404**: File not found (check upload)
- **Status 500**: Server error (check logs)

#### 3. **Verify Video File**
```powershell
# Check if media directory exists
cd "d:\Girish\encrypted hosting\video_hosting"
dir media\videos
```

Should see your uploaded video files.

---

## Common Causes & Solutions

### Cause 1: Video Format Not Supported

**Symptoms:**
- Black screen
- "Format not supported" error
- Player loads but won't play

**Solution:**
Convert video to MP4 with H.264 codec:

```bash
# Using FFmpeg (install first)
ffmpeg -i input.avi -c:v libx264 -c:a aac output.mp4
```

**Recommended formats:**
- ✅ **MP4** (H.264 video, AAC audio) - Best compatibility
- ✅ **WebM** (VP8/VP9 video, Vorbis audio)
- ❌ **AVI** - May not work in browser
- ❌ **MKV** - May not work in browser
- ❌ **MOV** - May work, but MP4 is better

### Cause 2: Video File Missing

**Symptoms:**
- 404 error in console
- "Video file not found" message

**Solution:**
1. Check if video exists:
   ```powershell
   dir "d:\Girish\encrypted hosting\video_hosting\media\videos"
   ```

2. Re-upload video if missing

3. Check database:
   ```powershell
   python manage.py shell
   ```
   ```python
   from videos.models import Video
   for v in Video.objects.all():
       print(f"{v.title}: {v.video_file.name}")
   ```

### Cause 3: Session Expired

**Symptoms:**
- 403 Forbidden error
- "Access denied" message
- Worked before, stopped working

**Solution:**
- Re-enter password (sessions expire after 1 hour)
- Clear browser cookies
- Try in incognito mode

### Cause 4: Large Video File

**Symptoms:**
- Long loading time
- Buffering
- Timeout errors

**Solution:**
1. **Compress video:**
   ```bash
   ffmpeg -i input.mp4 -vcodec h264 -acodec aac -b:v 1M output.mp4
   ```

2. **Use smaller resolution:**
   - 1080p → 720p
   - 720p → 480p

3. **Increase timeout** (in settings.py):
   ```python
   DATA_UPLOAD_MAX_MEMORY_SIZE = 524288000  # 500 MB
   FILE_UPLOAD_MAX_MEMORY_SIZE = 524288000
   ```

### Cause 5: MIME Type Issue

**Symptoms:**
- Video downloads instead of playing
- Wrong content type

**Solution:**
Already fixed in code! The stream_video view now:
- Auto-detects MIME type
- Falls back to 'video/mp4'
- Sets proper headers

### Cause 6: Video.js Not Loading

**Symptoms:**
- No player controls
- Plain HTML5 video player
- Console error about videojs

**Solution:**
1. Check internet connection (Video.js loads from CDN)
2. Try different CDN:
   ```html
   <script src="https://cdn.jsdelivr.net/npm/video.js@8/dist/video.min.js"></script>
   ```
3. Download Video.js locally if offline

---

## Debugging Steps

### Step 1: Check Video Upload
```powershell
# List uploaded videos
python manage.py shell -c "from videos.models import Video; [print(f'{v.title}: {v.video_file.path}') for v in Video.objects.all()]"
```

### Step 2: Test Video File Directly
Try accessing video file directly:
```
http://localhost:8000/media/videos/your-video.mp4
```

If this works, the issue is with the player, not the file.

### Step 3: Check Server Logs
Look at terminal where `runserver` is running for errors.

### Step 4: Test in Different Browser
- Chrome
- Firefox
- Edge
- Safari (if on Mac)

### Step 5: Check File Permissions
```powershell
# On Windows, check if file is readable
Get-Acl "media\videos\your-video.mp4"
```

---

## Browser Console Commands

### Check if Video.js Loaded
```javascript
typeof videojs
// Should return "function"
```

### Get Player Instance
```javascript
var player = videojs('my-video');
console.log(player);
```

### Check Video Source
```javascript
var player = videojs('my-video');
console.log(player.currentSrc());
```

### Manually Load Video
```javascript
var player = videojs('my-video');
player.src({
    type: 'video/mp4',
    src: '/video/YOUR-VIDEO-ID/stream/'
});
player.load();
```

---

## Testing Checklist

### ✅ Pre-Flight Checks
- [ ] Video file uploaded successfully
- [ ] Video appears in admin dashboard
- [ ] Password was set during upload
- [ ] Server is running (`runserver`)
- [ ] Correct URL accessed

### ✅ During Playback
- [ ] Password entered correctly
- [ ] Redirected to player page
- [ ] Player controls visible
- [ ] Big play button appears
- [ ] Console shows no errors

### ✅ Video Playback
- [ ] Click play button
- [ ] Video starts playing
- [ ] Audio works
- [ ] Seeking works (scrubbing timeline)
- [ ] Fullscreen works
- [ ] Volume control works

---

## Quick Test Video

### Create a Test Video
Use a small test video to verify everything works:

1. **Download test video:**
   - Go to: https://sample-videos.com/
   - Download small MP4 file (< 5MB)

2. **Upload via admin**
3. **Test playback**

If test video works, the issue is with your original video file.

---

## Video Format Conversion

### Using FFmpeg (Recommended)

**Install FFmpeg:**
```powershell
# Using Chocolatey
choco install ffmpeg

# Or download from: https://ffmpeg.org/download.html
```

**Convert to MP4:**
```bash
ffmpeg -i input.avi -c:v libx264 -c:a aac -strict experimental output.mp4
```

**Compress large video:**
```bash
ffmpeg -i input.mp4 -vcodec h264 -acodec aac -b:v 1M -b:a 128k output.mp4
```

**Change resolution:**
```bash
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4
```

### Online Converters
- CloudConvert.com
- Online-Convert.com
- Convertio.co

---

## Error Messages Explained

### "Access denied. Please enter password."
- **Cause**: No valid session
- **Fix**: Enter password again

### "Video file not found"
- **Cause**: File doesn't exist or path wrong
- **Fix**: Re-upload video

### "Format not supported"
- **Cause**: Browser can't play video codec
- **Fix**: Convert to MP4 H.264

### "Failed to load resource: 403"
- **Cause**: Session expired or invalid
- **Fix**: Re-enter password

### "Failed to load resource: 404"
- **Cause**: Video file missing
- **Fix**: Check file exists in media/videos/

---

## Advanced Debugging

### Enable Django Debug Mode
In `settings.py`:
```python
DEBUG = True
```

### Check Video File Path
```python
python manage.py shell
```
```python
from videos.models import Video
v = Video.objects.first()
print(f"File path: {v.video_file.path}")
print(f"File exists: {v.video_file.storage.exists(v.video_file.name)}")
print(f"File size: {v.video_file.size} bytes")
```

### Test Stream URL Directly
```python
from videos.models import Video
v = Video.objects.first()
print(f"Stream URL: /video/{v.id}/stream/")
```

Then visit that URL in browser.

---

## Still Not Working?

### Last Resort Fixes

#### 1. Use Basic HTML5 Player
Replace Video.js with basic HTML5:

```html
<video controls width="100%" style="max-width: 1000px;">
    <source src="{% url 'stream_video' video.id %}" type="video/mp4">
</video>
```

#### 2. Serve Video Directly
Temporarily disable session check in `stream_video` view (for testing only):

```python
# Comment out session check
# if not session_key:
#     return HttpResponseForbidden(...)
```

#### 3. Check File Encoding
```powershell
ffprobe -v error -show_format -show_streams "media\videos\your-video.mp4"
```

---

## Prevention Tips

### For Future Uploads:
1. ✅ Always use MP4 format (H.264 + AAC)
2. ✅ Keep videos under 500MB
3. ✅ Test video plays in VLC before uploading
4. ✅ Use reasonable resolution (720p or 1080p)
5. ✅ Compress videos if too large

### Recommended Video Settings:
- **Format**: MP4
- **Video Codec**: H.264
- **Audio Codec**: AAC
- **Resolution**: 1280x720 or 1920x1080
- **Bitrate**: 1-5 Mbps
- **Frame Rate**: 24-30 fps

---

## Success Indicators

### Video Working Correctly:
- ✅ Player loads with controls visible
- ✅ Big purple play button appears
- ✅ Clicking play starts video
- ✅ Audio plays
- ✅ Timeline shows duration
- ✅ Seeking works
- ✅ Fullscreen works
- ✅ Console shows "Video data loaded successfully!"

---

## Get Help

### Information to Provide:
1. Browser console errors (F12 → Console)
2. Network tab status codes (F12 → Network)
3. Video file format and size
4. Django server terminal output
5. Steps to reproduce

---

**Most common fix: Convert video to MP4 format!** 🎬
