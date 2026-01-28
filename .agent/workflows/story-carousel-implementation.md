---
description: Kế hoạch implementation Story Carousel Overlay
---

# Implementation Plan: Story Carousel Overlay

## Mô tả tính năng

Khi người dùng tap vào story circle trên thanh story, màn hình sẽ làm mờ và hiển thị overlay với stack gallery carousel để xem các ảnh trong story.

## Cấu trúc implementation

### 1. Domain Layer

#### 1.1 Tạo Story Entity

File: `lib/domain/entities/story.dart`

- `id`: String
- `userId`: String
- `userName`: String
- `userAvatar`: String
- `images`: List<String>
- `createdAt`: DateTime
- `isViewed`: bool

### 2. Presentation Layer - Widgets

#### 2.1 Story Stack Card Widget

File: `lib/presentation/widgets/story_stack_card.dart`

- Widget để hiển thị một ảnh trong stack
- Props:
  - `imageUrl`: String
  - `isMain`: bool (ảnh chính hay phía sau)
  - `rotation`: double
  - `scale`: double
- Styling:
  - Border radius: 22px cho main, 21px cho background
  - Shadow: `0px 4px 4px rgba(0,0,0,0.61)` cho main
  - Blur: 1.75px cho background images

#### 2.2 Story Carousel Widget

File: `lib/presentation/widgets/story_carousel.dart`

- Widget chứa stack gallery với PageView
- Props:
  - `images`: List<String>
  - `currentIndex`: int
  - `onPageChanged`: Function(int)
  - `onClose`: Function()
- Features:
  - PageView để swipe giữa các ảnh
  - Stack 3 cards: current, previous (blur), next (blur)
  - Animation khi chuyển trang
  - Progress indicators ở trên đầu

#### 2.3 Story Overlay

File: `lib/presentation/widgets/story_overlay.dart`

- Full screen overlay với background mờ
- Props:
  - `story`: Story entity
  - `onDismiss`: Function()
- Layout:
  - Background: màu đen với opacity 0.5-0.7
  - Story carousel ở giữa
  - Tap outside để đóng
  - Swipe down để đóng

#### 2.4 Story Progress Bar

File: `lib/presentation/widgets/story_progress_bar.dart`

- Thanh tiến trình ở trên đầu
- Props:
  - `currentIndex`: int
  - `totalCount`: int
- Styling: Nhiều segment bars, segment hiện tại được fill

### 3. Integration vào My Albums Screen

#### 3.1 Cập nhật My Albums Screen

File: `lib/presentation/screens/my_albums_screen.dart`

- Thêm state để quản lý story overlay
- Thêm callback khi tap vào story circle
- Hiển thị StoryOverlay khi có story được chọn

#### 3.2 Story Circles Component

File: Có thể đã tồn tại hoặc cần tạo mới

- Thêm `onTap` callback cho mỗi story circle
- Pass story data khi tap

### 4. Animation & Gestures

#### 4.1 Stack Card Animation

- Rotation animation khi swipe
- Scale animation khi card di chuyển
- Fade animation cho background cards

#### 4.2 Overlay Animation

- Fade in background khi mở
- Slide up carousel khi mở
- Fade out và slide down khi đóng

#### 4.3 Gesture Handling

- Horizontal swipe để chuyển ảnh
- Vertical swipe down để đóng overlay
- Tap outside để đóng

### 5. State Management

#### 5.1 Story State

- Quản lý danh sách stories
- Track story nào đã xem
- Current story index
- Current image index trong story

## Thứ tự thực hiện

1. Tạo Story entity trong domain layer
2. Tạo Story Stack Card widget với styling từ Figma
3. Tạo Story Carousel widget với PageView
4. Tạo Story Progress Bar widget
5. Tạo Story Overlay widget kết hợp các widget trên
6. Tích hợp vào My Albums screen
7. Thêm animations và gesture handling
8. Test và điều chỉnh

## Các giá trị từ Figma

### Story Stack Card

- Main card border radius: 22px
- Background card border radius: 21px
- Main card shadow: `0px 4px 4px rgba(0,0,0,0.61)`
- Background blur: 1.75px
- Rotation angle: khoảng 5 độ

### Overlay

- Background color: đen
- Background opacity: 0.5-0.7
- Backdrop blur: optional

### Story Circles

- Đã có thiết kế từ màn hình My Albums
