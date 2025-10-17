# 🧪 Testing Guide

Complete guide for testing the Video Hosting Platform.

## Running Tests

### Run All Tests
```powershell
python manage.py test videos
```

### Run Specific Test Class
```powershell
python manage.py test videos.tests.VideoModelTest
```

### Run with Verbose Output
```powershell
python manage.py test videos --verbosity=2
```

### Run with Coverage (Optional)
```powershell
# Install coverage first
pip install coverage

# Run tests with coverage
coverage run --source='videos' manage.py test videos
coverage report
coverage html  # Generate HTML report
```

## Test Cases

### 1. Model Tests

#### Video Model Tests
- ✅ Password hashing verification
- ✅ Password verification (correct/incorrect)
- ✅ View count increment
- ✅ String representation

#### VideoAccessSession Model Tests
- ✅ Session validity check
- ✅ Expired session detection
- ✅ Session cleanup

### 2. View Tests

#### Public Views
- ✅ Home page loads correctly
- ✅ Watch list page displays videos
- ✅ Password entry page loads
- ✅ Correct password grants access
- ✅ Incorrect password shows error

#### Admin Views
- ✅ Admin dashboard requires authentication
- ✅ Upload page requires staff permission
- ✅ Delete page requires staff permission
- ✅ Admin dashboard displays videos

### 3. Security Tests

#### Access Control
- ✅ Direct stream access is blocked
- ✅ View video without session redirects
- ✅ Expired sessions are invalidated
- ✅ Admin-only views require authentication

## Manual Testing Checklist

### 🏠 Homepage Testing
- [ ] Homepage loads without errors
- [ ] Navigation links work correctly
- [ ] "Watch Videos" button navigates to video list
- [ ] Admin links visible only when logged in
- [ ] Responsive design works on different screen sizes

### 📺 Video Listing Testing
- [ ] All videos are displayed
- [ ] Video titles and descriptions show correctly
- [ ] Thumbnails display (or default icon shows)
- [ ] View counts are accurate
- [ ] Upload dates format correctly
- [ ] "Enter Password" button works for each video

### 🔐 Password Protection Testing
- [ ] Password page loads for each video
- [ ] Correct password grants access
- [ ] Incorrect password shows error message
- [ ] Password field has proper focus
- [ ] Form validation works
- [ ] CSRF token is present

### 🎥 Video Player Testing
- [ ] Video player loads after correct password
- [ ] Video plays smoothly
- [ ] Video controls work (play, pause, volume, fullscreen)
- [ ] View count increments
- [ ] Session expires after 1 hour
- [ ] "Back to Video List" button works

### 🔒 Security Testing

#### Test 1: Direct URL Access
1. Watch a video with correct password
2. Copy the stream URL: `/video/<id>/stream/`
3. Open incognito window
4. Paste URL directly
5. ✅ Should show "Access denied" message

#### Test 2: Session Expiry
1. Watch a video with correct password
2. Close browser (not just tab)
3. Open browser again
4. Try to access video URL directly
5. ✅ Should redirect to password page

#### Test 3: URL Sharing
1. Watch a video with correct password
2. Copy the view URL: `/video/<id>/view/`
3. Share with another user
4. Other user opens URL
5. ✅ Should redirect to password page

#### Test 4: Admin Access
1. Logout or use incognito
2. Try to access `/upload/`
3. ✅ Should redirect to admin login
4. Try to access `/admin-dashboard/`
5. ✅ Should redirect to admin login

### 👤 Admin Testing

#### Upload Video
- [ ] Admin login works
- [ ] Upload form displays correctly
- [ ] All fields accept input
- [ ] Password confirmation validation works
- [ ] File upload accepts video files
- [ ] Thumbnail upload accepts image files
- [ ] Success message appears after upload
- [ ] Video appears in dashboard

#### Admin Dashboard
- [ ] Dashboard loads with authentication
- [ ] All videos are listed
- [ ] Statistics display correctly
- [ ] View button works
- [ ] Delete button works
- [ ] Upload button navigates to upload page

#### Delete Video
- [ ] Delete confirmation page loads
- [ ] Video details display correctly
- [ ] Warning message is clear
- [ ] Cancel button returns to dashboard
- [ ] Delete button removes video
- [ ] Video file is deleted from storage
- [ ] Success message appears

## Browser Compatibility Testing

### Desktop Browsers
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Edge (latest)
- [ ] Safari (if available)

### Mobile Browsers
- [ ] Chrome Mobile
- [ ] Safari Mobile
- [ ] Firefox Mobile

### Test Points
- [ ] Layout is responsive
- [ ] Video player works
- [ ] Forms are usable
- [ ] Navigation is accessible
- [ ] Touch interactions work

## Performance Testing

