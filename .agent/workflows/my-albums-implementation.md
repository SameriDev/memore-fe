---
description: Kế hoạch implementation màn My Albums
---

# Kế hoạch Implementation Màn My Albums

## Bước 1: Tạo Models

### 1.1 Album Model

Tạo file `lib/domain/entities/album.dart`

- id: String
- name: String
- coverImageUrl: String
- filesCount: int
- createdAt: DateTime
- participants: List<User>
- isFavorite: bool

### 1.2 Story Model

Tạo file `lib/domain/entities/story.dart`

- id: String
- userId: String
- userAvatar: String
- userName: String
- isAddButton: bool (để phân biệt nút Add Story)

## Bước 2: Tạo Widgets Components

### 2.1 Story Section Widget

Tạo file `lib/presentation/widgets/story_section.dart`

- Horizontal ListView các avatar tròn
- Avatar đầu tiên là nút Add với icon dấu cộng, background đen
- Các avatar khác có border xanh gradient
- Kích thước avatar: 64x64px

### 2.2 Album Header Widget

Tạo file `lib/presentation/widgets/album_header.dart`

- Text "My Albums" bên trái, font đậm, màu đen
- Icon search bên phải
- Icon add button (vòng tròn đen) bên phải

### 2.3 Filter Section Widget

Tạo file `lib/presentation/widgets/filter_section.dart`

- Icon filter 3 gạch ngang bên trái
- Horizontal scroll các filter chips
- Mỗi chip có text và icon X để xóa
- Background trắng, border rounded

### 2.4 Album Card Widget

Tạo file `lib/presentation/widgets/album_card.dart`

- Container với border radius 20
- Ảnh cover chiếm toàn bộ phần trên
- Icon heart favorite ở góc phải trên ảnh
- Phần thông tin bên dưới:
  - Tên album
  - Row hiển thị: số files, thời gian, avatar participants

### 2.5 Bottom Navigation Widget

Tạo file `lib/presentation/widgets/bottom_navigation.dart`

- 5 items: Home, Gallery, Center Button, Timeline, Profile
- Item Home active: vòng tròn đen background, icon trắng
- Item khác: icon đen, không background
- Center button: vòng tròng lớn màu vàng, nổi lên cao hơn
- Background trắng với shadow nhẹ

## Bước 3: Tạo Mock Data

Tạo file `lib/data/mock/mock_albums_data.dart`

- List mock albums với đầy đủ thông tin
- List mock stories
- Đảm bảo có đủ dữ liệu để test grid 2 cột

## Bước 4: Tạo Albums Screen

### 4.1 Cập nhật HomeScreen

Sửa file `lib/presentation/screens/home/home_screen.dart`

- Background màu be/kem nhạt (AppColors.lightBackground)
- SafeArea để tránh thanh status bar
- Column chứa các section:
  - Story Section (cố định)
  - Album Header (cố định)
  - Filter Section (cố định)
  - Expanded GridView Albums (scroll được)
- Bottom Navigation (cố định ở dưới)

### 4.2 GridView Albums

- GridView.builder với 2 cột
- crossAxisSpacing: 16
- mainAxisSpacing: 16
- padding horizontal: 24
- Sử dụng AlbumCard widget

## Bước 5: Styling và Colors

### 5.1 Cập nhật AppColors nếu cần

Kiểm tra file `lib/core/theme/app_colors.dart`

- Màu nền be/kem nhạt cho background
- Màu vàng cho center button
- Màu xanh gradient cho story border
- Màu đen cho active navigation

### 5.2 Constants

Tạo file `lib/core/constants/app_dimensions.dart`

- Avatar size: 64
- Story spacing: 12
- Album card radius: 20
- Grid spacing: 16
- Padding horizontal: 24

## Bước 6: Xử lý Tương tác

### 6.1 Stories

- Tap vào nút Add Story: hiển thị dialog/bottom sheet tạo story
- Tap vào story: xem story detail

### 6.2 Albums

- Tap vào album card: navigate đến album detail
- Tap vào icon heart: toggle favorite
- Tap vào icon search: mở search screen
- Tap vào icon add: hiển thị dialog tạo album mới

### 6.3 Filter

- Tap vào filter icon: hiển thị bottom sheet với tất cả filter options
- Tap vào X trên chip: xóa filter đó

### 6.4 Navigation

- Tap vào navigation items: chuyển màn hình tương ứng
- Center button: mở camera/tạo nội dung mới

## Bước 7: Testing và Polish

### 7.1 Kiểm tra hiển thị

- Test với nhiều số lượng albums khác nhau
- Test scroll behavior
- Test responsive trên các kích thước màn hình

### 7.2 Animation

- Thêm hero animation khi navigate vào album detail
- Thêm ripple effect cho các button
- Smooth scroll cho horizontal lists

### 7.3 Performance

- Cached network images cho ảnh cover
- Lazy loading cho grid
- Optimize rebuild widgets
