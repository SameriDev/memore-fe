# memore Design System

## Design Philosophy

memore's design system emphasizes **authentic intimacy** through a clean, approachable interface that gets out of the way of genuine human connections. The design prioritizes simplicity, warmth, and trust while maintaining a modern, youthful aesthetic.

### Core Principles

1. **Authentic over Perfect**: Encourage real moments without pressure
2. **Intimate over Public**: Design for small circles, not broadcast
3. **Simple over Complex**: Clear navigation and minimal cognitive load
4. **Warm over Clinical**: Friendly, human-centered interactions
5. **Trustworthy over Flashy**: Build confidence in privacy and reliability

---

## Color Palette

### Primary Colors

#### Brand Primary

- **memore Purple**: `#6366F1` (Purple 500)
  - Usage: Primary buttons, active states, brand accents
  - Accessibility: WCAG AAA compliant on white backgrounds
  - Meaning: Trust, intimacy, connection

#### Supporting Primary

- **Soft Purple**: `#8B5CF6` (Violet 500)
  - Usage: Secondary actions, gradients, highlights
  - Accessibility: WCAG AA compliant
  - Meaning: Creativity, friendliness

### Secondary Colors

#### Warm Neutrals

- **Warm Gray 50**: `#FAFAF9` - Background, cards
- **Warm Gray 100**: `#F5F5F4` - Secondary backgrounds
- **Warm Gray 200**: `#E7E5E4` - Borders, dividers
- **Warm Gray 300**: `#D6D3D1` - Disabled states
- **Warm Gray 400**: `#A8A29E` - Secondary text
- **Warm Gray 500**: `#78716C` - Primary text
- **Warm Gray 600**: `#57534E` - Headings
- **Warm Gray 800**: `#292524` - High emphasis text
- **Warm Gray 900**: `#1C1917` - Maximum contrast

### Accent Colors

#### Success (Photo Sharing Success)

- **Success Green**: `#10B981` (Emerald 500)
- **Success Light**: `#D1FAE5` (Emerald 100)
- **Usage**: Photo upload success, friend connections

#### Warning (Notifications)

- **Warning Orange**: `#F59E0B` (Amber 500)
- **Warning Light**: `#FEF3C7` (Amber 100)
- **Usage**: Friend requests, pending actions

#### Error (Connection Issues)

- **Error Red**: `#EF4444` (Red 500)
- **Error Light**: `#FEE2E2` (Red 100)
- **Usage**: Upload failures, connection errors

#### Info (Tips and Help)

- **Info Blue**: `#3B82F6` (Blue 500)
- **Info Light**: `#DBEAFE` (Blue 100)
- **Usage**: Help text, tips, information

### Color Usage Guidelines

#### Backgrounds

- **Primary Surface**: Warm Gray 50 (`#FAFAF9`)
- **Secondary Surface**: White (`#FFFFFF`)
- **Card Background**: White with subtle shadow
- **Modal Background**: Semi-transparent overlay

#### Text Hierarchy

- **Primary Text**: Warm Gray 800 (`#292524`)
- **Secondary Text**: Warm Gray 500 (`#78716C`)
- **Caption Text**: Warm Gray 400 (`#A8A29E`)
- **Link Text**: memore Purple (`#6366F1`)

#### Interactive Elements

- **Primary Action**: memore Purple background
- **Secondary Action**: Warm Gray 100 background
- **Danger Action**: Error Red background
- **Link Action**: memore Purple text

---

## Typography

### Font Family

**Primary**: SF Pro (iOS) / Roboto (Android)

- Reasoning: Platform-native fonts for optimal readability and performance
- Fallback: System default sans-serif

### Type Scale

#### Headings

```
H1 - Display Large
- Font Size: 32sp (Android) / 32pt (iOS)
- Line Height: 40sp/pt
- Font Weight: Bold (700)
- Letter Spacing: -0.25sp/pt
- Usage: Page titles, main headers

H2 - Display Medium
- Font Size: 28sp/pt
- Line Height: 36sp/pt
- Font Weight: Semibold (600)
- Letter Spacing: 0sp/pt
- Usage: Section headers, modal titles

H3 - Display Small
- Font Size: 24sp/pt
- Line Height: 32sp/pt
- Font Weight: Semibold (600)
- Letter Spacing: 0sp/pt
- Usage: Card headers, subsection titles

H4 - Headline Large
- Font Size: 20sp/pt
- Line Height: 28sp/pt
- Font Weight: Medium (500)
- Letter Spacing: 0sp/pt
- Usage: List headers, prominent labels
```

#### Body Text

