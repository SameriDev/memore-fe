# Danh Sách Màn Hình Cần Implement

## Tổng Quan

- Đã hoàn thành: 11/28 màn hình (39%)
- Còn thiếu: 17/28 màn hình (61%)

## 1. Authentication Flow (2/5 hoàn thành)

### Đã implement

- EmailInputScreen (lib/presentation/screens/auth/email_input_screen.dart)
- PasswordSetupScreen (lib/presentation/screens/auth/password_setup_screen.dart)
- NameSetupScreen (lib/presentation/screens/auth/name_setup_screen.dart)

### Cần implement

- **AuthScreen** (lib/presentation/screens/auth/auth_screen.dart)
  - Màn hình chính của authentication
  - Hiện đang dùng placeholder trong main.dart
  - Route: /auth

- **SignInScreen** (lib/presentation/screens/auth/sign_in_screen.dart)
  - Màn hình đăng nhập cho người dùng đã có tài khoản
  - Hiện đang dùng placeholder trong main.dart
  - Route: /auth/sign-in

## 2. Camera Flow (1/3 hoàn thành)

### Đã implement

- CameraScreen (lib/presentation/screens/camera/camera_screen.dart)

### Cần implement

- **PhotoPreviewScreen** (lib/presentation/screens/camera/photo_preview_screen.dart)
  - Xem trước ảnh sau khi chụp
  - Cho phép chỉnh sửa, thêm caption
  - Route: /camera/photo-preview?photoPath=...

- **FriendSelectScreen** (lib/presentation/screens/camera/friend_select_screen.dart)
  - Chọn bạn bè để gửi ảnh
  - Hiển thị danh sách bạn bè với checkbox
  - Route: /camera/friend-select?photoPath=...

## 3. Friends Flow (2/4 hoàn thành)

### Đã implement

- FriendsListScreen (lib/presentation/screens/friends/friends_list_screen.dart)
- AddFriendScreen (lib/presentation/screens/friends/add_friend_screen.dart)

### Cần implement

- **FriendProfileScreen** (lib/presentation/screens/friends/friend_profile_screen.dart)
  - Xem thông tin chi tiết bạn bè
  - Hiển thị ảnh đã chia sẻ
  - Tùy chọn xóa bạn hoặc chặn
  - Route: /friends/profile?friendId=...

- **FriendRequestsScreen** (lib/presentation/screens/friends/friend_requests_screen.dart)
  - Danh sách lời mời kết bạn
  - Chấp nhận hoặc từ chối yêu cầu
  - Route: /friends/requests

## 4. Photo Feed Flow (0/3 hoàn thành)

### Cần implement

- **PhotoFeedScreen** (lib/presentation/screens/photos/photo_feed_screen.dart)
  - Hiển thị feed ảnh từ bạn bè
  - Grid layout với ảnh thumbnail
  - Route: /photos

- **PhotoViewScreen** (lib/presentation/screens/photos/photo_view_screen.dart)
  - Xem ảnh full size
  - Hiển thị thông tin người gửi, thời gian
  - Tùy chọn react, comment
  - Route: /photos/view?photoId=...

- **TimeTravelScreen** (lib/presentation/screens/photos/time_travel_screen.dart)
  - Xem lại ảnh theo timeline
  - Filter theo ngày, tuần, tháng
  - Route: /photos/time-travel

## 5. Settings Flow (1/8 hoàn thành)

### Đã implement

- SettingsScreen (lib/presentation/screens/settings/settings_screen.dart)

### Cần implement

- **ProfileScreen** (lib/presentation/screens/settings/profile_screen.dart)
  - Xem thông tin profile cá nhân
  - Hiển thị avatar, tên, email
  - Route: /settings/profile

- **EditProfileScreen** (lib/presentation/screens/settings/edit_profile_screen.dart)
  - Chỉnh sửa thông tin cá nhân
  - Đổi avatar, tên hiển thị
  - Route: /settings/profile/edit

- **NotificationsScreen** (lib/presentation/screens/settings/notifications_screen.dart)
  - Cài đặt thông báo
  - Bật/tắt các loại thông báo
  - Route: /settings/notifications

- **PrivacyScreen** (lib/presentation/screens/settings/privacy_screen.dart)
  - Cài đặt quyền riêng tư
  - Quản lý ai có thể nhìn thấy ảnh
  - Route: /settings/privacy

- **BlockedUsersScreen** (lib/presentation/screens/settings/blocked_users_screen.dart)
  - Danh sách người dùng bị chặn
  - Bỏ chặn người dùng
  - Route: /settings/privacy/blocked

