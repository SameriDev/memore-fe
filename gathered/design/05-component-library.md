# memore Component Library

## Component Design Philosophy

memore's component library follows **Material Design 3** principles adapted for authentic, intimate photo sharing. Components prioritize accessibility, consistency, and emotional warmth while maintaining technical excellence.

### Design Principles

- **Consistent**: Every component follows the same design language
- **Accessible**: All components meet WCAG 2.1 AA standards
- **Modular**: Components work independently and together
- **Scalable**: Components adapt to different screen sizes
- **Expressive**: Components convey emotion and personality

---

## 1. Buttons

### 1.1 Primary Button

#### Design Specifications

```
Default State:
- Background: memore Purple (#6366F1)
- Text Color: White (#FFFFFF)
- Corner Radius: 8dp
- Height: 48dp
- Padding: 16dp horizontal, 12dp vertical
- Typography: Label Large (16sp, Medium weight)
- Elevation: Level 1 (2dp shadow)

Pressed State:
- Background: Purple 600 (#5B21B6)
- Scale: 0.98 transform
- Elevation: Level 0 (no shadow)

Disabled State:
- Background: Warm Gray 200 (#E7E5E4)
- Text Color: Warm Gray 400 (#A8A29E)
- Elevation: None
```

#### Usage Guidelines

- **Use for**: Primary actions like "Send Photo", "Get Started", "Save"
- **Don't use for**: Secondary actions or when multiple primary actions compete
- **Maximum per screen**: 1-2 primary buttons
- **Text**: Use action verbs, keep under 20 characters

#### Flutter Implementation Example

```dart
ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.memorePurple,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    minimumSize: Size(double.infinity, 48),
    elevation: 2,
  ),
  child: Text(
    'Send Photo',
    style: AppTextStyles.labelLarge,
  ),
)
```

### 1.2 Secondary Button

#### Design Specifications

```
Default State:
- Background: Transparent
- Border: 1dp solid Warm Gray 300 (#D6D3D1)
- Text Color: Warm Gray 700 (#44403C)
- Corner Radius: 8dp
- Height: 48dp
- Padding: 16dp horizontal, 12dp vertical

Pressed State:
- Background: Warm Gray 50 (#FAFAF9)
- Border Color: Warm Gray 400 (#A8A29E)

Disabled State:
- Border Color: Warm Gray 200 (#E7E5E4)
- Text Color: Warm Gray 400 (#A8A29E)
```

#### Usage Guidelines

- **Use for**: Secondary actions like "Cancel", "Skip", "Edit Profile"
- **Pairing**: Always pair with a primary button when both actions are available
- **Text**: Use clear, descriptive action words

### 1.3 Text Button

#### Design Specifications

```
Default State:
- Background: Transparent
- Text Color: memore Purple (#6366F1)
- Typography: Label Medium (14sp, Medium weight)
- Padding: 8dp horizontal, 8dp vertical
- Minimum Touch Target: 48x48dp

Pressed State:
- Background: Purple 50 (#F3F4F6) with 8dp radius
- Text Color: Purple 700 (#5B21B6)
```

#### Usage Guidelines

- **Use for**: Tertiary actions like "Learn More", "Skip", navigation links
- **Accessibility**: Ensure 48dp minimum touch target with invisible padding

### 1.4 Floating Action Button (FAB)

#### Design Specifications

```
Default State:
- Background: memore Purple (#6366F1)
- Icon Color: White (#FFFFFF)
- Size: 56x56dp
- Corner Radius: 16dp (Material 3 FAB style)
- Icon Size: 24dp
- Elevation: Level 3 (6dp shadow)

Pressed State:
- Background: Purple 600 (#5B21B6)
- Elevation: Level 1 (2dp shadow)
```

#### Usage Guidelines

- **Use for**: Primary action on a screen (camera capture, add friend)
- **Position**: Bottom right, 16dp from screen edges
- **One per screen**: Only use one FAB per screen

---

## 2. Input Components

