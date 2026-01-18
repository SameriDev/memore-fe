# memore Screen Specifications

## Screen Overview

This document provides detailed layout specifications for every screen in the memore app, designed for **Android-first development** with Material Design 3 principles. All measurements are in density-independent pixels (dp) following Android conventions.

---

## 1. Onboarding Screens

### 1.1 Welcome Screen

#### Layout Structure

```
┌─────────────────────────────────────┐
│              Status Bar              │ 24dp height
├─────────────────────────────────────┤
│                                     │
│           App Logo/Icon             │ 80dp x 80dp, centered
│              (120dp)                │ margin top
│                                     │
│              memore                 │ H1, 48dp margin top
│                                     │
│    "A little glimpse of what        │ Body Large, 24dp margin top
│     everyone's up to throughout     │ 32dp horizontal margin
│           the day"                  │
│                                     │
│        [Illustration]               │ 200dp height, 48dp margin top
│                                     │
│                                     │
│         [Get Started]               │ Primary button, 48dp margin top
│                                     │ 16dp horizontal margin
│                                     │
│           Learn More                │ Text button, 16dp margin top
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

- **App Icon**: 80x80dp, purple gradient circle with white camera icon
- **Title**: H1 typography, Warm Gray 800, center aligned
- **Description**: Body Large, Warm Gray 600, center aligned, max 2 lines
- **Illustration**: Friendly vector illustration of friends sharing photos
- **Get Started Button**: Primary button, full width minus 32dp margins, 48dp height
- **Learn More Link**: Label Medium, memore Purple, center aligned

#### Interaction States

- **Get Started Tap**: Navigate to Phone Verification with slide transition
- **Learn More Tap**: Open in-app browser with memore feature overview
- **Screen Gestures**: No swipe navigation (prevent accidental skips)

### 1.2 Phone Verification Screen

#### Layout Structure

```
┌─────────────────────────────────────┐
│     [←]    Verify Phone    [Skip]   │ App bar, 56dp height
├─────────────────────────────────────┤
│                                     │
│     We'll send you a verification   │ H3, 32dp margin top
│           code via SMS              │ 16dp horizontal margin
│                                     │
│    [Country Selector] [Phone Input] │ 32dp margin top
│     🇺🇸 +1          (555) 123-4567  │ 16dp horizontal margin
│                                     │
│         [Send Code]                 │ Primary button, 24dp margin top
│                                     │ 16dp horizontal margin
│                                     │
│                                     │
│       By continuing, you agree to   │ Body Small, 24dp margin top
│        our Terms and Privacy        │ center aligned
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

- **App Bar**: Material 3 top app bar with back arrow and skip option
- **Title**: H3 typography, Warm Gray 800
- **Country Selector**: Dropdown with flag emoji and country code
- **Phone Input**: Text field with phone number formatting and validation
- **Send Code Button**: Primary button, enabled only with valid phone number
- **Terms Link**: Body Small with clickable terms and privacy links

#### Input Validation

- **Phone Format**: Auto-format as user types (e.g., (555) 123-4567)
- **Country Detection**: Auto-detect country based on device locale
- **Error States**: Show validation errors below input field
- **Loading State**: Button shows loading spinner during SMS send

### 1.3 SMS Verification Screen

#### Layout Structure

