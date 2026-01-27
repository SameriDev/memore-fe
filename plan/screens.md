# MÔ TÃ CÁC MÀN HÌNH ỨNG DỤNG LOCKET WIDGET

## 1. MÀNG ONBOARDING

### 1.1. Màn Welcome/Download

- Tên màn: Welcome Screen
- Chức năng: Màn hình chào mừng khi người dùng mới tải app
- Các thành phần:
  - Logo và tên ứng dụng Locket
  - Mô tả ngắn về app
  - Nút "Get Started" hoặc "Continue": Chuyển sang màn Sign Up/Sign In
- Giao diện: Giao diện đơn giản, tập trung vào logo, sử dụng màu sắc chủ đạo của brand, có hình minh họa về widget

### 1.2. Màn Sign Up/Sign In

- Tên màn: Authentication Screen
- Chức năng: Đăng ký tài khoản mới hoặc đăng nhập
- Các thành phần:
  - Tab hoặc toggle chuyển đổi giữa Sign Up và Sign In
  - Form đăng ký gồm:
    - Ô nhập Email
    - Ô nhập Password (tối thiểu 8 ký tự)
    - Ô nhập First Name
    - Ô nhập Last Name
    - Ô nhập Username (unique)
    - Có thể có: Ô nhập Phone Number để verify
  - Nút "Sign Up" hoặc "Create Account": Chuyển sang màn Permission Request
  - Link "Already have an account? Sign In": Chuyển sang form đăng nhập
- Giao diện: Form đơn giản, rõ ràng, có validation cho từng trường input, màu nền sáng hoặc tối tùy theme

### 1.3. Màn Permission Request

- Tên màn: Permissions Screen
- Chức năng: Yêu cầu các quyền cần thiết
- Các thành phần:
  - Mô tả lý do cần các quyền
  - Nút "Allow Camera Access": Mở popup xin quyền camera của hệ thống
  - Nút "Allow Contacts Access": Mở popup xin quyền truy cập danh bạ
  - Nút "Allow Notifications": Mở popup xin quyền thông báo
  - Nút "Continue" hoặc "Next": Chuyển sang màn Add Friends
  - Link "Skip for now" (tùy chọn): Chuyển luôn sang màn Add Widget
- Giao diện: Có icon minh họa cho từng quyền, giải thích rõ ràng tại sao cần quyền đó

### 1.4. Màn Add Friends

- Tên màn: Add Friends Screen
- Chức năng: Thêm bạn bè để bắt đầu chia sẻ
- Các thành phần:
  - Danh sách gợi ý bạn bè từ danh bạ (nếu đã cấp quyền)
  - Ô tìm kiếm bạn bè theo username/email
  - Nút "Add" bên cạnh mỗi người: Gửi lời mời kết bạn
  - Nút "Invite Friends": Mở share sheet để mời qua Instagram, Snapchat, WhatsApp, SMS, email
  - Nút "Continue" hoặc "Done": Chuyển sang màn Add Widget (cần ít nhất 1-5 bạn để tiếp tục)
  - Link "Skip": Chuyển sang màn Add Widget
- Giao diện: Danh sách cuộn được, avatar và tên hiển thị rõ ràng, có trạng thái Added/Pending

### 1.5. Màn Add Widget Tutorial

- Tên màn: Widget Setup Screen
- Chức năng: Hướng dẫn thêm widget vào home screen
- Các thành phần:
  - Hướng dẫn từng bước với hình minh họa hoặc GIF:
    - iOS: Long press home screen → Tap + icon → Search Locket → Add Widget
    - Android: Long press home screen → Select Widgets → Find Locket → Drag to home screen
  - Dropdown hoặc tabs chọn kích thước widget (Small, Medium, Large)
  - Nút "Open Home Screen": Minimize app để người dùng thực hiện
  - Nút "I've Added It" hoặc "Finish": Chuyển sang màn Home/Camera
  - Link "Skip for now": Chuyển sang màn Home/Camera
- Giao diện: Hướng dẫn trực quan, có animation hoặc video ngắn, dễ theo dõi