- **StorageScreen** (lib/presentation/screens/settings/storage_screen.dart)
  - Quản lý bộ nhớ
  - Xóa cache, ảnh cũ
  - Route: /settings/storage

- **AboutScreen** (lib/presentation/screens/settings/about_screen.dart)
  - Thông tin về ứng dụng
  - Phiên bản, điều khoản, chính sách
  - Route: /settings/about

## 6. Onboarding Flow (3/4 hoàn thành)

### Đã implement

- SplashScreen (lib/presentation/screens/onboarding/splash_screen.dart)
- WelcomeScreen (lib/presentation/screens/onboarding/welcome_screen.dart)
- WidgetDemoScreen (lib/presentation/screens/onboarding/widget_demo_screen.dart)

### Cần implement

- **OnboardingScreen** (lib/presentation/screens/onboarding/onboarding_screen.dart)
  - Màn hình giới thiệu tính năng
  - Swipe qua các slide giới thiệu
  - Route: /onboarding

## Cấu Trúc Thư Mục Cần Tạo

```
lib/presentation/screens/
├── auth/
│   ├── auth_screen.dart (CẦN TẠO)
│   ├── sign_in_screen.dart (CẦN TẠO)
├── camera/
│   ├── photo_preview_screen.dart (CẦN TẠO)
│   ├── friend_select_screen.dart (CẦN TẠO)
├── friends/
│   ├── friend_profile_screen.dart (CẦN TẠO)
│   ├── friend_requests_screen.dart (CẦN TẠO)
├── photos/ (THƯ MỤC MỚI - CẦN TẠO)
│   ├── photo_feed_screen.dart (CẦN TẠO)
│   ├── photo_view_screen.dart (CẦN TẠO)
│   ├── time_travel_screen.dart (CẦN TẠO)
├── settings/
│   ├── profile_screen.dart (CẦN TẠO)
│   ├── edit_profile_screen.dart (CẦN TẠO)
│   ├── notifications_screen.dart (CẦN TẠO)
│   ├── privacy_screen.dart (CẦN TẠO)
│   ├── blocked_users_screen.dart (CẦN TẠO)
│   ├── storage_screen.dart (CẦN TẠO)
│   ├── about_screen.dart (CẦN TẠO)
├── onboarding/
│   ├── onboarding_screen.dart (CẦN TẠO)
```

## Ghi Chú Kỹ Thuật

### Design Pattern Cần Tuân Thủ

- Sử dụng Riverpod để quản lý state
- Sử dụng GoRouter để điều hướng
- Tuân theo các constants đã định nghĩa trong:
  - lib/core/constants/app_colors.dart
  - lib/core/constants/app_sizes.dart
  - lib/core/constants/app_strings.dart
  - lib/core/constants/app_routes.dart

### Màu Sắc Chính

- Background chính: #000000 (đen)
- Màu accent: #FFD700 (vàng/gold)
- Text chính: #FFFFFF (trắng)
- Text phụ: #B3B3B3 (xám)
- Background phụ: #2A2A2A, #1A1A1A

### Navigation

- Sử dụng context.go() để điều hướng đến route mới
- Sử dụng context.pop() để quay lại
- Sử dụng context.push() nếu cần giữ stack

### State Management

- Sử dụng ConsumerWidget hoặc ConsumerStatefulWidget
- Đọc state bằng ref.watch() trong build method
- Thay đổi state bằng ref.read().notifier trong event handlers

### Cleanup After Implementation

Sau khi implement các màn hình, cần xóa các placeholder class trong lib/main.dart:

- OnboardingScreen (line 325-334)
- AuthScreen (line 338-347)
- SignInScreen (line 384-393)
- PhotoPreviewScreen (line 399-409)
- FriendSelectScreen (line 411-421)
- FriendsListScreen (line 423-432) - nếu đã có implementation riêng
- AddFriendScreen (line 434-443) - nếu đã có implementation riêng
- FriendProfileScreen (line 445-455)
- FriendRequestsScreen (line 457-466)
- PhotoFeedScreen (line 468-477)
- PhotoViewScreen (line 479-489)
- TimeTravelScreen (line 491-500)
- SettingsScreen (line 502-511) - nếu đã có implementation riêng
- ProfileScreen (line 513-522)
- EditProfileScreen (line 524-533)
- NotificationsScreen (line 535-544)
- PrivacyScreen (line 546-555)
- BlockedUsersScreen (line 557-566)
- StorageScreen (line 568-577)
- AboutScreen (line 579-588)