```
┌─────────────────────────────────────┐
│     [←]    Enter Code              │ App bar
├─────────────────────────────────────┤
│                                     │
│      We sent a code to              │ H3, 32dp margin top
│      (555) 123-4567                │ Body Medium, 8dp margin top
│                                     │
│    [1] [2] [3] [4] [5] [6]         │ Code input, 32dp margin top
│                                     │ center aligned
│                                     │
│         [Verify Code]               │ Primary button, 24dp margin top
│                                     │
│     Didn't receive a code?          │ Body Medium, 32dp margin top
│           Resend (0:30)             │ Link, countdown timer
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

- **Phone Display**: Body Medium, Warm Gray 600, show formatted phone number
- **Code Input**: 6 separate input boxes, 40x48dp each, 8dp spacing
- **Auto-Advance**: Automatically advance focus between input boxes
- **Verify Button**: Enabled when all 6 digits entered
- **Resend Timer**: 30-second countdown with resend link

---

## 2. Main App Screens

### 2.1 Camera Screen (Default/Primary)

#### Layout Structure

```
┌─────────────────────────────────────┐
│  [Flash] [Settings]     [Grid] [?]  │ 16dp margins, overlay
│                                     │
│                                     │
│                                     │
│         Camera Viewfinder           │ Full screen minus UI
│              Area                   │
│                                     │
│                                     │
│                                     │
│  [Gallery]  [Capture]  [Flip]      │ Bottom controls, 24dp margin
│    48dp      80dp      48dp         │ from bottom
└─────────────────────────────────────┘
```

#### Component Specifications

**Top Controls Overlay**

- **Flash Toggle**: 24dp icon, cycles through off/auto/on states
- **Settings**: 24dp gear icon, opens camera settings modal
- **Grid Toggle**: 24dp grid icon, toggles rule of thirds overlay
- **Help**: 24dp question mark, opens camera tips

**Camera Viewfinder**

- **Full Screen**: Covers entire available area
- **Focus Indicator**: Animated circle on tap-to-focus
- **Exposure Control**: Vertical slider appears on focus tap
- **Zoom Indicator**: Pinch gesture shows zoom level (1.0x - 8.0x)

**Bottom Controls**

- **Gallery Preview**: 48dp circular thumbnail of last photo taken
- **Capture Button**: 80dp circular button, white with purple ring
- **Camera Flip**: 48dp icon, switches between front/rear camera

#### Camera States

**Capture States**

- **Ready**: White capture button with purple ring (2dp)
- **Processing**: Loading spinner inside capture button
- **Success**: Green checkmark animation, 500ms
- **Error**: Red X animation with haptic feedback

**Viewfinder Overlays**

- **Grid Lines**: Subtle white lines for rule of thirds
- **Focus Square**: Yellow square that fades after 2 seconds
- **Exposure Slider**: Vertical slider from -2.0 to +2.0 EV

### 2.2 Home Feed Screen

#### Layout Structure

```
┌─────────────────────────────────────┐
│           memore        [Profile]   │ App bar with title
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │         Friend's Photo          │ │ Card container
│ │                                 │ │ 16dp margins
│ │  [Sarah]         [2h ago] [💜]  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │         Friend's Photo          │ │
│ │                                 │ │
│ │  [Mike]          [5h ago] [💜]  │ │
│ └─────────────────────────────────┘ │
│                                     │
│            [View All]               │ Text button, center
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

**Photo Cards**

- **Card Size**: Full width minus 32dp margins, 16:9 aspect ratio
- **Corner Radius**: 12dp for modern, friendly appearance
- **Elevation**: Level 1 shadow (2dp)
- **Spacing**: 16dp between cards

**Photo Metadata**

- **Friend Name**: Label Large, Warm Gray 800, left aligned
- **Timestamp**: Body Small, Warm Gray 500, right aligned
- **Heart Icon**: 20dp purple heart, right aligned

**Photo Interactions**

- **Single Tap**: Open full-screen photo viewer
- **Double Tap**: Quick heart reaction with animation
- **Long Press**: Context menu (save, delete, report)

#### Feed States

**Loading State**

- **Skeleton Cards**: 3 skeleton placeholders while loading
- **Pull-to-Refresh**: Material design refresh indicator

**Empty State**

- **Illustration**: Friends sharing photos illustration
- **Heading**: "No new photos yet"
- **Description**: "When friends share photos, they'll appear here"
- **CTA Button**: "Invite Friends" primary button

**Error State**

- **Icon**: 48dp wifi-off icon
- **Heading**: "Connection problem"
- **Description**: "Check your internet and try again"
- **Retry Button**: Secondary button

### 2.3 Friends Management Screen

#### Layout Structure