## 2. MÀN HÌNH CHÍNH

### 2.1. Màn Home/Camera

- Tên màn: Main Camera Screen
- Chức năng: Màn hình chính để chụp và gửi ảnh
- Các thành phần:
  - Camera viewfinder toàn màn hình (live preview)
  - Nút chụp ảnh lớn ở giữa dưới cùng (nút tròn màu trắng): Chụp ảnh và gửi ngay cho bạn bè
  - Nút toggle flash ở bên trái nút chụp (icon lightning bolt): Bật/tắt đèn flash
  - Nút đảo camera ở bên phải nút chụp (icon arrow hoặc camera flip): Chuyển đổi giữa camera trước và sau
  - Icon profile ở góc trên trái: Chuyển sang màn Profile
  - Icon notification hoặc inbox ở góc trên phải: Chuyển sang màn Notifications/Messages
  - Tab bar ở dưới cùng (nếu có):
    - Tab Camera (active)
    - Tab History: Chuyển sang màn History
    - Tab Friends: Chuyển sang màn Friends List
    - Tab Profile: Chuyển sang màn Profile
- Giao diện: Fullscreen camera view, UI tối giản để tập trung vào camera, các nút overlay có màu tương phản rõ ràng

### 2.2. Màn Photo Preview

- Tên màn: Photo Preview Screen
- Chức năng: Xem trước ảnh vừa chụp trước khi gửi
- Các thành phần:
  - Ảnh preview toàn màn hình
  - Ô nhập text để thêm caption/message (tùy chọn)
  - Nút "Send" hoặc "Share": Gửi ảnh cho tất cả bạn bè, quay về màn Camera
  - Nút "Retake" hoặc icon X: Hủy và quay lại màn Camera để chụp lại
  - Filter hoặc sticker options (nếu có): Mở menu chỉnh sửa đơn giản
- Giao diện: Ảnh chiếm phần lớn màn hình, các nút action rõ ràng ở phía dưới

## 3. MÀN HÌNH LỊCH SỬ VÀ XEM ẢNH

### 3.1. Màn History/Feed

- Tên màn: Locket History Screen
- Chức năng: Xem lại tất cả ảnh đã gửi và nhận
- Các thành phần:
  - Grid hoặc timeline hiển thị các ảnh theo thời gian (mới nhất trước)
  - Mỗi ảnh hiển thị thumbnail, tên người gửi, thời gian
  - Tap vào ảnh: Mở màn Photo Detail
  - Nút filter (tùy chọn): Lọc theo người gửi, ngày tháng
  - Nút "Create Recap": Chuyển sang màn Create Recap Video
  - Tab "Sent" và "Received": Chuyển đổi giữa ảnh đã gửi và đã nhận
  - Nút back hoặc tab bar: Quay về màn Camera
- Giao diện: Grid layout 2-3 cột, cuộn dọc mượt mà, có thumbnail rõ nét

### 3.2. Màn Photo Detail

- Tên màn: Photo Detail Screen
- Chức năng: Xem chi tiết một ảnh cụ thể
- Các thành phần:
  - Ảnh fullscreen
  - Tên người gửi và thời gian ở trên hoặc dưới ảnh
  - Caption/message nếu có
  - Nút reaction (emoji): Mở bảng emoji để react
  - Danh sách reactions hiện có từ bạn bè
  - Nút "Reply": Mở ô nhập text để reply, gửi reply
  - Nút "Delete" (nếu là ảnh của mình): Xóa ảnh, quay lại màn History
  - Nút "Save to Gallery": Lưu ảnh vào thư viện điện thoại
  - Nút back hoặc swipe down: Quay lại màn History
  - Swipe left/right: Xem ảnh trước/sau trong history
- Giao diện: Ảnh chiếm toàn bộ màn hình, info và actions overlay có thể toggle ẩn/hiện

### 3.3. Màn Create Recap Video

