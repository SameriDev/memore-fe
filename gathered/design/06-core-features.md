# memore Core Features

## Feature Overview

This document defines the core functionality of the memore app, focusing on the essential features needed for a **Phase 1** implementation that delivers the core value proposition of authentic photo sharing between close friends.

### Feature Prioritization

- **Phase 1** (MVP): Core photo sharing, friend management, basic app functionality
- **Phase 2** (Enhanced): Photo history, advanced features, notifications
- **Phase 3** (Future): Home screen widgets, advanced analytics, premium features

---

## 1. User Authentication & Onboarding

### 1.1 Phone Number Authentication

#### User Story

> As a new user, I want to create an account using my phone number so that I can quickly join memore and connect with friends who have my number.

#### Functional Requirements

**Phone Number Input**

- Support international phone numbers with country code selection
- Auto-detect country based on device locale
- Real-time phone number formatting and validation
- Clear error messages for invalid numbers

**SMS Verification**

- Send 6-digit verification code via SMS
- 30-second countdown before allowing resend
- Auto-advance cursor between input fields
- Auto-submit when all 6 digits entered
- Maximum 3 verification attempts before cooldown

**Account Creation**

- Create user account upon successful verification
- Generate unique user ID and username
- Set up basic profile with phone number
- Grant necessary app permissions

#### Business Rules

- One account per phone number
- Phone number cannot be changed after verification
- Account required to access any app features
- Verification code expires after 10 minutes

#### Technical Requirements

```dart
// Data Models
class User {
  final String id;
  final String phoneNumber;
  final String username;
  final DateTime createdAt;
  final UserProfile profile;
}

class VerificationRequest {
  final String phoneNumber;
  final String code;
  final DateTime expiresAt;
  final int attemptsRemaining;
}
```

### 1.2 Initial App Setup

#### User Story

> As a new user, I want to complete the initial setup process so that I can start using memore to share photos with friends.

#### Functional Requirements

**Permission Requests**

- Camera access for photo capture
- Photo library access for sharing existing photos
- Notification permission for friend updates
- Contacts access (optional) for friend discovery

**Profile Creation**

- Choose profile photo (camera or gallery)
- Set display name (auto-suggest from contacts)
- Create optional bio/status message
- Preview profile before saving

**Friend Discovery**

- Scan contacts for existing memore users
- Display suggested friends with mutual connections
- Manual phone number entry for friend invites
- Option to skip and add friends later

#### Business Rules

- Camera permission required to proceed
- Other permissions are optional but encouraged
- Profile photo and name can be updated later
- Minimum 0 friends required to complete setup

---

## 2. Photo Capture & Sharing

### 2.1 Camera Interface

#### User Story

> As a user, I want to capture and share photos quickly and easily so that I can share moments with my friends in real-time.

#### Functional Requirements

**Camera Controls**

- Default to back camera on app launch
- Tap to capture photo with immediate feedback
- Tap to focus with exposure adjustment
- Pinch to zoom (1x to 8x range)
- Double-tap to switch between front/back camera

**Camera Settings**

- Flash toggle (auto/on/off)
- Grid lines toggle for composition help
- Photo quality settings (high/medium/low)
- Timer function (3 seconds, 10 seconds)

**Photo Processing**

- Automatic image compression for sharing
- EXIF data removal for privacy
- Image orientation correction
- Basic auto-enhancement (optional)

#### Technical Requirements

```dart
// Camera Controller
class CameraController {
  Future<void> initialize();
  Future<XFile> takePicture();
  void setFlashMode(FlashMode mode);
  void setExposureOffset(double offset);
  void setZoomLevel(double zoom);
}

// Photo Processing
class PhotoProcessor {
  Future<File> compressImage(File image);
  Future<File> removeExifData(File image);
  Future<File> correctOrientation(File image);
}
```

### 2.2 Photo Sharing Flow

#### User Story

> As a user, I want to send photos to specific friends so that I can share moments with the people I care about.

#### Functional Requirements