### Video Upload
- [ ] Small file (< 10 MB) uploads quickly
- [ ] Medium file (10-50 MB) uploads successfully
- [ ] Large file (> 50 MB) uploads (may take time)
- [ ] Progress indication (if implemented)
- [ ] Error handling for oversized files

### Video Streaming
- [ ] Video starts playing within 5 seconds
- [ ] No buffering on local network
- [ ] Seeking works smoothly
- [ ] Multiple concurrent views work

### Database Performance
- [ ] Page load time < 2 seconds
- [ ] Video list loads quickly with 10+ videos
- [ ] Search/filter works efficiently (if implemented)

## Edge Cases Testing

### Invalid Data
- [ ] Upload without video file
- [ ] Upload without password
- [ ] Mismatched password confirmation
- [ ] Empty title field
- [ ] Special characters in title
- [ ] Very long title (> 200 chars)

### URL Manipulation
- [ ] Invalid video ID in URL
- [ ] Non-existent video ID
- [ ] Malformed UUID
- [ ] SQL injection attempts (should be prevented)

### Session Management
- [ ] Multiple tabs with same video
- [ ] Multiple videos in different tabs
- [ ] Session after browser close
- [ ] Session after logout

## Security Testing Checklist

- [ ] Passwords are hashed in database
- [ ] No plaintext passwords visible
- [ ] CSRF tokens on all forms
- [ ] XSS protection works
- [ ] SQL injection protected
- [ ] Admin-only views protected
- [ ] Session hijacking prevented
- [ ] Video URLs are protected

## Accessibility Testing

- [ ] Keyboard navigation works
- [ ] Tab order is logical
- [ ] Forms have proper labels
- [ ] Error messages are clear
- [ ] Color contrast is sufficient
- [ ] Screen reader compatible (basic)

## Error Handling Testing

### Expected Errors
- [ ] 404 page for invalid URLs
- [ ] Incorrect password message
- [ ] Upload validation errors
- [ ] Session expired messages
- [ ] Access denied messages

### Unexpected Errors
- [ ] Database connection error
- [ ] File system error
- [ ] Missing media files
- [ ] Corrupted video files

## Load Testing (Optional)

### Simple Load Test
```powershell
# Install locust
pip install locust

# Create locustfile.py with test scenarios
# Run load test
locust -f locustfile.py
```

### Test Scenarios
- [ ] 10 concurrent users browsing
- [ ] 5 concurrent video streams
- [ ] Multiple file uploads
- [ ] Database under load

## Test Data Preparation

### Sample Videos
Prepare test videos:
- Small (1-5 MB, 30 seconds)
- Medium (10-20 MB, 2-3 minutes)
- Large (50+ MB, 5+ minutes)
- Various formats (MP4, WebM, AVI)

### Sample Users
- Admin user: `admin / admin123`
- Test user: `testuser / test123`
- Guest (no login)

### Sample Passwords
- Simple: `test123`
- Complex: `T3st!ngP@ssw0rd`
- With spaces: `test pass 123`
- Special chars: `test@#$%`

## Regression Testing

After making changes, verify:
- [ ] All existing tests still pass
- [ ] No new bugs introduced
- [ ] Performance not degraded
- [ ] Security features still work
- [ ] UI/UX not broken

## Bug Reporting Template

When you find a bug:

```
**Bug Title**: [Brief description]

**Severity**: [Critical/High/Medium/Low]

**Steps to Reproduce**:
1. Go to...
2. Click on...
3. Enter...
4. Observe...

**Expected Behavior**:
[What should happen]

**Actual Behavior**:
[What actually happens]

**Environment**:
- OS: Windows 10
- Browser: Chrome 120
- Python: 3.11
- Django: 4.2.8

**Screenshots**:
[If applicable]

**Additional Context**:
[Any other relevant information]
```

## Automated Testing Best Practices

1. **Test Isolation**: Each test should be independent
2. **Clear Names**: Use descriptive test method names
3. **Setup/Teardown**: Use setUp() and tearDown() methods
4. **Assertions**: Use appropriate assertion methods
5. **Coverage**: Aim for 80%+ code coverage
6. **Speed**: Keep tests fast
7. **Documentation**: Comment complex test logic

## Continuous Testing

### Git Hooks (Optional)
```bash
# Run tests before commit
# Create .git/hooks/pre-commit

#!/bin/sh
python manage.py test videos
```

### CI/CD (Optional)
Set up automated testing on:
- GitHub Actions
- GitLab CI
- Jenkins
- Travis CI

## Testing Tools

### Recommended Tools
- **Django Test**: Built-in testing framework
- **Coverage.py**: Code coverage analysis
- **Selenium**: Browser automation
- **Locust**: Load testing
- **Postman**: API testing (if needed)

## Conclusion

Regular testing ensures:
- ✅ Application reliability
- ✅ Security compliance
- ✅ User satisfaction
- ✅ Code quality
- ✅ Easy maintenance

**Remember**: Test early, test often, test everything!