```
Body Large
- Font Size: 16sp/pt
- Line Height: 24sp/pt
- Font Weight: Regular (400)
- Letter Spacing: 0.15sp/pt
- Usage: Primary body text, descriptions

Body Medium
- Font Size: 14sp/pt
- Line Height: 20sp/pt
- Font Weight: Regular (400)
- Letter Spacing: 0.25sp/pt
- Usage: Secondary text, captions

Body Small
- Font Size: 12sp/pt
- Line Height: 16sp/pt
- Font Weight: Regular (400)
- Letter Spacing: 0.4sp/pt
- Usage: Timestamps, helper text
```

#### Labels & Buttons

```
Label Large (Buttons)
- Font Size: 16sp/pt
- Line Height: 20sp/pt
- Font Weight: Medium (500)
- Letter Spacing: 0.1sp/pt
- Usage: Primary buttons, CTAs

Label Medium (Form Labels)
- Font Size: 14sp/pt
- Line Height: 18sp/pt
- Font Weight: Medium (500)
- Letter Spacing: 0.25sp/pt
- Usage: Form labels, navigation items

Label Small (Chips, Tags)
- Font Size: 12sp/pt
- Line Height: 16sp/pt
- Font Weight: Medium (500)
- Letter Spacing: 0.5sp/pt
- Usage: Status indicators, tags
```

### Typography Usage Guidelines

#### Accessibility

- Minimum text size: 12sp/pt
- Color contrast ratio: Minimum 4.5:1 for normal text
- Color contrast ratio: Minimum 3:1 for large text (18sp+ or 14sp+ bold)
- Support dynamic type scaling (iOS) and font scale preferences (Android)

#### Content Hierarchy

1. **Page Title** (H1): Main screen identification
2. **Section Header** (H2): Major content sections
3. **Content Header** (H3): Individual content items
4. **Body Text** (Body Large): Primary readable content
5. **Supporting Text** (Body Medium): Secondary information
6. **Metadata** (Body Small): Timestamps, counts, helper text

---

## Iconography

### Icon Style

- **Style**: Rounded, friendly icons with consistent stroke weight
- **Stroke Width**: 2px at 24x24 size
- **Corner Radius**: 2px radius on square elements
- **Grid**: Based on 24x24 pixel grid system

### Icon Library

#### Navigation Icons

- **Home**: House outline with rounded corners
- **Camera**: Camera with circular lens, friendly styling
- **Friends**: Two overlapping circles representing people
- **Profile**: Simple circle with person silhouette
- **History**: Clock with counter-clockwise arrow

#### Action Icons

- **Add/Plus**: Rounded plus symbol
- **Send**: Paper airplane, angled upward
- **Share**: Connected dots representing sharing
- **Delete**: Trash can with rounded corners
- **Edit**: Pencil with rounded tip
- **Settings**: Gear with rounded teeth

#### Status Icons

- **Check/Success**: Rounded checkmark
- **Warning**: Triangle with exclamation mark
- **Error**: Circle with X
- **Info**: Circle with lowercase 'i'
- **Loading**: Animated circular progress

#### Social Icons

- **Heart**: Rounded heart for favorites
- **Star**: Five-pointed star with rounded points
- **Comment**: Speech bubble with rounded corners
- **Notification**: Bell with gentle curve
- **Online Status**: Small filled circle

### Icon Sizing

- **Small**: 16x16dp (list items, inline text)
- **Medium**: 24x24dp (primary actions, navigation)
- **Large**: 32x32dp (prominent actions, headers)
- **X-Large**: 48x48dp (empty states, onboarding)

### Icon Colors

- **Primary**: Warm Gray 600 (`#57534E`)
- **Active/Selected**: memore Purple (`#6366F1`)
- **Disabled**: Warm Gray 300 (`#D6D3D1`)
- **Inverse**: White (`#FFFFFF`) on colored backgrounds

---

## Layout Principles

### Grid System

- **Base Unit**: 8dp/pt grid system
- **Column Grid**: 4 columns on mobile, 8+ on tablets
- **Margins**: 16dp/pt on mobile, 24dp/pt on tablets
- **Gutters**: 16dp/pt between columns

### Spacing Scale

```
Micro: 2dp/pt
Tiny: 4dp/pt
Small: 8dp/pt
Medium: 16dp/pt
Large: 24dp/pt
XL: 32dp/pt
XXL: 48dp/pt
Huge: 64dp/pt
```

### Content Spacing

- **Section Spacing**: 32dp/pt between major sections
- **Content Spacing**: 16dp/pt between related items
- **Text Spacing**: 8dp/pt between text blocks
- **Element Spacing**: 4dp/pt between closely related elements

### Screen Margins

- **Mobile**: 16dp/pt horizontal margins
- **Tablet**: 24dp/pt horizontal margins
- **Max Width**: 600dp/pt for optimal readability