**Friend Selection**

- Display list of connected friends
- Multi-select up to 5 friends per photo
- Quick send to recent recipients
- Search friends by name

**Photo Preview**

- Full-screen photo preview before sending
- Basic editing options (crop, rotate, filters)
- Add optional caption (max 100 characters)
- Retake photo option

**Send Confirmation**

- Clear indication of selected recipients
- Send progress indicator
- Success/failure feedback
- Retry mechanism for failed sends

#### Business Rules

- Maximum 5 recipients per photo
- Photo size limit: 10MB original, 2MB compressed
- Caption length limit: 100 characters
- Photos expire after 24 hours if not delivered

#### Technical Requirements

```dart
// Photo Sharing
class PhotoSharingService {
  Future<void> sendPhoto(File photo, List<String> recipientIds, String caption);
  Future<bool> retryFailedSend(String photoId);
  Stream<PhotoSendStatus> getSendStatus(String photoId);
}

// Data Models
class PhotoMessage {
  final String id;
  final String senderId;
  final List<String> recipientIds;
  final String photoUrl;
  final String caption;
  final DateTime sentAt;
  final PhotoSendStatus status;
}
```

---

## 3. Photo Receiving & Viewing

### 3.1 Photo Feed

#### User Story

> As a user, I want to see photos that friends have sent me so that I can stay connected with their daily moments.

#### Functional Requirements

**Feed Display**

- Chronological display of received photos
- Friend name and timestamp for each photo
- Unread indicators for new photos
- Pull-to-refresh for latest updates

**Photo Interaction**

- Tap to view full-screen
- Double-tap to react with heart
- Long-press for context menu (save, delete, report)
- Swipe left/right to navigate between photos

**Photo Details**

- Full-screen photo viewer
- Sender information and timestamp
- Caption display (if included)
- Reaction and response options

#### Technical Requirements

```dart
// Feed Service
class PhotoFeedService {
  Stream<List<PhotoMessage>> getPhotoFeed();
  Future<void> markPhotoAsRead(String photoId);
  Future<void> reactToPhoto(String photoId, ReactionType reaction);
}

// Photo Viewer
class PhotoViewer extends StatefulWidget {
  final List<PhotoMessage> photos;
  final int initialIndex;
}
```

### 3.2 Photo Reactions

#### User Story

> As a user, I want to react to friends' photos so that I can show appreciation and maintain connection.

#### Functional Requirements

**Reaction Types**

- Heart reaction (primary)
- Quick emoji reactions (laugh, wow, sad)
- Text response option
- Photo response (counter-photo)

**Reaction Display**

- Sender sees reactions on their photos
- Reaction count and types visible
- Recent reactions highlighted
- Reaction history for each photo

#### Business Rules

- One reaction per person per photo
- Reactions can be changed/updated
- Reactions visible only to photo sender
- Text responses limited to 50 characters

---

## 4. Friend Management

### 4.1 Adding Friends

#### User Story

> As a user, I want to add friends to my memore circle so that I can share photos with people I care about.

#### Functional Requirements

**Friend Discovery**

- Search by phone number
- Import from device contacts
- Suggested friends based on mutual connections
- QR code sharing for in-person adds

**Friend Requests**

- Send friend request with optional message
- View pending outgoing requests
- Accept/decline incoming requests
- Request expiration after 7 days

**Connection Confirmation**

- Clear confirmation when friend is added
- Immediate ability to send photos
- Friend appears in selection lists
- Notification to both parties

#### Business Rules