- Tên màn: Recap Video Screen
- Chức năng: Tạo video recap từ các ảnh
- Các thành phần:
  - Preview của video recap
  - Chọn khoảng thời gian (monthly recap tự động hoặc custom range)
  - Chọn ảnh để thêm vào recap (multi-select)
  - Chọn nhạc nền (tùy chọn)
  - Nút "Generate" hoặc "Create": Tạo video
  - Nút "Save" hoặc "Share": Lưu hoặc chia sẻ video, quay về màn History
  - Nút "Cancel": Quay lại màn History
- Giao diện: Có timeline để chọn ảnh, preview video ở trên, options ở dưới

## 4. MÀN HÌNH BẠN BÈ

### 4.1. Màn Friends List

- Tên màn: Friends Screen
- Chức năng: Quản lý danh sách bạn bè
- Các thành phần:
  - Danh sách tất cả bạn bè hiện tại với avatar, username, last active
  - Tab "Friends" và "Pending": Chuyển đổi giữa bạn bè đã kết nối và lời mời đang chờ
  - Nút "Add Friends" ở góc trên phải: Chuyển sang màn Add Friends
  - Tap vào một người bạn: Chuyển sang màn Friend Profile
  - Swipe left trên một người bạn: Hiện nút Remove/Block
  - Ô tìm kiếm ở trên: Tìm kiếm trong danh sách bạn bè
  - Tab Pending hiển thị:
    - Friend requests received: Nút Accept/Decline
    - Friend requests sent: Nút Cancel Request
  - Nút back hoặc tab bar: Quay về màn Camera
- Giao diện: List view, có divider giữa các item, avatar tròn bên trái, tên và info bên phải

### 4.2. Màn Friend Profile

- Tên màn: Friend Detail Screen
- Chức năng: Xem thông tin và ảnh của một người bạn cụ thể
- Các thành phần:
  - Avatar và username của bạn
  - Grid ảnh của bạn đó đã gửi cho mình
  - Tap vào ảnh: Mở màn Photo Detail
  - Nút "Send Photo": Chuyển về màn Camera để chụp ảnh gửi riêng cho người này (nếu có tính năng)
  - Nút "Remove Friend": Hiện popup confirm, sau khi confirm quay về màn Friends List
  - Nút "Block": Hiện popup confirm, sau khi confirm quay về màn Friends List
  - Nút back: Quay lại màn Friends List
- Giao diện: Header có avatar lớn và username, phía dưới là grid ảnh tương tự màn History

### 4.3. Màn Add Friends (từ màn Friends List)

- Tên màn: Search Friends Screen
- Chức năng: Tìm và thêm bạn mới (tương tự màn Add Friends trong onboarding nhưng có thể truy cập bất cứ lúc nào)
- Các thành phần: (Giống màn 1.4)
  - Ô tìm kiếm username/email
  - Danh sách kết quả tìm kiếm hoặc suggestions
  - Nút Add bên cạnh mỗi người
  - Nút "Invite Friends": Mở share sheet
  - Nút back: Quay lại màn Friends List
- Giao diện: Focus vào search bar ở trên, kết quả hiển thị dạng list ở dưới

## 5. MÀN HÌNH THÔNG BÁO VÀ TIN NHẮN

### 5.1. Màn Notifications

- Tên màn: Notifications Screen
- Chức năng: Xem các thông báo về ảnh mới, reactions, friend requests
- Các thành phần:
  - Danh sách thông báo theo thời gian (mới nhất trên cùng)
  - Mỗi notification hiển thị:
    - Loại thông báo (new photo, reaction, friend request, etc.)
    - Avatar người gửi
    - Nội dung ngắn gọn
    - Thời gian
  - Tap vào notification:
    - Nếu là new photo: Chuyển sang màn Photo Detail
    - Nếu là friend request: Chuyển sang màn Friends List tab Pending
    - Nếu là reaction: Chuyển sang màn Photo Detail của ảnh được react
  - Nút "Mark all as read": Đánh dấu tất cả đã đọc
  - Nút back: Quay về màn Camera
- Giao diện: List view, thông báo chưa đọc highlight hoặc bold, có icon cho từng loại thông báo

### 5.2. Màn Messages (nếu có)

