# Mô tả chi tiết ứng dụng Memore

## 1. Tổng quan về Memore

### 1.1 Khái niệm cốt lõi
Memore là một ứng dụng chia sẻ ảnh thân mật (intimate photo-sharing app) được thiết kế cho các nhóm nhỏ bạn bè và gia đình. Khác với các mạng xã hội lớn như Instagram hay Facebook, Memore tập trung vào việc tạo ra một không gian riêng tư, an toàn để chia sẻ những khoảnh khắc chân thực mà không cần lo lắng về số lượt like hay sự phán xét từ đám đông.

### 1.2 Giá trị cốt lõi
- **Intimacy over Publicity**: Kết nối thân mật thay vì công khai rộng rãi
- **Authentic Moments**: Khoảnh khắc chân thực thay vì ảnh được chỉnh sửa hoàn hảo
- **Quality over Quantity**: Chất lượng mối quan hệ thay vì số lượng followers
- **Privacy First**: Quyền riêng tư và bảo mật là ưu tiên hàng đầu

### 1.3 Target Users
- Các gia đình muốn chia sẻ ảnh con cái một cách riêng tư
- Nhóm bạn thân muốn lưu giữ kỷ niệm chung
- Các cặp đôi muốn có không gian riêng tư
- Người dùng mệt mỏi với áp lực từ social media công khai

## 2. User Flow và Authentication

### 2.1 Onboarding Flow
1. **Welcome Screen**: Giới thiệu ngắn gọn về app với tagline "Share moments that matter"
2. **Register/Login Options**:
   - Email & Password registration
   - Google Sign-in (OAuth2)
   - Apple Sign-in (cho iOS)
3. **OTP Verification**: Xác thực email qua mã OTP 6 số
4. **Profile Setup**: Tên hiển thị, avatar (optional), ngày sinh

### 2.2 Authentication System
- **JWT Token với Refresh Token**: Access token (1h) và Refresh token (30 days)
- **Session Management**: Multi-device login support với device tracking
- **Security Features**:
  - Password phải ít nhất 8 ký tự, có chữ hoa, chữ thường và số
  - Rate limiting cho login attempts (5 lần/15 phút)
  - Email verification bắt buộc
  - Optional 2FA qua SMS/Authenticator app

### 2.3 User Profile
Mỗi user có:
- **Basic Info**: Name, Username (unique), Email, Birthday, Avatar
- **Stats**:
  - Friends count
  - Total photos shared
  - Active albums count
  - Streak count (số ngày liên tiếp có hoạt động)
- **Badge System**:
  - Bronze (0-30 photos)
  - Silver (31-100 photos)
  - Gold (101-500 photos)
  - Platinum (500+ photos)

## 3. Core Features

### 3.1 Albums - Trung tâm của trải nghiệm

Albums là cách tổ chức nội dung chính trong Memore. Mỗi album như một "phòng riêng" để chia sẻ ảnh với những người được mời.

**Album Properties**:
- **Metadata**: Name, Cover photo, Creation date, Creator
- **Privacy**: Private by default, chỉ những người được mời mới xem được
- **Participants**: 2-20 người (để giữ tính thân mật)
- **Content**: Unlimited photos, mỗi ảnh có thể có caption
- **Features**:
  - Favorite albums (ghim lên đầu)
  - Collaborative albums (mọi người đều có thể thêm ảnh)
  - Album timeline (xem ảnh theo thời gian)
  - Download entire album (zip file)

**Album Types**:
1. **Personal Albums**: Chỉ mình user xem
2. **Shared Albums**: Chia sẻ với specific users
3. **Event Albums**: Tự động tạo từ events (weddings, birthdays)
4. **Auto Albums**: AI tự động nhóm ảnh (by faces, locations, dates)

### 3.2 Photo Sharing

**Photo Upload**:
- **Sources**: Camera capture, Gallery pick, Import từ cloud
- **Formats**: JPEG, PNG, HEIF, RAW (convert to JPEG)
- **Size Limits**: 10MB per photo, tự động compress nếu cần
- **Metadata Preservation**: EXIF data, location (optional), date taken

**Photo Features**:
- **Multiple Sizes**:
  - Thumbnail (150x150) cho grid view
  - Medium (800px) cho timeline
  - Full resolution cho detail view
- **Privacy Controls**:
  - Remove location data
  - Blur faces (AI-powered)
  - Set expiration date
- **Interactions**:
  - Like (heart icon, không hiển thị số)
  - Comment (text only, no photo replies)
  - Save to personal collection
  - Share to other albums

### 3.3 Timeline

Timeline là nơi xem tất cả ảnh từ albums mà user tham gia, sắp xếp theo thời gian.

**Timeline Features**:
- **Smart Grouping**: By day, week, month, season
- **Filters**:
  - By album
  - By person (face recognition)
  - By date range
  - By location
- **View Modes**:
  - Grid view (3 columns)
  - List view (full width với captions)
  - Map view (photos on map)
