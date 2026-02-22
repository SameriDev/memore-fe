# Changelog

## [2026-02-22] Kết nối Mock Data → Real API

Thay thế toàn bộ mock data trong FE bằng real API calls tới Spring Boot BE. Khi API lỗi hoặc BE offline, app hiển thị empty state thay vì fallback mock.

### File tạo mới

#### DTOs (`data/models/`)
- **`album_dto.dart`** — Parse JSON từ `/api/albums`, convert sang `Album` entity với tính toán `timeAgo` từ `createdAt`
- **`friendship_dto.dart`** — Parse JSON từ `/api/friendships`, `toEntity(currentUserId)` xác định "người kia" trong quan hệ bạn bè
- **`story_dto.dart`** — Parse JSON từ `/api/stories`, dùng pravatar placeholder cho avatar

#### Remote Services (`data/data_sources/remote/`)
- **`album_service.dart`** — `getUserAlbums(userId)` gọi `GET /api/albums/user/{userId}`
- **`friendship_service.dart`** — `getUserFriends`, `getPendingRequests`, `sendRequest`, `acceptRequest`
- **`story_service.dart`** — `getActiveStories`, `getUserStories`

### File đã sửa

| File | Thay đổi |
|------|----------|
| `presentation/screens/home/home_screen.dart` | Xóa `MockAlbumsData`, thêm `_loadStoriesAndAlbums()` gọi `StoryService` + `AlbumService` song song via `Future.wait`, prepend "Add Story" button |
| `presentation/screens/friends/friends_list_screen.dart` | Xóa `MockFriendsData`, thêm `_loadFriends()` từ `FriendshipService`, thêm `isLoading` state |
| `presentation/screens/timeline/timeline_screen.dart` | Xóa toàn bộ `_mockTimelineItems` (8 items mock), chỉ hiển thị real photos, lỗi → empty state |
| `data/local/user_manager.dart` | `updateProfile()` thêm fire-and-forget sync tới BE qua `UserService.updateUser()` |

### API Endpoints sử dụng

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/api/albums/user/{userId}` | Lấy albums của user |
| GET | `/api/friendships/user/{userId}` | Lấy danh sách bạn bè |
| GET | `/api/friendships/pending/{userId}` | Lấy lời mời kết bạn đang chờ |
| POST | `/api/friendships` | Gửi lời mời kết bạn |
| PUT | `/api/friendships/{id}/accept` | Chấp nhận lời mời |
| GET | `/api/stories/active` | Lấy stories đang active |
| GET | `/api/stories/user/{userId}` | Lấy stories của user |

### Verification
1. `flutter analyze` — 0 error, không có warning mới
2. HomeScreen load albums/stories từ BE
3. FriendsListScreen load friends từ API
4. TimelineScreen không còn mock items
5. Profile edit sync tới BE qua fire-and-forget