- Tên màn: Messages/Chat Screen
- Chức năng: Xem tin nhắn reply gắn với ảnh
- Các thành phần:
  - Danh sách conversations với từng người bạn
  - Tap vào conversation: Chuyển sang màn Chat Detail
  - Preview tin nhắn cuối cùng và ảnh liên quan
  - Nút back: Quay về màn Camera
- Giao diện: List view giống màn Friends, có thumbnail ảnh kèm theo preview text

### 5.3. Màn Chat Detail

- Tên màn: Conversation Screen
- Chức năng: Xem chi tiết cuộc trò chuyện với một người
- Các thành phần:
  - Thread hiển thị ảnh và replies theo thời gian
  - Mỗi message bubble chứa ảnh và text reply
  - Tap vào ảnh: Xem fullscreen ảnh đó
  - Ô nhập text ở dưới: Nhập reply
  - Nút send bên cạnh ô nhập: Gửi reply
  - Nút back: Quay lại màn Messages
- Giao diện: Chat thread layout, ảnh inline trong conversation, bubble messages với màu khác nhau cho sent/received

## 6. MÀN HÌNH CÁ NHÂN

### 6.1. Màn Profile

- Tên màn: Profile Screen
- Chức năng: Xem và chỉnh sửa thông tin cá nhân, cài đặt
- Các thành phần:
  - Avatar lớn ở trên cùng
  - Tap vào avatar: Mở popup chọn "Take Photo" hoặc "Choose from Library", sau khi chọn update avatar
  - Username hiển thị rõ
  - Email hiển thị
  - Nút "Edit Profile": Chuyển sang màn Edit Profile
  - Danh sách các options:
    - "Locket Gold": Chuyển sang màn Subscription/Premium
    - "Widget Tutorial": Chuyển sang màn Add Widget Tutorial
    - "Invite Friends": Mở share sheet
    - "Privacy Settings": Chuyển sang màn Privacy Settings
    - "Notifications": Chuyển sang màn Notification Settings
    - "Blocked Users": Chuyển sang màn Blocked Users List
    - "About": Chuyển sang màn About
    - "Help & Support": Mở màn Help hoặc link đến website
    - "Rate App": Mở App Store/Play Store rating
    - "Share Profile": Mở share sheet với profile link
    - "Sign Out": Hiện popup confirm, sau khi confirm quay về màn Sign In
    - "Delete Account": Hiện popup confirm, sau khi confirm xóa tài khoản và quay về màn Welcome
  - Nút back hoặc tab bar: Quay về màn Camera
- Giao diện: Header có avatar và info, phía dưới là list các options với icon và chevron right, sử dụng divider hoặc section headers

### 6.2. Màn Edit Profile

- Tên màn: Edit Profile Screen
- Chức năng: Chỉnh sửa thông tin cá nhân
- Các thành phần:
  - Ô nhập Username (có validation unique)
  - Ô nhập Email
  - Ô nhập First Name
  - Ô nhập Last Name
  - Nút "Save Changes": Lưu và quay về màn Profile
  - Nút "Cancel" hoặc back: Quay về màn Profile không lưu
- Giao diện: Form đơn giản, các ô input có label rõ ràng, nút Save nổi bật

### 6.3. Màn Privacy Settings

- Tên màn: Privacy Settings Screen
- Chức năng: Cài đặt quyền riêng tư
- Các thành phần:
  - Toggle "Private Account": Bật/tắt chế độ riêng tư (không tìm được bằng username)
  - Dropdown hoặc radio "Who can send me photos": All Friends / Selected Friends
  - Nếu chọn Selected Friends: Chuyển sang màn Select Friends để chọn cụ thể
  - Toggle "Hide from History": Ẩn ảnh của mình khỏi Locket History của người khác
  - Nút "Save" hoặc auto-save
  - Nút back: Quay về màn Profile
- Giao diện: List các toggle và dropdown, clear labels và descriptions

### 6.4. Màn Notification Settings