- **Memories**: "On this day" notifications

### 3.4 Stories (24h content)

Tương tự Instagram Stories nhưng chỉ visible cho close friends.

**Story Features**:
- **Duration**: 24 hours default, có thể set 1h, 6h, 12h
- **Content Types**: Photos only (no videos trong MVP)
- **Viewers**: Chỉ friends mới xem được
- **No Screenshots**: Notify khi có người screenshot
- **Story Highlights**: Save stories vào albums

### 3.5 Friends System

**Friend Management**:
- **Adding Friends**:
  - Search by email/username
  - QR code scanning
  - Invite link
  - Import từ contacts
- **Friend Requests**: Require approval, có thể kèm message
- **Friend Lists**: Categorize friends (Family, Close Friends, Friends)
- **Privacy Levels**: Control what each friend group can see

**Friend Features**:
- **Activity Status**: Online/Offline với last seen
- **Friend Timeline**: Xem chỉ ảnh của 1 friend specific
- **Mutual Albums**: Quick access đến shared albums
- **Birthday Reminders**: Notification về sinh nhật friends

### 3.6 Camera Integration

**Camera Features**:
- **Quick Capture**: Swipe từ home để mở camera
- **Modes**: Photo, Portrait (blur background)
- **Filters**: Subtle, natural filters only
- **Grid & Level**: Helpers cho composition
- **Quick Share**: Chụp xong chọn album ngay

**After Capture**:
- **Auto-enhance**: Optional AI enhancement
- **Quick Edit**: Crop, rotate, adjust exposure
- **Add to Multiple Albums**: One photo, many albums
- **Save Original**: Always keep unedited version

## 4. Advanced Features

### 4.1 Smart Features

**AI-Powered**:
- **Face Recognition**: Auto-tag people trong ảnh
- **Scene Detection**: Beach, mountain, food, etc.
- **Quality Filter**: Suggest best photos, hide blurry ones
- **Auto Albums**: Group photos by events/trips
- **Search**: Natural language search ("photos at the beach last summer")

### 4.2 Notification System

**Notification Types**:
- **Social**: Friend requests, new comments, likes
- **Albums**: Invited to album, new photos in album
- **Memories**: On this day, weekly recap
- **System**: Storage full, backup complete

**Customization**:
- **Per Album**: Mute specific albums
- **Quiet Hours**: No notifications 10pm-7am
- **Priority Friends**: Always notify for certain people
- **Digest Mode**: Daily summary instead of instant

### 4.3 Privacy & Security

**Privacy Features**:
- **Album Passwords**: Extra protection cho sensitive albums
- **Hidden Albums**: Không hiện trong main view
- **Guest Mode**: Temporary access cho non-users
- **Data Export**: Download all data bất cứ lúc nào
- **Account Deletion**: Complete data removal trong 30 days

**Security Measures**:
- **End-to-end Encryption**: Cho private messages (future)
- **2FA Options**: SMS, TOTP, Backup codes
- **Login Alerts**: Email khi login từ new device
- **Session Management**: View và revoke active sessions
- **Report & Block**: Report inappropriate content

### 4.4 Storage & Sync

**Storage Options**:
- **Free Tier**: 5GB (khoảng 2,500 photos)
- **Premium**: 100GB, 1TB options
- **Smart Storage**: Auto-delete backed up photos từ device

**Sync Features**:
- **Auto Backup**: When on WiFi và charging
- **Selective Sync**: Choose which albums to backup
- **Quality Options**: Original hoặc compressed
- **Cross-Device**: Seamless experience across devices

## 5. Business Model & Monetization

### 5.1 Freemium Model

**Free Features**:
- Unlimited albums với up to 5 participants each
- 5GB storage
- Basic editing tools
- Standard quality backups

**Premium Features** ($4.99/month):
- Unlimited album participants
- 100GB storage
- Advanced editing tools
- Original quality backups
- Priority support
- No ads (future consideration)

**Family Plan** ($9.99/month):
- 5 accounts
- 500GB shared storage
- Family album templates
- Group video calls (future)

### 5.2 Additional Revenue Streams

- **Photo Printing**: Order prints, photobooks
- **Cloud Storage**: Extra storage beyond plans
- **Premium Filters**: Professional filter packs
- **Event Services**: Wedding/event photo sharing solutions

## 6. Technical Requirements for Backend

### 6.1 Performance Requirements

**Response Times**:
- API calls: < 200ms average
- Image upload: < 3s for 5MB photo
- Image load: < 1s for full resolution
- Timeline load: < 500ms for 50 photos

**Scalability**:
- Support 100K concurrent users
- 1M photos uploaded daily
- 10M API requests per hour
- Auto-scale based on load

### 6.2 Data Requirements

**User Data**:
- Profile changes audited
- Soft delete với 30-day recovery
- GDPR compliant data handling
- Regular backups (hourly)

