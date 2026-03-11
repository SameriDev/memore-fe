# Avatar Fix Guide - Hướng dẫn sửa lỗi Avatar

## ✅ Đã được fix

Các widget sau đã được update để sử dụng `UniversalAvatar`:

1. **friend_list_item.dart** - Friends trong danh sách
2. **friend_grid_item.dart** - Friends trong grid view
3. **story_section.dart** - Avatar trong stories
4. **timeline_header.dart** - Header của friend timeline
5. **profile_header.dart** - Profile main avatar

## 🔧 Cần fix thêm

Các widgets sau vẫn cần fix để handle local files + network URLs:

### **High Priority**
- `profile_edit_popup.dart` - Lines 217-225 (CircleAvatar với NetworkImage)
- `friend_picker_widget.dart` - Lines 86-93, 117-124 (CircleAvatar với NetworkImage)
- `pending_requests_screen.dart` - Lines 147-151 (CircleAvatar với NetworkImage)
- `add_friend_screen.dart` - Lines 151-154 (CircleAvatar với NetworkImage)

### **Medium Priority**
- `viewer_header.dart` - Lines 27-31 (CircleAvatar với NetworkImage)
- `album_detail_screen.dart` - Lines 156-161, 364-374 (CircleAvatar với NetworkImage)
- `story_viewer_screen.dart` - Lines 249-260 (OptimizedCachedImage.avatar())

## 📋 Cách fix cho mỗi widget

### **Pattern 1: Thay thế CircleAvatar đơn giản**

**Tìm code như thế này:**
```dart
CircleAvatar(
  backgroundImage: NetworkImage(avatarUrl),
  child: avatarUrl.isEmpty ? Icon(Icons.person) : null,
)
```

**Thay bằng:**
```dart
// Import trước
import '../path/to/universal_avatar.dart';

// Thay CircleAvatar bằng
UniversalAvatar.small(
  avatarUrl: avatarUrl,
  fallbackText: name, // tùy chọn
)
```

### **Pattern 2: Thay thế Container + Image.network**

**Tìm code như thế này:**
```dart
Container(
  width: 60,
  height: 60,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.blue, width: 2),
  ),
  child: ClipOval(
    child: Image.network(
      avatarUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
    ),
  ),
)
```

**Thay bằng:**
```dart
UniversalAvatar(
  avatarUrl: avatarUrl,
  radius: 30.0, // 60/2
  borderColor: Colors.blue,
  borderWidth: 2.0,
  fallbackText: name,
)
```

### **Pattern 3: Với custom decoration đặc biệt**

Nếu widget có design đặc biệt (như gradient border trong story), thì:

1. **Thêm imports:**
```dart
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
```

2. **Thêm helper method:**
```dart
ImageProvider<Object>? _getAvatarImageProvider(String? avatarUrl) {
  if (avatarUrl == null || avatarUrl.isEmpty) return null;

  // Check if it's a local file path
  if (avatarUrl.startsWith('/') ||
      avatarUrl.startsWith('file:') ||
      avatarUrl.contains('\\') || // Windows paths
      File(avatarUrl).existsSync()) {
    return FileImage(File(avatarUrl));
  }

  // Check if it's a valid network URL
  if (avatarUrl.startsWith('http://') ||
      avatarUrl.startsWith('https://') ||
      avatarUrl.startsWith('www.')) {
    return CachedNetworkImageProvider(avatarUrl);
  }

  return null;
}
```

3. **Thay đổi CircleAvatar backgroundImage:**
```dart
CircleAvatar(
  backgroundImage: _getAvatarImageProvider(avatarUrl),
  child: avatarUrl.isEmpty ? Icon(Icons.person) : null,
)
```

## 🎯 UniversalAvatar Factory Constructors

### **UniversalAvatar.small()** - 20px radius
- Dùng cho: friend list items, participant lists
- Features: Online status, border options

### **UniversalAvatar.medium()** - 30px radius
- Dùng cho: friend grid items, story circles
- Features: Online status, border options

### **UniversalAvatar.large()** - 60px radius
- Dùng cho: profile headers, main avatars
- Features: Golden border default

### **UniversalAvatar()** - Custom
- Custom radius, border, colors
- Full control over appearance

## 🔥 Custom Properties

```dart
UniversalAvatar(
  avatarUrl: avatarUrl,
  radius: 25.0,                              // Size
  borderColor: Colors.blue,                  // Border color
  borderWidth: 2.0,                          // Border thickness
  showOnlineStatus: true,                    // Show green dot
  isOnline: user.isOnline,                   // Online state
  onlineIndicatorColor: Colors.green,        // Dot color
  fallbackText: user.name,                   // Letter fallback
  fallbackIcon: Icons.person,                // Icon fallback
  fallbackBackgroundColor: Colors.grey,      // Fallback bg
  onTap: () => print('Avatar tapped'),       // Tap handler
)
```

## 🚀 Benefits của UniversalAvatar

- ✅ **Handle local files** - Fix lỗi avatar không hiển thị
- ✅ **Network caching** - Performance tốt hơn với CachedNetworkImage
- ✅ **Consistent UI** - Đồng nhất across app
- ✅ **Online status** - Built-in green dot
- ✅ **Graceful fallbacks** - Letter hoặc icon khi lỗi
- ✅ **Customizable** - Border, size, colors
- ✅ **Tap handling** - Built-in gesture support
- ✅ **Error handling** - Robust error handling

## 🎨 Import Path

Từ bất kỳ widget nào:
```dart
// Từ lib/presentation/widgets/
import 'universal_avatar.dart';

// Từ lib/presentation/screens/*/
import '../../widgets/universal_avatar.dart';

// Từ lib/presentation/screens/*/*/
import '../../../widgets/universal_avatar.dart';
```

## ⚡ Quick Fix List

**Profile Edit Popup:**
```dart
// Old
CircleAvatar(backgroundImage: NetworkImage(widget.user.avatarUrl))
// New
UniversalAvatar.medium(avatarUrl: widget.user.avatarUrl, fallbackText: widget.user.name)
```

**Friend Picker Chips:**
```dart
// Old
CircleAvatar(backgroundImage: NetworkImage(friend.avatarUrl), child: Text(friend.name[0]))
// New
UniversalAvatar.small(avatarUrl: friend.avatarUrl, fallbackText: friend.name)
```

**Pending Requests:**
```dart
// Old
CircleAvatar(backgroundImage: NetworkImage(pravatar_url))
// New
UniversalAvatar.medium(avatarUrl: avatarUrl, fallbackText: senderName)
```

Với hướng dẫn này, bạn có thể dễ dàng fix toàn bộ avatar issues trong app!