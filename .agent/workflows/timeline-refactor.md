---
description: Refactor Timeline Screen Structure
---

# Timeline Screen Refactoring Plan

## Objective

Tách file timeline_screen.dart thành các module nhỏ hơn để dễ maintain và tổ chức code tốt hơn.

## Structure

```
lib/presentation/screens/timeline/
├── timeline_screen.dart
├── widgets/
│   └── timeline_item.dart
├── models/
│   └── timeline_models.dart
└── config/
    └── timeline_config.dart
```

## Implementation Steps

### 1. Tạo timeline_models.dart

- TimelineItemData class
- TimelineAlignment enum

### 2. Tạo timeline_config.dart

- \_ResponsiveConfig class
- Factory method fromWidth với 3 breakpoints

### 3. Tạo timeline_item.dart

- \_TimelineItem widget
- \_buildVerticalLayout method
- \_buildHorizontalLayout method
- \_buildCircle method
- \_buildTextInfo method
- \_buildImageCluster method với logic render 1/2/3/4+ ảnh

### 4. Refactor timeline_screen.dart

- Giữ lại TimelineScreen và \_TimelineScreenState
- Import các file mới
- Giữ scroll logic và state management
- Mock data list

## File Dependencies

```
timeline_screen.dart
  ├── imports models/timeline_models.dart
  ├── imports config/timeline_config.dart
  └── imports widgets/timeline_item.dart

timeline_item.dart
  ├── imports models/timeline_models.dart
  └── imports config/timeline_config.dart

timeline_config.dart (no dependencies)
timeline_models.dart (no dependencies)
```

## Expected Results

- timeline_screen.dart: ~150 dòng
- timeline_item.dart: ~400 dòng
- timeline_models.dart: ~30 dòng
- timeline_config.dart: ~90 dòng