**Photo Data**:
- Multiple resolutions generated
- CDN distribution
- Lazy loading support
- Progressive image loading

### 6.3 Real-time Features

**WebSocket Events**:
- New photo in album
- Friend online/offline
- New comment/like
- Friend request received
- Album invitation

**Push Notifications**:
- iOS: APNS
- Android: FCM
- Web: Web Push API
- Email: Fallback for important events

### 6.4 Integration Requirements

**Third-party Services**:
- **AWS S3/CloudFront**: Photo storage và CDN
- **Google Vision API**: Face detection, scene recognition
- **SendGrid**: Email notifications
- **Twilio**: SMS cho 2FA
- **Stripe**: Payment processing
- **Sentry**: Error tracking
- **MixPanel**: Analytics

## 7. API Design Principles

### 7.1 RESTful Design
- Consistent resource naming
- Proper HTTP methods
- Meaningful status codes
- HATEOAS where applicable

### 7.2 Versioning
- URL versioning (/api/v1/)
- Backward compatibility cho 2 versions
- Deprecation warnings
- Migration guides

### 7.3 Authentication
- Bearer token trong headers
- Refresh token rotation
- Rate limiting per user
- API keys cho enterprise

### 7.4 Response Format
```json
{
  "success": true,
  "data": {},
  "meta": {
    "pagination": {},
    "timestamp": "2024-01-01T00:00:00Z"
  },
  "errors": []
}
```

## 8. Content Moderation

### 8.1 Automated Moderation
- **NSFW Detection**: Sử dụng ML models
- **Violence Detection**: Block violent content
- **Text Filtering**: Cho comments và captions
- **Spam Detection**: Prevent spam uploads

### 8.2 User Reporting
- **Report Types**: Inappropriate, Spam, Copyright
- **Quick Response**: < 24h for reviews
- **Appeals Process**: User có thể appeal
- **Transparency**: Clear community guidelines

## 9. Future Roadmap

### Phase 1 (MVP - Current)
- Core photo sharing
- Albums và friends
- Basic timeline
- Email/Google auth

### Phase 2 (6 months)
- Stories feature
- AI-powered search
- Video support (short clips)
- iOS/Android apps

### Phase 3 (1 year)
- End-to-end encryption
- Family accounts
- Photo printing
- Advanced editing

### Phase 4 (18 months)
- Video calls trong albums
- Collaborative editing
- AR filters
- Global shared albums

## 10. Competitive Advantages

### 10.1 Vs Instagram
- Privacy-first approach
- No public metrics (likes, followers)
- Ad-free experience
- Focus on close connections

### 10.2 Vs Google Photos
- Social features built-in
- Better album collaboration
- Intimate sharing options
- Curated experience

### 10.3 Vs Family Apps
- Modern UI/UX
- Youth-friendly features
- Not limited to families
- Better performance

## 11. Success Metrics

### 11.1 User Metrics
- **MAU**: Monthly Active Users
- **DAU/MAU**: Stickiness ratio > 50%
- **Retention**: D30 retention > 40%
- **Engagement**: 3+ sessions per week

### 11.2 Business Metrics
- **Conversion**: Free to Premium > 10%
- **ARPU**: Average Revenue Per User
- **CAC**: Customer Acquisition Cost < $10
- **LTV**: Lifetime Value > $100

### 11.3 Technical Metrics
- **Uptime**: 99.9% SLA
- **Response Time**: p95 < 500ms
- **Error Rate**: < 0.1%
- **Storage Efficiency**: 60% compression

## 12. Localization & Compliance

### 12.1 Multi-language Support
- **Initial**: English, Vietnamese, Spanish
- **Phase 2**: French, German, Japanese
- **RTL Support**: Arabic, Hebrew
- **Date/Time**: Local formats

### 12.2 Legal Compliance
- **GDPR**: EU data protection
- **COPPA**: Children's privacy
- **CCPA**: California privacy
- **Local Laws**: Per-country requirements

### 12.3 Content Guidelines
- **Age Restrictions**: 13+ years old
- **Content Types**: Family-friendly
- **Copyright**: DMCA compliance
- **Terms of Service**: Clear và fair

---

## Tổng kết cho Backend Developer

Khi phát triển backend cho Memore, hãy tập trung vào:

1. **Privacy & Security**: Đây là core value, mọi feature phải privacy-first
2. **Performance**: Photo apps cần fast loading, efficient storage
3. **Scalability**: Design cho growth từ đầu
4. **Real-time**: Many features need real-time updates
5. **Mobile-first**: API phải optimize cho mobile (batching, caching)
6. **Simplicity**: Features phức tạp nhưng API phải simple
7. **Reliability**: Photo memories are precious, không được mất data

Backend cần hỗ trợ một ứng dụng tạo ra môi trường an toàn, thân mật để mọi người chia sẻ những khoảnh khắc quan trọng mà không cần lo lắng về privacy hay áp lực social media.