```
┌─────────────────────────────────────┐
│     Friends          [+] [Search]   │ App bar
├─────────────────────────────────────┤
│                                     │
│ ┌─ Active Friends ─────────────────┐ │
│ │ [🟢] Sarah Johnson    [Message]  │ │ List items
│ │ [🟢] Mike Chen        [Message]  │ │ 72dp height
│ │ [⚪] Emma Davis       [Message]  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─ Pending Requests ───────────────┐ │
│ │ [?] Alex Thompson  [✓] [✗]      │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─ Sent Requests ──────────────────┐ │
│ │ [📤] Jamie Wilson    [Pending]   │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

**Friend List Items**

- **Item Height**: 72dp for comfortable touch targets
- **Avatar**: 40dp circular profile photo or initial circle
- **Online Status**: 12dp colored dot (green=online, gray=offline)
- **Name**: Label Large, Warm Gray 800
- **Action Button**: 32dp height, secondary button style

**Section Headers**

- **Typography**: Label Medium, Warm Gray 600
- **Spacing**: 24dp margin top, 8dp margin bottom
- **Divider**: 1dp line, Warm Gray 200

**Friend Actions**

- **Message Button**: Opens quick photo send interface
- **Accept/Decline**: Green check (32dp) and red X (32dp) buttons
- **Pending Indicator**: Body Small, Warm Gray 500 text

### 2.4 Profile Screen

#### Layout Structure

```
┌─────────────────────────────────────┐
│              Profile    [Settings]  │ App bar
├─────────────────────────────────────┤
│                                     │
│         [Profile Photo]             │ 80dp circular avatar
│                                     │ 32dp margin top
│                                     │
│          Sarah Johnson              │ H2, center aligned
│         @sarahj • 24 friends        │ Body Medium, center
│                                     │
│    ┌─ Recent Photos ─────────────┐  │ 32dp margin top
│    │ [📸] [📸] [📸] [📸] [📸]  │  │ 5 recent thumbnails
│    └─────────────────────────────┘  │ 60dp each
│                                     │
│         [Edit Profile]              │ Secondary button
│                                     │ 24dp margin top
│         [Photo History]             │ Secondary button
│                                     │ 16dp margin top
│         [Friend Requests]           │ Secondary button
│                                     │ 16dp margin top
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

**Profile Header**

- **Avatar**: 80dp circle with 2dp purple border when active
- **Name**: H2 typography, Warm Gray 800
- **Stats**: Body Medium, Warm Gray 600, includes username and friend count

**Recent Photos Grid**

- **Thumbnails**: 60x60dp squares, 8dp spacing
- **Corner Radius**: 8dp
- **Tap Action**: Open photo in full-screen viewer

**Action Buttons**

- **Button Style**: Secondary buttons, full width minus 32dp margins
- **Height**: 48dp each
- **Spacing**: 16dp between buttons

---

## 3. Modal Screens & Dialogs

### 3.1 Photo Send Modal

#### Layout Structure

```
┌─────────────────────────────────────┐
│    [×]      Send Photo     [Send]   │ Modal header
├─────────────────────────────────────┤
│                                     │
│         [Photo Preview]             │ 200dp height, center
│                                     │ with corner radius
│                                     │
│           Send to...                │ Label Medium, 24dp margin
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [✓] Sarah Johnson               │ │ Friend selection
│ │ [✓] Mike Chen                   │ │ checkboxes
│ │ [ ] Emma Davis                  │ │
│ │ [ ] Alex Thompson               │ │
│ └─────────────────────────────────┘ │
│                                     │
│         [Add Caption]               │ Text input, optional
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

**Modal Container**

- **Background**: White with rounded top corners (16dp)
- **Height**: 60% of screen height
- **Slide Animation**: Slides up from bottom

**Photo Preview**

- **Size**: 200x200dp maximum, maintains aspect ratio
- **Corner Radius**: 12dp
- **Border**: 1dp Warm Gray 200

**Friend Selection**

- **Checkboxes**: Material 3 checkbox style
- **Selection Limit**: Maximum 5 friends at once
- **Counter**: "2 of 5 selected" helper text

### 3.2 Settings Modal

#### Layout Structure

```
┌─────────────────────────────────────┐
│    [×]        Settings              │ Modal header
├─────────────────────────────────────┤
│                                     │
│ ┌─ Account ────────────────────────┐ │
│ │   Edit Profile            [>]   │ │
│ │   Privacy Settings        [>]   │ │
│ │   Blocked Users           [>]   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─ Notifications ──────────────────┐ │
│ │   Push Notifications     [🔘]   │ │ Toggle switch
│ │   Photo Reactions        [🔘]   │ │
│ │   Friend Requests        [🔘]   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─ App ────────────────────────────┐ │
│ │   Widget Setup            [>]   │ │
│ │   Data Usage             [>]   │ │
│ │   Help & Support         [>]   │ │
│ │   About                  [>]   │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