- Maximum 20 friends per user (memore's key limitation)
- Mutual consent required for connection
- Phone number required for friend requests
- No public friend lists or discovery

#### Technical Requirements

```dart
// Friend Management
class FriendService {
  Future<void> sendFriendRequest(String phoneNumber, String message);
  Future<void> acceptFriendRequest(String requestId);
  Future<void> declineFriendRequest(String requestId);
  Future<List<Friend>> getFriends();
  Future<List<FriendRequest>> getPendingRequests();
}

// Data Models
class Friend {
  final String id;
  final String phoneNumber;
  final String displayName;
  final String profilePhotoUrl;
  final bool isOnline;
  final DateTime lastSeen;
}

class FriendRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String message;
  final DateTime sentAt;
  final FriendRequestStatus status;
}
```

### 4.2 Managing Friends

#### User Story

> As a user, I want to manage my friend connections so that I can control who can send me photos.

#### Functional Requirements

**Friend List**

- Alphabetical list of current friends
- Online status indicators
- Last activity timestamps
- Friend profile access

**Friend Actions**

- Remove friend (with confirmation)
- Block friend (with reporting option)
- Mute friend notifications
- View shared photo history

**Privacy Controls**

- Block specific users
- Report inappropriate behavior
- Control who can find you
- Manage friend request settings

#### Business Rules

- Removing a friend is mutual (both lose connection)
- Blocked users cannot send friend requests
- Muted friends' photos still appear but without notifications
- Shared photo history deleted when friend is removed

---

## 5. Notifications

### 5.1 Push Notifications

#### User Story

> As a user, I want to receive notifications when friends interact with me so that I can stay connected and respond promptly.

#### Functional Requirements

**Notification Types**

- New photo received
- Friend request received
- Photo reaction received
- Friend came online (optional)

**Notification Content**

- Friend name and action
- Photo thumbnail (for photo notifications)
- Appropriate app icon and branding
- Deep link to relevant app section

**Notification Settings**

- Enable/disable each notification type
- Quiet hours configuration
- VIP friends (always notify)
- Notification sound customization

#### Business Rules

- Notifications sent only for opted-in events
- Respect device Do Not Disturb settings
- Batch multiple notifications from same friend
- Maximum 10 notifications per day per user

#### Technical Requirements

```dart
// Notification Service
class NotificationService {
  Future<void> sendPhotoNotification(String recipientId, PhotoMessage photo);
  Future<void> sendFriendRequestNotification(String recipientId, FriendRequest request);
  Future<void> scheduleNotification(String userId, NotificationType type, Map<String, dynamic> data);
}

// Notification Settings
class NotificationSettings {
  final bool photoNotifications;
  final bool friendRequestNotifications;
  final bool reactionNotifications;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final List<String> vipFriends;
}
```

### 5.2 In-App Notifications

#### User Story

> As a user, I want to see notifications within the app so that I can quickly understand what's new when I open memore.

#### Functional Requirements

**Notification Center**

- List of recent notifications
- Mark as read functionality
- Quick actions (view photo, accept request)
- Notification grouping by type

**Badge Indicators**

- Red badge on tabs with new content
- Number badges for multiple items
- Badge clearing when content viewed
- Visual indication of notification priority

---

## 6. User Profile

### 6.1 Profile Management

#### User Story

> As a user, I want to manage my profile so that friends can recognize me and I can control how I appear to others.

#### Functional Requirements

**Profile Information**

- Profile photo (camera or gallery)
- Display name (editable)
- Username (auto-generated, editable once)
- Status message/bio (optional, 50 characters)

**Profile Settings**

- Privacy controls
- Notification preferences
- Data usage settings
- Account management

**Profile Viewing**

- Own profile view with edit options
- Friends' profile view (read-only)
- Shared photo history with each friend
- Friend since date and statistics

#### Technical Requirements

```dart
// Profile Service
class ProfileService {
  Future<UserProfile> getProfile(String userId);
  Future<void> updateProfile(UserProfile profile);
  Future<void> updateProfilePhoto(File photo);
  Future<void> updateDisplayName(String name);
}

// User Profile Model
class UserProfile {
  final String userId;
  final String displayName;
  final String username;
  final String profilePhotoUrl;
  final String bio;
  final DateTime lastActive;
  final PrivacySettings privacy;
}
```

---

## 7. Photo History & Management

### 7.1 Photo History (Phase 2 Feature)

#### User Story

> As a user, I want to view my photo history so that I can remember the moments I've shared and received.

#### Functional Requirements

**Sent Photos**

- Chronological list of sent photos
- Recipients and delivery status
- Reactions received
- Option to resend or delete

**Received Photos**

- Archive of photos from friends
- Search and filter capabilities
- Save to device photo library
- Bulk selection and management

**Shared Albums**

- Photos shared between specific friends
- Collaborative photo collections
- Export options for memories
- Privacy-controlled sharing

#### Business Rules

- Photos stored for 1 year maximum
- Users can delete their own sent photos
- Users can delete received photos (local only)
- Export limited to own photos and received photos

---

## 8. Settings & Privacy

### 8.1 Privacy Controls

#### User Story

> As a user, I want to control my privacy so that I feel safe sharing personal moments.

#### Functional Requirements

**Discovery Settings**

- Allow friend finding by phone number
- Hide from contact imports
- Control friend suggestions
- Limit who can send friend requests

**Content Controls**

- Auto-save received photos toggle
- Screenshot detection and notification
- Content reporting mechanisms
- Block and unblock users

**Data Management**

- View data usage statistics
- Clear cache and temporary files
- Download personal data
- Account deletion

#### Business Rules

- Default privacy settings favor user protection
- Users own their data and can request deletion
- Blocking is permanent and mutual
- Reported content reviewed within 24 hours

#### Technical Requirements

```dart
// Privacy Settings
class PrivacySettings {
  final bool allowDiscoveryByPhone;
  final bool autoSavePhotos;
  final bool enableScreenshotDetection;
  final FriendRequestPolicy friendRequestPolicy;
  final List<String> blockedUsers;
}

// Data Management
class DataService {
  Future<DataUsageStats> getDataUsage();
  Future<void> clearCache();
  Future<File> exportUserData();
  Future<void> deleteAccount();
}
```

---

## 9. Performance Requirements

### 9.1 Photo Upload Performance

#### Requirements

- Photo upload completion within 5 seconds on average connection
- Automatic retry for failed uploads (max 3 attempts)
- Background upload capability
- Progress indication for uploads >2 seconds

### 9.2 App Responsiveness

#### Requirements

- App launch time <3 seconds cold start
- Camera ready time <1 second
- Photo capture response <500ms
- Tab switching <200ms

### 9.3 Offline Capability

#### Requirements

- Cache last 50 photos for offline viewing
- Queue photo uploads when connection lost
- Basic app navigation available offline
- Graceful degradation of network features

---

## 10. Analytics & Monitoring

### 10.1 User Engagement Metrics

#### Key Metrics

- Daily active users (DAU)
- Photos shared per user per day
- Friend connections per user
- Session duration and frequency

### 10.2 Feature Usage Analytics

#### Tracking Points

- Camera feature usage patterns
- Most used sharing workflows
- Friend management behaviors
- Notification engagement rates

### 10.3 Performance Monitoring

#### Monitoring Areas

- Photo upload success rates
- App crash reporting
- Network error frequencies
- User flow completion rates

#### Technical Implementation

```dart
// Analytics Service
class AnalyticsService {
  void trackEvent(String eventName, Map<String, dynamic> parameters);
  void trackPhotoShared(int recipientCount);
  void trackUserRetention(String userId);
  void reportError(String error, Map<String, dynamic> context);
}
```

---

## 11. Security Requirements

### 11.1 Data Protection

#### Requirements

- End-to-end encryption for photo transmission
- Secure storage of user credentials
- Regular security audits and updates
- GDPR and privacy law compliance

### 11.2 Content Moderation

#### Requirements

- Automated detection of inappropriate content
- User reporting mechanisms
- Human moderation for complex cases
- Clear community guidelines

#### Technical Implementation

```dart
// Security Service
class SecurityService {
  Future<String> encryptPhoto(File photo);
  Future<File> decryptPhoto(String encryptedData);
  Future<bool> validateUserCredentials(String token);
  Future<void> reportSuspiciousActivity(String userId, String activity);
}
```