### 2.1 Text Field

#### Design Specifications

```
Default State:
- Background: White (#FFFFFF)
- Border: 1dp solid Warm Gray 300 (#D6D3D1)
- Corner Radius: 8dp
- Height: 56dp
- Padding: 16dp horizontal, 16dp vertical
- Label: Body Medium, Warm Gray 600

Focused State:
- Border: 2dp solid memore Purple (#6366F1)
- Label Color: memore Purple

Error State:
- Border: 1dp solid Error Red (#EF4444)
- Error Text: Body Small, Error Red, 4dp margin top

Disabled State:
- Background: Warm Gray 100 (#F5F5F4)
- Border: Warm Gray 200 (#E7E5E4)
- Text Color: Warm Gray 400 (#A8A29E)
```

#### Usage Guidelines

- **Labels**: Use clear, concise labels above the input
- **Placeholder**: Provide helpful examples, not instructions
- **Validation**: Show errors immediately after user interaction
- **Required fields**: Use asterisk (\*) after label text

### 2.2 Phone Number Input

#### Design Specifications

```
Layout:
┌─────────────────────────────────────┐
│ [🇺🇸 +1] [Phone Number Input]      │
└─────────────────────────────────────┘
Country     Phone Number
Selector    Field
120dp       Remaining width

Country Selector:
- Background: Warm Gray 100 (#F5F5F4)
- Border: 1dp solid Warm Gray 300 on right side only
- Corner Radius: 8dp left, 0dp right
- Height: 56dp
- Flag Emoji: 20dp
- Country Code: Body Medium
```

#### Usage Guidelines

- **Auto-detection**: Pre-select country based on device locale
- **Formatting**: Auto-format phone number as user types
- **Validation**: Real-time validation with clear error messages

### 2.3 Search Bar

#### Design Specifications

```
Default State:
- Background: Warm Gray 100 (#F5F5F4)
- Corner Radius: 24dp (pill shape)
- Height: 40dp
- Leading Icon: Search (20dp), Warm Gray 500
- Placeholder: Body Medium, Warm Gray 500
- Padding: 16dp horizontal

Active State:
- Background: White (#FFFFFF)
- Border: 1dp solid memore Purple (#6366F1)
- Trailing Icon: Clear (X) when text present
```

#### Usage Guidelines

- **Placeholder**: Use "Search friends", "Search photos", etc.
- **Clear action**: Show X button when text is entered
- **Auto-focus**: Focus immediately when screen opens (if appropriate)

---

## 3. Selection Components

### 3.1 Checkbox

#### Design Specifications

```
Unchecked State:
- Background: Transparent
- Border: 2dp solid Warm Gray 400 (#A8A29E)
- Corner Radius: 4dp
- Size: 20x20dp

Checked State:
- Background: memore Purple (#6366F1)
- Border: None
- Check Mark: White, 2dp stroke width

Indeterminate State:
- Background: memore Purple (#6366F1)
- Dash Mark: White, 2dp stroke, 8dp width
```

#### Usage Guidelines

- **Touch Target**: 48x48dp minimum with invisible padding
- **Labeling**: Clear, descriptive text to the right
- **Group Behavior**: Use for multiple selections

### 3.2 Radio Button

#### Design Specifications

```
Unselected State:
- Background: Transparent
- Border: 2dp solid Warm Gray 400 (#A8A29E)
- Size: 20x20dp (circular)

Selected State:
- Border: 2dp solid memore Purple (#6366F1)
- Inner Circle: 8dp diameter, memore Purple
- Center Position: Perfectly centered
```

#### Usage Guidelines

- **Single Selection**: Use when only one option can be selected
- **Clear Options**: Ensure mutually exclusive choices
- **Default Selection**: Pre-select the most common option

### 3.3 Toggle Switch

#### Design Specifications