- Tên màn: Notification Settings Screen
- Chức năng: Cài đặt thông báo
- Các thành phần:
  - Toggle "Enable Notifications": Master toggle
  - Toggle "New Photos": Thông báo khi có ảnh mới
  - Toggle "Friend Requests": Thông báo khi có lời mời kết bạn
  - Toggle "Reactions": Thông báo khi có người react
  - Toggle "Replies": Thông báo khi có người reply
  - Toggle "Rollcall Reminders": Thông báo nhắc Rollcall
  - Nút back: Quay về màn Profile
- Giao diện: List các toggle settings, group theo categories nếu nhiều

### 6.5. Màn Blocked Users

- Tên màn: Blocked Users Screen
- Chức năng: Quản lý danh sách người dùng đã chặn
- Các thành phần:
  - Danh sách người dùng đã block với avatar và username
  - Nút "Unblock" bên cạnh mỗi người: Unblock user, xóa khỏi danh sách
  - Empty state nếu chưa block ai: "No blocked users"
  - Nút back: Quay về màn Profile
- Giao diện: List view đơn giản, có action button rõ ràng

### 6.6. Màn About

- Tên màn: About Screen
- Chức năng: Thông tin về app
- Các thành phần:
  - Logo Locket
  - Version number
  - Links đến:
    - Website
    - Instagram
    - Twitter/X
    - TikTok
    - Privacy Policy: Mở webview hoặc browser
    - Terms of Service: Mở webview hoặc browser
  - Nút back: Quay về màn Profile
- Giao diện: Centered logo, version text, list các links với icons

### 6.7. Màn Subscription (Locket Gold)

- Tên màn: Premium/Locket Gold Screen
- Chức năng: Hiển thị các gói premium và cho phép mua
- Các thành phần:
  - Danh sách tính năng premium:
    - Remove ads
    - Unlimited friends (vượt quá limit 20 người)
    - Exclusive widgets
    - Early access to new features
  - Các gói giá (monthly, yearly) với giá
  - Nút "Subscribe" cho mỗi gói: Mở payment flow của App Store/Play Store
  - Nút "Restore Purchase": Khôi phục mua hàng trước đó
  - Link "Terms and Conditions"
  - Nút close hoặc back: Quay về màn Profile
- Giao diện: Bắt mắt, highlight benefits, pricing cards rõ ràng với CTA buttons nổi bật

## 7. MÀN HÌNH TÍNH NĂNG ĐẶC BIỆT

### 7.1. Màn Rollcall

- Tên màn: Rollcall/Weekly Dump Screen
- Chức năng: Upload tuyển tập ảnh trong tuần vào mỗi Chủ Nhật
- Các thành phần:
  - Grid để chọn nhiều ảnh từ thư viện điện thoại
  - Nút "Select Photos": Mở photo picker
  - Preview các ảnh đã chọn
  - Nút "Upload" hoặc "Post": Upload Rollcall, quay về màn Camera hoặc History
  - Timer hoặc text "7 days remaining": Hiển thị thời gian còn lại của Rollcall hiện tại
  - Nút "Cancel": Quay về màn trước đó
- Giao diện: Grid layout để chọn ảnh, có indicator cho số ảnh đã chọn, preview rõ ràng

### 7.2. Màn View Rollcall

- Tên màn: Rollcall Viewer Screen
- Chức năng: Xem Rollcall của bạn bè
- Các thành phần:
  - Slideshow hoặc grid các ảnh trong Rollcall
  - Avatar và username của người post
  - Thời gian post
  - Countdown "Disappears in X days"
  - Nút reaction hoặc like
  - Swipe để xem ảnh tiếp theo trong Rollcall
  - Nút back: Quay về màn History hoặc Feed
- Giao diện: Fullscreen ảnh với info overlay, có navigation dots hoặc pagination

### 7.3. Màn Celebrity Lockets

- Tên màn: Celebrity Feed Screen
- Chức năng: Xem và follow các celebrity Lockets
- Các thành phần:
  - Danh sách celebrities có thể follow với avatar, tên, verified badge
  - Nút "Follow" bên cạnh mỗi celebrity: Follow và nhận updates
  - Tab "Suggested" và "Following": Chuyển đổi giữa gợi ý và đang follow
  - Tap vào một celebrity: Xem profile và ảnh của họ
  - Ô tìm kiếm celebrities
  - Nút back: Quay về màn Camera hoặc Profile