#### Component Specifications

**Setting Sections**

- **Section Headers**: Label Medium, Warm Gray 600
- **Item Height**: 56dp for comfortable interaction
- **Dividers**: 1dp lines between sections

**Setting Items**

- **Text**: Body Large, Warm Gray 800
- **Toggle Switches**: Material 3 switch component
- **Chevron Icons**: 16dp right arrow for navigation items

---

## 4. Error & Empty States

### 4.1 Network Error State

```
┌─────────────────────────────────────┐
│                                     │
│         [📶❌ Icon]                 │ 48dp icon, center
│                                     │
│        Connection Problem           │ H3, center aligned
│                                     │ 16dp margin top
│    Check your internet connection  │ Body Large, center
│      and try again                 │ 16dp margin top
│                                     │
│           [Try Again]               │ Primary button
│                                     │ 32dp margin top
│                                     │
└─────────────────────────────────────┘
```

### 4.2 Camera Permission Error

```
┌─────────────────────────────────────┐
│                                     │
│         [📷🚫 Icon]                 │ 48dp icon, center
│                                     │
│      Camera Access Needed          │ H3, center aligned
│                                     │
│    memore needs camera access to   │ Body Large, center
│       capture and share photos     │ 16dp margins
│                                     │
│        [Open Settings]              │ Primary button
│                                     │ 24dp margin top
│         [Not Now]                   │ Text button
│                                     │ 16dp margin top
│                                     │
└─────────────────────────────────────┘
```

---

## 5. Responsive Design Considerations

### Screen Size Adaptations

#### Small Phones (<360dp width)

- Reduce horizontal margins from 16dp to 12dp
- Stack bottom navigation icons vertically if needed
- Reduce photo grid from 5 to 4 columns in history
- Compress camera controls spacing

#### Large Phones (>414dp width)

- Increase maximum content width to 600dp with center alignment
- Add more whitespace in layouts
- Use larger touch targets (48dp minimum)
- Consider two-column layout for settings

#### Tablets (>600dp width)

- Two-panel layout with navigation on left
- Larger photo previews and grid layouts
- Increased typography sizes for readability
- Master-detail navigation patterns

### Orientation Handling

#### Portrait Mode (Default)

- All layouts optimized for portrait orientation
- Camera uses full screen in portrait
- Navigation remains at bottom

#### Landscape Mode

- Camera rotates viewfinder but keeps controls accessible
- Photo viewing optimized for landscape aspect ratios
- Navigation may move to side for tablets
- Some modals become side panels

### Accessibility Compliance

#### Touch Targets

- Minimum 48x48dp touch targets
- 8dp spacing between interactive elements
- Clear visual feedback for all interactions

#### Text Scaling

- Support dynamic text sizing up to 200%
- Maintain layout integrity at large text sizes
- Provide alternative layouts for extreme scaling

#### Color Contrast

- All text meets WCAG 2.1 AA contrast ratios
- Interactive elements have 3:1 minimum contrast
- Focus indicators meet accessibility requirements

---

## 6. Animation Specifications

### Screen Transitions

- **Tab Changes**: Cross-fade, 250ms standard curve
- **Modal Open**: Slide up from bottom, 300ms decelerate curve
- **Screen Push**: Slide left/right, 300ms standard curve
- **Modal Dismiss**: Slide down to bottom, 250ms accelerate curve

### Micro-Interactions

- **Button Press**: Scale to 0.98, 100ms sharp curve
- **Photo Like**: Heart scale pulse, 400ms bounce effect
- **Success State**: Check mark draw animation, 500ms
- **Loading Spinner**: Continuous rotation, 1000ms linear

### Photo Interactions

- **Photo Upload**: Progress bar with fade-in preview
- **Photo Receive**: Gentle bounce in with fade
- **Gallery Scroll**: Parallax effect on photo movement
- **Full Screen**: Shared element transition from thumbnail