---

## Visual Elements

### Elevation & Shadows

#### Material Design 3 Elevation

```
Level 0 (No Elevation)
- Background surfaces
- Shadow: None

Level 1 (Subtle)
- Cards, contained buttons
- Shadow: 0dp 1dp 2dp rgba(0,0,0,0.1)

Level 2 (Low)
- Floating action buttons
- Shadow: 0dp 1dp 5dp rgba(0,0,0,0.12)

Level 3 (Medium)
- App bars, navigation
- Shadow: 0dp 4dp 8dp rgba(0,0,0,0.12)

Level 4 (High)
- Modal dialogs
- Shadow: 0dp 6dp 10dp rgba(0,0,0,0.14)

Level 5 (Highest)
- Tooltips, menus
- Shadow: 0dp 8dp 12dp rgba(0,0,0,0.15)
```

### Border Radius

- **Small**: 4dp/pt (buttons, small cards)
- **Medium**: 8dp/pt (standard cards, inputs)
- **Large**: 12dp/pt (modal dialogs)
- **XL**: 16dp/pt (prominent cards)
- **Pill**: 999dp/pt (circular buttons, badges)

### Border Styles

- **Standard Border**: 1dp/pt solid, Warm Gray 200
- **Focus Border**: 2dp/pt solid, memore Purple
- **Error Border**: 1dp/pt solid, Error Red
- **Disabled Border**: 1dp/pt solid, Warm Gray 100

### Gradients

```
Brand Gradient (Primary)
- Start: memore Purple (#6366F1)
- End: Soft Purple (#8B5CF6)
- Angle: 135° (diagonal)

Subtle Background Gradient
- Start: White (#FFFFFF)
- End: Warm Gray 50 (#FAFAF9)
- Angle: 180° (vertical)

Success Gradient (Confirmations)
- Start: Success Green (#10B981)
- End: Emerald 600 (#059669)
- Angle: 135° (diagonal)
```

---

## Animation & Motion

### Animation Principles

- **Subtle**: Animations should enhance, not distract
- **Fast**: Keep animations under 300ms for interactions
- **Natural**: Use easing curves that feel organic
- **Purposeful**: Every animation should serve a function

### Timing Functions

```
Standard Curve
- CSS: cubic-bezier(0.2, 0.0, 0.2, 1.0)
- Duration: 250ms
- Usage: Standard UI transitions

Accelerate Curve
- CSS: cubic-bezier(0.3, 0.0, 0.8, 0.15)
- Duration: 200ms
- Usage: Elements leaving screen

Decelerate Curve
- CSS: cubic-bezier(0.0, 0.0, 0.3, 1.0)
- Duration: 250ms
- Usage: Elements entering screen

Sharp Curve
- CSS: cubic-bezier(0.4, 0.0, 0.6, 1.0)
- Duration: 200ms
- Usage: Quick interactions, toggles
```

### Common Animations

- **Button Press**: Scale down to 0.95, 100ms sharp curve
- **Card Appear**: Slide up 20dp + fade in, 250ms decelerate
- **Page Transition**: Slide horizontal, 300ms standard curve
- **Modal Open**: Scale from 0.9 + fade in, 250ms decelerate
- **Success State**: Scale pulse to 1.1 then back, 400ms total

---

## Accessibility

### Color Accessibility

- All text meets WCAG 2.1 AA contrast requirements
- Interactive elements have 3:1 minimum contrast ratio
- Color is never the only indicator of state or meaning
- High contrast mode support for low vision users

### Touch Accessibility

- Minimum touch target: 44x44dp/pt
- Interactive elements spaced at least 8dp/pt apart
- Clear visual feedback for all interactive states
- Support for device accessibility features

### Screen Reader Support

- All images have descriptive alt text
- Interactive elements have appropriate labels
- Content hierarchy is properly structured
- Navigation landmarks are defined

### Keyboard Navigation

- All interactive elements are focusable
- Focus indicators meet 2.4:1 contrast requirement
- Logical tab order throughout the interface
- Keyboard shortcuts for common actions

---

## Platform Considerations

### Android Material Design 3

- Follow Material You dynamic theming guidelines
- Implement proper elevation and surface colors
- Use Material Components for consistency
- Support Android 12+ themed icons

### iOS Human Interface Guidelines

- Respect iOS navigation patterns and conventions
- Implement proper iOS typography scaling
- Use SF Symbols where appropriate
- Support iOS accessibility features like Voice Control

### Cross-Platform Consistency

- Maintain brand identity across platforms
- Adapt to platform-specific patterns when necessary
- Ensure feature parity between iOS and Android
- Test extensively on both platforms