```
Off State:
- Track: Warm Gray 300 (#D6D3D1), 32x20dp rounded
- Thumb: White circle, 16dp diameter
- Position: Left side (2dp from edge)

On State:
- Track: memore Purple (#6366F1)
- Thumb: White circle, 16dp diameter
- Position: Right side (2dp from edge)

Animation:
- Duration: 150ms
- Curve: Standard easing
```

#### Usage Guidelines

- **Binary Settings**: Use for on/off preferences
- **Immediate Effect**: Changes take effect immediately
- **Clear States**: Use descriptive labels for both states

---

## 4. Content Components

### 4.1 Photo Card

#### Design Specifications

```
Card Container:
- Background: White (#FFFFFF)
- Corner Radius: 12dp
- Elevation: Level 1 (2dp shadow)
- Aspect Ratio: 16:9 for landscape, 4:5 for portrait
- Margin: 16dp horizontal, 8dp vertical

Photo Content:
- Corner Radius: 12dp (matches container)
- Loading Placeholder: Warm Gray 200 skeleton
- Error State: 48dp broken image icon on Warm Gray 100

Metadata Overlay:
- Background: Semi-transparent black (40% opacity)
- Position: Bottom of photo
- Padding: 12dp
- Text Color: White (#FFFFFF)
```

#### Component Structure

```
┌─────────────────────────────────────┐
│                                     │
│           Photo Content             │
│                                     │
│ ┌─────────────────────────────────┐ │ Metadata overlay
│ │ [Avatar] Name    Time    [💜]   │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### Usage Guidelines

- **Loading States**: Show skeleton animation while loading
- **Error Handling**: Graceful fallback for failed photo loads
- **Interactions**: Single tap for full-screen, double tap for like

### 4.2 Friend List Item

#### Design Specifications

```
Container:
- Height: 72dp
- Background: White (default), Warm Gray 50 (pressed)
- Padding: 16dp horizontal, 12dp vertical

Avatar:
- Size: 40x40dp circular
- Default: Colored circle with initials
- Border: 1dp solid Warm Gray 200

Content Layout:
[Avatar] [Name + Status]        [Action]
40dp     Flexible width        32dp min
```

#### Component Structure

```
┌─────────────────────────────────────┐
│ [🟢]  Sarah Johnson                │ 72dp height
│ @    Online • 2 photos today   [>] │
└─────────────────────────────────────┘
Avatar  Name & Status           Action
```

#### Usage Guidelines

- **Status Indicators**: Green dot for online, gray for offline
- **Action Buttons**: Keep consistent across different contexts
- **Accessibility**: Provide clear content descriptions

### 4.3 Empty State

#### Design Specifications

```
Container:
- Centered content with flexible spacing
- Maximum width: 280dp
- Horizontal margin: 32dp

Illustration:
- Size: 120x120dp
- Style: Friendly, minimal line art
- Colors: Warm Gray 400 with Purple accents

Text Content:
- Heading: H3, Warm Gray 700, center aligned
- Description: Body Large, Warm Gray 500
- Line Height: 1.5x for readability

