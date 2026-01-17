# Locket Navigation Flow

## App Architecture Overview

Locket follows a **task-oriented navigation** approach, designed around the core user behaviors: capturing moments, viewing friends' photos, and managing connections. The navigation prioritizes speed and simplicity over feature discovery.

### Navigation Philosophy
- **Gesture-First**: Prioritize swipe gestures and natural touch interactions
- **Context-Aware**: Show relevant actions based on current state
- **Minimal Hierarchy**: Keep navigation depth shallow (max 3 levels)
- **Quick Access**: Essential features accessible within 1-2 taps

---

## Information Architecture

### Primary Navigation Structure
```
Locket App
├── 📸 Camera/Capture (Default)
├── 🏠 Home Feed
├── 👥 Friends Management
├── 📱 Widget Management (Settings)
└── 👤 Profile & Settings
```

### Navigation Hierarchy
```
Level 1: Tab Navigation (Bottom Navigation Bar)
├── Camera Tab (Default/Primary)
├── Home Tab
├── Friends Tab
└── Profile Tab

Level 2: Screen-Specific Actions (Top App Bar)
├── Modal Overlays
├── Context Menus
└── Settings Screens

Level 3: Deep Actions (Full Screen Modals)
├── Photo Edit/Send
├── Friend Profile Details
├── Widget Configuration
└── App Settings
```

---

## Primary Navigation (Bottom Navigation)

### Tab Configuration

#### 1. Camera Tab (Default) 📸
- **Icon**: Camera outline (24dp)
- **Active State**: Purple fill with white camera icon
- **Default State**: This tab is the app's default landing screen
- **Purpose**: Primary photo capture interface

#### 2. Home Tab 🏠
- **Icon**: House outline (24dp)
- **Badge**: Red dot indicator for new photos
- **Purpose**: View received photos and feed

#### 3. Friends Tab 👥
- **Icon**: Two circles representing people (24dp)
- **Badge**: Number badge for pending friend requests
- **Purpose**: Manage friend connections and requests

#### 4. Profile Tab 👤
- **Icon**: Circle with person silhouette (24dp)
- **Purpose**: User profile, settings, and app preferences

### Navigation Behavior

#### Tab Switching
- **Single Tap**: Switch to selected tab
- **Double Tap**: Refresh current tab content (pull-to-refresh alternative)
- **Animation**: Smooth cross-fade between tabs (250ms)

#### Tab Persistence
- Each tab maintains its scroll position and state
- Camera maintains current mode (front/back camera)
- Home tab remembers last viewed position in feed
- Background tabs refresh content periodically

---

## Screen Flows & User Journeys

### 1. First-Time User Flow (Onboarding)

```
App Launch → Phone Verification → Permission Requests → Widget Setup → Friend Invites → Main App
```

#### Detailed Flow:
1. **Welcome Screen**
   - App introduction with key benefits
   - "Get Started" primary CTA button
   - "Learn More" secondary link

2. **Phone Number Verification**
   - Phone input with country code selector
   - SMS verification code entry
   - Auto-advance on code completion

3. **Permission Requests** (Sequential)
   - Camera access with explanation
   - Photo library access with purpose
   - Notification permission with benefits
   - Contacts access (optional) for friend discovery

4. **Widget Setup Tutorial**
   - Step-by-step widget installation guide
   - Platform-specific instructions (iOS/Android)
   - "Skip for now" option with reminder

5. **Friend Invitations**
   - Contact list integration (if permitted)
   - Manual phone number entry
   - "Skip and explore" option

6. **First Photo Capture**
   - Guided camera interface tour
   - Encourage first photo capture
   - Celebration animation on completion

### 2. Daily Usage Flow (Primary User Journey)

```
Widget View → App Launch → Camera → Capture → Friend Selection → Send → Home Feed
```

#### Detailed Flow:
1. **Widget Interaction**
   - User sees new photo on home screen widget
   - Tap widget to open app to Home tab
   - Long press widget for quick actions menu

2. **Photo Response Flow**
   - Quick swipe to Camera tab from Home
   - Capture response photo
   - Auto-suggest previous sender for quick response
   - Send with single tap

3. **Browse & Engage**
   - Swipe through received photos in Home feed
   - Tap photo for full-screen view
   - React or respond to specific photos

### 3. Friend Management Flow

```
Friends Tab → Add Friend → Contact Selection/Manual Entry → Send Request → Confirmation
```

#### Detailed Flow:
1. **Friend Discovery**
   - Contact list with Locket users highlighted
   - Search by phone number or username
   - Friend suggestion based on mutual connections

2. **Connection Request**
   - Add friend button with personalized message option
   - Request status tracking (pending/accepted/declined)
   - Notification when request is accepted

3. **Friend List Management**
   - Alphabetical friend list with online status
   - Swipe actions for quick access (message, remove, etc.)
   - Friend profile access with shared photo history

---

## Secondary Navigation Patterns

### Modal Dialogs
- **Slide up** from bottom for action sheets
- **Fade in** center for confirmations
- **Full screen** for complex forms (settings, profile edit)

### Contextual Menus
- **Long press** on photos for options menu
- **Three-dot menu** in app bars for screen-specific actions
- **Swipe actions** on list items (friends, photo history)

### Deep Linking
- **Friend invites**: Direct link to add specific friend
- **Photo sharing**: Link to specific photo thread
- **Widget setup**: Direct to widget configuration

