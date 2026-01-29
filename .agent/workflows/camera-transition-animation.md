---
description: Kế hoạch implementation hiệu ứng transition từ navigation bar sang màn camera
---

# Kế hoạch Implementation: Camera Transition Animation

## Tổng quan

Tạo hiệu ứng transition mượt mà khi chuyển từ các màn hình khác sang màn camera, trong đó navigation bar thu gọn và nút camera transform thành nút capture của màn camera.

## Phân tích Technical

### 1. Các thành phần cần thiết

**Navigation Bar**

- Hiện tại: Bottom navigation với 5 tabs
- Cần: Có thể animate từng icon riêng biệt
- Cần: Có thể animate position và size của camera button

**Camera Button**

- Vị trí ban đầu: Giữa nav bar
- Vị trí cuối: Vị trí nút capture trong camera screen
- Transform: Icon camera -> Icon check, size nhỏ -> size 72x72, màu thay đổi

**Camera Screen**

- Hiện tại: Full screen modal
- Cần: Slide up từ bottom với coordinated animation

### 2. Animation Flow

**Mở Camera (500ms total)**

```
Phase 1 (0-200ms): Nav icons fade out
├─ Left icons (Home, Albums) fade out + scale down
└─ Right icons (Grid, Profile) fade out + scale down

Phase 2 (200-400ms): Camera button transform
├─ Move up 50-80px
├─ Scale from nav size to 72x72
├─ Color change to orange
└─ Icon morph camera -> check

Phase 3 (200-500ms): Screen slide
├─ Camera screen slide up from bottom
├─ Fade in camera content
└─ Nav bar completely hidden
```

**Đóng Camera (500ms total)**

```
Reverse animation của mở camera
```

## Implementation Steps

### Step 1: Cấu trúc lại Navigation Bar

**Files cần sửa:**

- `lib/presentation/screens/main_screen.dart`

**Nhiệm vụ:**

1. Tách camera button thành widget riêng có thể animate
2. Thêm AnimatedBuilder hoặc ValueListenableBuilder cho từng nav item
3. Thêm state để track animation progress

**Output:**

- Navigation bar có thể animate từng phần riêng biệt
- Camera button có thể được control độc lập

### Step 2: Tạo Camera Transition Controller

**File mới:**

- `lib/presentation/animations/camera_transition_controller.dart`

**Nội dung:**

```dart
class CameraTransitionController {
  // Animation controllers
  late AnimationController navIconsController;
  late AnimationController cameraButtonController;
  late AnimationController screenSlideController;

  // Animations
  late Animation<double> navIconsOpacity;
  late Animation<double> navIconsScale;
  late Animation<Offset> cameraButtonPosition;
  late Animation<double> cameraButtonSize;
  late Animation<Color> cameraButtonColor;
  late Animation<Offset> screenSlide;

  // Methods
  Future<void> openCamera();
  Future<void> closeCamera();
}
```

**Nhiệm vụ:**

1. Setup 3 AnimationController với duration phù hợp
2. Tạo các Tween cho từng property cần animate
3. Implement openCamera() method với sequential animation
4. Implement closeCamera() method với reverse animation
5. Add dispose method

### Step 3: Tạo Hero Animation cho Camera Button

**Cách tiếp cận:**

- Dùng Hero widget để animate camera button từ nav -> camera screen
- Custom HeroFlightShuttleBuilder để control transform

**Files cần sửa:**

- Nav bar camera button
- Camera screen capture button

**Nhiệm vụ:**

1. Wrap camera button trong nav bar với Hero widget (tag: 'camera_button')
2. Wrap capture button trong camera screen với Hero widget (tag: 'camera_button')
3. Implement custom flight shuttle để morph giữa 2 states

### Step 4: Custom Page Route cho Camera Screen

**File mới:**

- `lib/presentation/routes/camera_page_route.dart`

**Nội dung:**

```dart
class CameraPageRoute extends PageRoute {
  @override
  Widget buildPage(...) {
    return CameraScreen();
  }

  @override
  Widget buildTransitions(...) {
    // Custom slide up animation
    // Coordinate với nav bar animation
  }
}
```

**Nhiệm vụ:**

1. Tạo custom PageRoute với slide up transition
2. Override buildTransitions để control animation
3. Add curve (Curves.easeOutCubic cho smooth feeling)
4. Duration: 500ms

### Step 5: Coordinate Animations

**File:**

- `lib/presentation/screens/main_screen.dart`

**Nhiệm vụ:**

1. Khi tap camera button:
   - Trigger nav icons fade out (200ms)
   - Đợi 200ms
   - Navigate với CameraPageRoute (300ms)
   - Hero animation tự động chạy

2. Khi tap close button trong camera:
   - Pop route
   - Trigger reverse animation
   - Nav icons fade in

### Step 6: Tạo Animated Nav Bar Wrapper

**File mới:**

- `lib/presentation/widgets/animated_bottom_nav.dart`

**Nhiệm vụ:**

1. Wrap bottom navigation bar
2. Listen to route changes
3. Tự động trigger animation khi navigate to/from camera
4. Quản lý visibility của nav bar

### Step 7: Polish và Fine-tuning

**Nhiệm vụ:**

1. Test trên nhiều kích thước màn hình
2. Adjust timing để mượt hơn
3. Add haptic feedback khi transition
4. Ensure no jank (maintain 60fps)
5. Handle edge cases (double tap, rapid navigation)

## Technical Considerations

### Performance

- Dùng `AnimatedBuilder` thay vì `setState()` để giảm rebuild
- Cache animation values
- Dùng `RepaintBoundary` cho camera screen content

### State Management

- Listen to navigation stack để biết khi nào trigger animation
- Coordinate với existing navigation logic
- Cleanup animations khi không dùng

### Testing

- Test animation smooth trên thiết bị thật
- Test với different screen sizes
- Test rapid navigation
- Test back button behavior

## Dependencies cần thêm

Không cần thêm dependencies mới, sử dụng Flutter built-in:

- AnimationController
- Hero widget
- PageRoute
- Tween
- Curves

## Ước tính công việc

Tổng cộng khoảng 6-8 giờ implementation:

- Step 1-2: Tái cấu trúc navigation (2h)
- Step 3-4: Hero animation và route (2h)
- Step 5-6: Coordinate animations (2h)
- Step 7: Polish và testing (2h)

## Notes

- Cần test kỹ trên thiết bị thật vì animation performance khác emulator
- Có thể cần adjust timing sau khi test
- Cân nhắc add option để disable animation cho accessibility