Action Button:
- Primary or secondary based on importance
- Margin: 32dp top from description
```

#### Usage Guidelines

- **Helpful Messaging**: Explain why the state is empty
- **Clear Actions**: Provide obvious next steps
- **Positive Tone**: Use encouraging, not frustrating language

---

## 5. Navigation Components

### 5.1 Bottom Navigation

#### Design Specifications

```
Container:
- Height: 80dp (56dp content + 24dp safe area)
- Background: White (#FFFFFF)
- Top Border: 1dp solid Warm Gray 200
- Elevation: Level 3 (6dp shadow)

Tab Items:
- Width: Equal distribution across screen width
- Touch Target: 56x56dp minimum
- Icon Size: 24x24dp
- Label: Body Small (12sp)

Active State:
- Icon Color: memore Purple (#6366F1)
- Label Color: memore Purple
- Background: Purple 50 ripple on press

Inactive State:
- Icon Color: Warm Gray 500 (#78716C)
- Label Color: Warm Gray 500
```

#### Usage Guidelines

- **3-5 Tabs**: Optimal number for mobile screens
- **Clear Icons**: Use universally understood iconography
- **Consistent Labeling**: Keep tab names short and consistent

### 5.2 Top App Bar

#### Design Specifications

```
Standard App Bar:
- Height: 56dp
- Background: White (#FFFFFF)
- Elevation: Level 0 (no shadow by default)
- Title: H3, Warm Gray 800, left aligned

With Actions:
- Action Icons: 24x24dp, 48x48dp touch target
- Action Spacing: 4dp between icons
- Right Margin: 4dp from screen edge

Large Title (iOS Style):
- Height: 96dp
- Large Title: H1, Warm Gray 800
- Subtitle: Body Medium, Warm Gray 600
```

#### Usage Guidelines

- **Clear Hierarchy**: Title should clearly indicate current screen
- **Essential Actions**: Only include most important actions in app bar
- **Platform Adaptation**: Follow platform conventions for navigation

### 5.3 Tab Bar (Secondary Navigation)

#### Design Specifications

```
Container:
- Height: 48dp
- Background: Warm Gray 50 (#FAFAF9)
- Bottom Border: 1dp solid Warm Gray 200

Tab Items:
- Minimum Width: 90dp
- Height: 48dp
- Padding: 16dp horizontal, 12dp vertical
- Typography: Label Medium

Active State:
- Background: White with 2dp bottom border (Purple)
- Text Color: memore Purple (#6366F1)

Inactive State:
- Background: Transparent
- Text Color: Warm Gray 600 (#57534E)
```

#### Usage Guidelines

- **Content Organization**: Use for filtering or categorizing content
- **Scrollable**: Allow horizontal scrolling if more than 3-4 tabs
- **Clear Labels**: Use descriptive but concise tab names

---

## 6. Feedback Components

### 6.1 Toast/Snackbar

#### Design Specifications

```
Container:
- Background: Warm Gray 800 (#292524)
- Corner Radius: 8dp
- Margin: 16dp from screen edges
- Minimum Height: 48dp
- Maximum Width: 600dp

Content:
- Text Color: White (#FFFFFF)
- Typography: Body Medium
- Padding: 16dp horizontal, 12dp vertical
- Icon: 20dp (optional, left aligned)

Action Button (optional):
- Text Color: memore Purple (#6366F1)
- Typography: Label Medium
- Padding: 8dp
```

#### Usage Guidelines

- **Brief Messages**: Keep text under 60 characters
- **Auto-Dismiss**: 4 seconds for info, 6 seconds with action
- **One at a Time**: Don't stack multiple toasts

### 6.2 Alert Dialog

#### Design Specifications

```
Container:
- Background: White (#FFFFFF)
- Corner Radius: 16dp
- Margin: 24dp from screen edges
- Elevation: Level 4 (8dp shadow)

Content:
- Title: H3, Warm Gray 800, 24dp margin
- Message: Body Large, Warm Gray 700
- Padding: 24dp all sides

Actions:
- Button Layout: Right aligned, horizontal
- Button Height: 36dp
- Button Spacing: 8dp between buttons
```

#### Usage Guidelines

- **Critical Actions**: Use for destructive or important actions
- **Clear Options**: Provide clear positive and negative actions
- **Escape Route**: Always provide a way to cancel/dismiss

### 6.3 Progress Indicator

#### Design Specifications

```
Circular Progress:
- Size: 24dp (small), 40dp (medium), 56dp (large)
- Stroke Width: 2dp (small), 3dp (medium), 4dp (large)
- Color: memore Purple (#6366F1)
- Animation: 1 second rotation, infinite

Linear Progress:
- Height: 4dp
- Corner Radius: 2dp
- Track Color: Warm Gray 200 (#E7E5E4)
- Progress Color: memore Purple (#6366F1)
```

#### Usage Guidelines

- **Appropriate Size**: Match size to context and importance
- **Determinate**: Show percentage when progress is known
- **Indeterminate**: Use for unknown duration tasks

---

## 7. Status & Badge Components

### 7.1 Status Badge

#### Design Specifications

```
Notification Badge:
- Background: Error Red (#EF4444)
- Text Color: White (#FFFFFF)
- Corner Radius: 10dp (pill shape)
- Minimum Size: 20x20dp
- Typography: Body Small (12sp, Medium weight)

Online Status Dot:
- Size: 12x12dp circular
- Colors: Success Green (online), Warm Gray 400 (offline)
- Position: Bottom right of avatar with 2dp white border

Activity Indicator:
- Background: Success Green (#10B981)
- Size: 8x8dp circular
- Animation: Gentle pulse (scale 1.0 to 1.2)
```

#### Usage Guidelines

- **Count Display**: Show numbers 1-99, then "99+"
- **Clear Meaning**: Use consistent colors for status types
- **Appropriate Size**: Don't overwhelm the interface

### 7.2 Chip/Tag

#### Design Specifications

```
Standard Chip:
- Background: Warm Gray 100 (#F5F5F4)
- Border: 1dp solid Warm Gray 200
- Corner Radius: 16dp (pill shape)
- Height: 32dp
- Padding: 12dp horizontal, 6dp vertical
- Typography: Label Medium

Selected Chip:
- Background: Purple 100 (#E0E7FF)
- Border: 1dp solid memore Purple
- Text Color: Purple 700 (#5B21B6)

Chip with Icon:
- Leading Icon: 16dp, 4dp margin right
- Remove Icon: 16dp X, 4dp margin left
```

#### Usage Guidelines

- **Filtering**: Use for selection and filtering options
- **Removable**: Include X icon for removable tags
- **Clear Labels**: Use descriptive, scannable text

---

## 8. Component Accessibility

### Universal Requirements

#### Touch Targets

- **Minimum Size**: 48x48dp for all interactive elements
- **Spacing**: 8dp minimum between adjacent touch targets
- **Clear Boundaries**: Visual indication of interactive areas

#### Color Contrast

- **Text**: 4.5:1 ratio for normal text, 3:1 for large text
- **Interactive Elements**: 3:1 ratio minimum
- **Focus Indicators**: 2.4:1 ratio, 2dp minimum thickness

#### Screen Reader Support

```dart
// Example semantic labeling
Semantics(
  label: 'Send photo to Sarah Johnson',
  hint: 'Double tap to send photo',
  child: PhotoSendButton(
    friend: friend,
    onTap: onSendPhoto,
  ),
)
```

#### Keyboard Navigation

- **Focus Order**: Logical tab order through interface
- **Focus Indicators**: Clear visual indication of focused element
- **Keyboard Shortcuts**: Support for common actions (Space, Enter)

### Component-Specific Accessibility

#### Buttons

- Clear action descriptions in semantic labels
- Loading states announced to screen readers
- Disabled state clearly communicated

#### Form Inputs

- Associated labels with form controls
- Error announcements for validation failures
- Clear instructions for required fields

#### Navigation

- Current page/tab clearly indicated
- Breadcrumb navigation for deep hierarchies
- Skip links for complex navigation structures

---

## 9. Component Testing

### Visual Testing

- **Multiple States**: Test all component states (default, pressed, disabled)
- **Screen Sizes**: Verify layout on different screen densities
- **Dark Mode**: Ensure components work in both light and dark themes
- **Accessibility**: Test with high contrast and large text settings

### Interaction Testing

- **Touch Response**: Verify appropriate touch feedback
- **Loading States**: Test component behavior during loading
- **Error Handling**: Verify graceful error state handling
- **Performance**: Ensure smooth animations and interactions

### Cross-Platform Testing

- **Android Versions**: Test on API levels 21+ (Android 5.0+)
- **Screen Densities**: Test on different DPI devices
- **Manufacturer Skins**: Verify consistency across device manufacturers
- **Input Methods**: Test with different keyboards and input devices