---

## Gesture Navigation

### Primary Gestures

#### Camera Screen
- **Tap**: Capture photo
- **Long press**: Record video (future feature)
- **Swipe up**: Switch to front camera
- **Swipe down**: Switch to back camera
- **Pinch**: Zoom in/out
- **Double tap**: Toggle flash

#### Home Feed
- **Swipe down**: Pull to refresh
- **Swipe left/right**: Navigate between photos
- **Tap**: View full-screen photo
- **Double tap**: Quick react (heart)
- **Long press**: Show context menu (save, delete, etc.)

#### Friend List
- **Swipe right**: Quick message/photo send
- **Swipe left**: Remove friend (with confirmation)
- **Pull down**: Refresh friend status
- **Tap**: View friend profile

### Universal Gestures
- **Back navigation**: Swipe from left edge (iOS) or back button/gesture (Android)
- **Share**: Standard platform share gesture integration
- **Screenshot prevention**: Block screenshots in sensitive areas

---

## Navigation States & Feedback

### Loading States
- **Tab switching**: Smooth animation with skeleton loading
- **Photo upload**: Progress indicator with cancel option
- **Friend requests**: Pending state with clear feedback
- **Widget updates**: Background refresh with subtle indicator

### Error States
- **Network error**: Retry mechanism with clear error message
- **Camera error**: Permission prompt and troubleshooting
- **Upload failure**: Automatic retry with user notification
- **Widget error**: Setup guidance and refresh options

### Empty States
- **No friends**: Prominent "Add Friends" CTA with illustration
- **No photos**: Encouraging first photo capture with tips
- **No new updates**: Friendly message with suggested actions
- **Camera blocked**: Clear permission instructions with deep link

---

## Platform-Specific Navigation

### iOS Navigation Patterns

#### Navigation Bar
- **Title**: Large title style for main screens
- **Back button**: Standard iOS back arrow with page title
- **Action buttons**: Right-aligned with standard iOS icons

#### Tab Bar
- **Selected state**: Filled icon with purple tint
- **Badge indicators**: Red badges following iOS HIG
- **Haptic feedback**: Light haptic on tab selection

#### Gestures
- **Swipe back**: Full support for edge swipe navigation
- **Pull to refresh**: Standard iOS refresh control
- **3D Touch/Haptic Touch**: Preview photos and quick actions

### Android Navigation Patterns

#### App Bar
- **Navigation icon**: Hamburger menu or back arrow as appropriate
- **Action overflow**: Three-dot menu for additional actions
- **Elevation**: Material Design elevation on scroll

#### Bottom Navigation
- **Material ripple**: Ripple effect on tab selection
- **Badge styling**: Circular badges following Material guidelines
- **Color theming**: Support for Material You dynamic colors

#### Gestures
- **Swipe back**: Support for gesture navigation
- **Floating Action Button**: Camera FAB on relevant screens
- **Material motion**: Shared element transitions between screens

---

## Accessibility Navigation

### Screen Reader Support
- **Tab announcements**: Clear tab names and purposes
- **Content descriptions**: Descriptive labels for all interactive elements
- **Navigation landmarks**: Proper heading structure and landmarks
- **State announcements**: Clear feedback for actions and state changes

### Keyboard Navigation
- **Tab order**: Logical progression through interactive elements
- **Focus indicators**: Clear visual focus states meeting contrast requirements
- **Keyboard shortcuts**: Standard shortcuts for common actions
- **Escape sequences**: Proper modal dismissal with escape key

### Voice Control
- **Voice labels**: Unique voice control names for elements
- **Action phrases**: Standard phrases like "tap camera" work as expected
- **Custom commands**: App-specific voice commands for power users

---

## Navigation Performance

### Optimization Strategies
- **Tab pre-loading**: Background content loading for faster tab switches
- **Image lazy loading**: Progressive photo loading in feeds
- **Route caching**: Cache navigation state for quick app restoration
- **Gesture debouncing**: Prevent accidental double-taps and rapid gestures

### Memory Management
- **Tab state management**: Intelligent background tab refresh policies
- **Image memory**: Automatic image cleanup and compression
- **Navigation stack**: Limit deep navigation stack accumulation
- **Background updates**: Efficient background refresh mechanisms

### Performance Metrics
- **Tab switch time**: Target <100ms for tab switching
- **Screen load time**: Target <300ms for screen rendering
- **Gesture response**: Target <16ms for gesture acknowledgment
- **Deep link time**: Target <500ms for deep link resolution

---

## Navigation Analytics

### User Behavior Tracking
- **Tab usage patterns**: Most frequently used tabs and sequences
- **Navigation depth**: How deep users navigate before returning
- **Gesture adoption**: Which gestures users discover and use
- **Drop-off points**: Where users exit or get lost in flows

### Optimization Insights
- **Popular paths**: Most common user journeys for optimization
- **Pain points**: Navigation steps with high abandonment
- **Feature discovery**: How users find and adopt new features
- **Platform differences**: iOS vs Android behavior patterns

### Success Metrics
- **Task completion rate**: Successfully completing core user flows
- **Navigation efficiency**: Steps to complete common tasks
- **Error recovery**: How well users recover from navigation errors
- **User satisfaction**: Qualitative feedback on navigation experience