- Giao diện: List hoặc grid layout, có verified badge nổi bật, preview ảnh gần đây của celebrity

### 7.4. Màn Celebrity Profile

- Tên màn: Celebrity Detail Screen
- Chức năng: Xem profile và nội dung của celebrity
- Các thành phần:
  - Avatar lớn và tên celebrity với verified badge
  - Bio/description
  - Grid các ảnh/updates từ celebrity
  - Tap vào ảnh: Xem fullscreen
  - Nút "Follow/Unfollow": Toggle follow status
  - Số followers
  - Nút back: Quay về màn Celebrity Lockets
- Giao diện: Profile layout professional, grid ảnh curated, highlight verified status

## 8. MÀN HÌNH PHỤ KHÁC

### 8.1. Màn Loading/Splash

- Tên màn: Splash Screen
- Chức năng: Màn hình khởi động khi mở app
- Các thành phần:
  - Logo Locket
  - Loading indicator hoặc animation
  - Tự động chuyển sang:
    - Màn Welcome nếu chưa đăng nhập
    - Màn Camera nếu đã đăng nhập
- Giao diện: Đơn giản, logo centered, background solid color hoặc gradient

### 8.2. Popup/Modal Confirmation

- Tên màn: Confirmation Dialog
- Chức năng: Xác nhận các hành động quan trọng
- Các thành phần:
  - Tiêu đề cảnh báo
  - Nội dung mô tả
  - Nút "Confirm" hoặc "Yes": Thực hiện hành động
  - Nút "Cancel" hoặc "No": Đóng popup và không làm gì
- Sử dụng cho: Delete account, Sign out, Remove friend, Block user, Delete photo
- Giao diện: Modal overlay với blur background, centered dialog, buttons rõ ràng (destructive action màu đỏ)

### 8.3. Màn Error/Empty State

- Tên màn: Error Screen / Empty State
- Chức năng: Hiển thị khi có lỗi hoặc không có dữ liệu
- Các thành phần:
  - Icon hoặc illustration cho trạng thái (no data, error, no connection)
  - Message text giải thích
  - Nút "Retry" hoặc "Refresh": Thử lại action
  - Nút "Go Back": Quay về màn trước
- Sử dụng cho: Network error, Empty history, No friends, No notifications
- Giao diện: Centered content, friendly illustration, clear actionable buttons

### 8.4. Màn Photo Picker (System)

- Tên màn: Photo Library Picker
- Chức năng: Chọn ảnh từ thư viện để upload vào Rollcall hoặc đổi avatar
- Các thành phần:
  - Grid tất cả ảnh trong thư viện (sử dụng system picker của iOS/Android)
  - Albums dropdown để chọn album
  - Multi-select hoặc single-select tùy context
  - Nút "Done" hoặc "Select": Xác nhận chọn ảnh và quay về màn trước
  - Nút "Cancel": Đóng picker
- Giao diện: Native system UI cho photo picker

### 8.5. Màn Share Sheet (System)

- Tên màn: Share Dialog
- Chức năng: Chia sẻ profile, invite friends qua các platform khác
- Các thành phần:
  - Danh sách các app có thể share đến (Messages, Instagram, WhatsApp, Email, etc.)
  - Tap vào app: Mở app đó với pre-filled content
  - Nút "Cancel": Đóng share sheet
- Giao diện: Native system UI cho share sheet

### 8.6. Màn Help/Support

- Tên màn: Help Center Screen
- Chức năng: FAQs và support
- Các thành phần:
  - Danh sách FAQs có thể expand/collapse
  - Ô tìm kiếm help topics
  - Nút "Contact Support": Mở email hoặc form liên hệ
  - Links đến tutorial videos
  - Nút back: Quay về màn Profile
- Giao diện: Accordion list cho FAQs, có search bar ở trên, links rõ ràng
