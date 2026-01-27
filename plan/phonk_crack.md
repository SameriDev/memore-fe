# PHONG CÁCH THIẾT KẾ ỨNG DỤNG PHOTO SHARING WIDGET

## TỔNG QUAN PHONG CÁCH

Thiết kế theo phong cách Minimalist Premium với cảm hứng từ social media hiện đại, tập trung vào trải nghiệm xem ảnh và chia sẻ khoảnh khắc. Giao diện sạch sẽ, tối giản nhưng vẫn ấm áp và thân thiện.

## 1. BẢNG MÀU (COLOR PALETTE)

### Màu nền chính

- Background chính: Màu kem nhạt, beige rất sáng (gần trắng nhưng ấm hơn) - HEX: #F5F3F0 hoặc #FAF9F7
- Background phụ: Trắng tinh (#FFFFFF) cho các card và modal

### Màu chữ

- Text chính: Màu đen tuyền (#000000) - high contrast, rõ ràng
- Text phụ: Màu xám đậm (#666666 hoặc #808080) cho thông tin ít quan trọng
- Text placeholder: Màu xám nhạt (#AAAAAA hoặc #C0C0C0)

### Màu accent

- Primary action: Màu vàng ấm, mustard yellow (#F4C542 hoặc #FFD700) - sử dụng cho buttons chính, icons active
- Secondary: Màu be/vàng nhạt hơn cho hover states
- Không sử dụng màu sắc quá rực rỡ

### Màu border và divider

- Border nhẹ: Màu xám rất nhạt (#E5E5E5 hoặc #EBEBEB)
- Shadow: Shadow nhẹ, subtle với opacity thấp

## 2. TYPOGRAPHY (PHÔNG CHỮ)

### Font family

- Sử dụng font sans-serif hiện đại, clean
- Gợi ý: SF Pro Display (iOS style), Inter, Roboto, hoặc similar system font
- Không sử dụng font serif hay script

### Font sizes và weights

- Heading lớn (Screen titles): 24-28px, Font weight 700 (Bold)
- Heading nhỏ (Section titles): 18-20px, Font weight 600 (Semibold)
- Body text: 15-16px, Font weight 400 (Regular)
- Caption/small text: 12-14px, Font weight 400-500
- Button text: 15-16px, Font weight 600 (Semibold)

### Text alignment

- Heading: Căn trái hoặc căn giữa tùy context
- Body: Chủ yếu căn trái
- Buttons: Text căn giữa

## 3. LAYOUT VÀ SPACING

### Screen structure

- Safe area padding: 16-20px từ các cạnh màn hình
- Vertical spacing giữa sections: 24-32px
- Spacing giữa các elements trong cùng group: 12-16px

### Grid system

- Photo grid sử dụng 2-3 columns
- Gap giữa các ảnh trong grid: 8-12px
- Ảnh có corner radius nhẹ: 12-16px

### Container

- Card containers có corner radius: 16-24px
- Padding trong card: 16-20px
- Shadow cho cards: Subtle, offset Y: 2-4px, blur: 8-12px, opacity: 0.08-0.12

## 4. COMPONENTS CHI TIẾT

### Navigation bar

- Height: 56-60px
- Background: Trong suốt hoặc background màu kem nhạt
- Title: Căn trái hoặc giữa, font size 20-24px, bold
- Icons: Black, size 24x24px
- Không có bottom border đậm, có thể có shadow nhẹ khi scroll

### Avatar

- Avatar tròn hoàn toàn (border-radius: 50%)
- Size nhỏ: 32-36px (trong lists)
- Size trung bình: 48-56px (trong headers)
- Size lớn: 80-100px (trong profile screen)
- Border nhẹ màu trắng hoặc xám nhạt nếu cần

### Buttons

#### Primary button (action chính)

- Background: Màu đen (#000000)
- Text: Màu trắng (#FFFFFF)
- Border radius: 24-28px (pill shape - tròn đầu)
- Height: 48-52px
- Font weight: 600 (Semibold)
- Hover/Press: Background chuyển sang gray đậm (#333333)

#### Secondary button (action phụ)

- Background: Màu vàng accent (#F4C542)
- Text: Màu đen (#000000)
- Border radius: 24-28px
- Height: 44-48px
- Font weight: 600

#### Tertiary button (ghost/outline)

- Background: Transparent
- Border: 1-2px solid black hoặc gray
- Text: Màu đen
- Border radius: 24-28px
- Height: 44-48px

#### Icon buttons

- Circular: Đường kính 40-44px, border-radius 50%
- Background: Transparent hoặc màu đen với opacity 0.05 khi hover
- Icon: 24x24px, màu đen

### Input fields

- Background: Trắng với border xám nhạt (#E5E5E5)
- Border radius: 12-16px
- Height: 48-52px
- Padding horizontal: 16-20px
- Font size: 15-16px
- Placeholder: Màu xám nhạt (#AAAAAA)
- Focus state: Border chuyển sang đen hoặc accent color

### Photo cards/thumbnails

- Border radius: 12-16px
- Aspect ratio: Square (1:1) hoặc portrait (3:4 hoặc 9:16)
- Overlay gradient khi có text: Linear gradient từ transparent đến rgba(0,0,0,0.5) ở phía dưới
- Hover/tap: Scale nhẹ (1.02-1.05) hoặc shadow tăng lên

### List items

- Height: 56-64px cho mỗi item
- Padding horizontal: 16-20px
- Divider: Line 1px màu xám nhạt (#EBEBEB) hoặc không có divider
- Avatar ở bên trái, text info ở giữa, action icon/button ở bên phải
- Tap state: Background chuyển sang màu kem/xám nhạt (#F5F5F5)

### Bottom navigation (nếu có)

- Height: 64-72px (bao gồm safe area)
- Background: Trắng với shadow nhẹ ở trên
- Icons: 24-28px
- Active icon: Màu vàng accent hoặc đen với indicator dot/bar
- Inactive icon: Màu xám (#808080)
- Labels (nếu có): 11-12px

### Camera viewfinder overlay

- Fullscreen với UI overlay
- Nút chụp: Circle lớn 72-80px, màu trắng với border dày
- Icons phụ (flash, flip): 24-28px, màu trắng với background đen opacity 0.3
- Positioning: Nút chụp ở dưới giữa, icons phụ hai bên

### Modals và dialogs

- Background: Trắng
- Border radius: 24-28px ở góc trên (bottom sheet) hoặc toàn bộ (centered modal)
- Padding: 24-28px
- Handle bar (nếu là bottom sheet): Width 36-40px, height 4-5px, màu xám nhạt, centered ở trên cùng
- Shadow: Prominent shadow với opacity 0.15-0.2

## 5. ICONS VÀ IMAGERY

### Icon style

- Sử dụng line icons (outline style), không fill
- Stroke width: 2px (regular) hoặc 2.5px (medium)
- Rounded corners cho icons
- Icon set gợi ý: SF Symbols (iOS), Material Icons Outlined, Feather Icons, hoặc Lucide

### Icon sizes

- Small: 16-18px
- Regular: 24-28px
- Large: 32-36px

### Icon colors

- Default: Đen (#000000)
- Inactive: Xám (#808080)
- Active/selected: Vàng accent (#F4C542)

### Photo display

- Ảnh luôn có corner radius: 12-16px
- Không bao giờ hiển thị ảnh vuông góc hoàn toàn
- Aspect ratio giữ nguyên, không crop bất thường
- Loading state: Skeleton với màu xám nhạt (#F0F0F0)

## 6. ANIMATIONS VÀ TRANSITIONS

### Timing

- Duration ngắn: 200-250ms (button press, icon changes)
- Duration trung bình: 300-350ms (screen transitions, modal appear)
- Duration dài: 400-500ms (complex animations)

### Easing

- Ease-out: Cho enter animations (elements xuất hiện)
- Ease-in-out: Cho transitions giữa states
- Spring animation: Cho interactive elements (buttons, cards) - feel tự nhiên hơn

### Specific animations

- Button tap: Scale down nhẹ (0.95-0.97) rồi trở lại
- Card/photo tap: Scale up nhẹ (1.02-1.05)
- Screen transition: Slide from right/left, fade in/out
- Modal/bottom sheet: Slide up từ dưới with fade
- Pull to refresh: Bounce effect
- Loading: Subtle fade pulse hoặc shimmer effect

## 7. SHADOWS VÀ ELEVATION

### Elevation levels

- Level 0 (flat): No shadow - cho background, inline elements
- Level 1 (raised): Shadow nhẹ - Y offset 2px, blur 4px, opacity 0.08
- Level 2 (floating): Shadow trung bình - Y offset 4px, blur 8px, opacity 0.12
- Level 3 (lifted): Shadow rõ - Y offset 8px, blur 16px, opacity 0.16
- Level 4 (modal): Shadow đậm - Y offset 12px, blur 24px, opacity 0.2

### Shadow color

- Màu đen (#000000) với opacity thay đổi
- Không sử dụng colored shadows

## 8. STATES VÀ FEEDBACK

### Interactive states

- Default: Trạng thái bình thường
- Hover (desktop): Background nhẹ hơn hoặc scale nhẹ
- Press/Active: Background đậm hơn, scale down nhẹ
- Disabled: Opacity 0.4-0.5, không có hover/press effects
- Loading: Spinner hoặc skeleton, disable interaction

### Visual feedback

- Tap highlight: Background flash nhẹ với màu xám (#00000010)
- Success: Có thể dùng màu xanh lá nhạt hoặc checkmark icon
- Error: Màu đỏ nhẹ (#FF5555) cho text hoặc border
- Warning: Màu vàng cam nhẹ (#FFB84D)

## 9. ĐẶC ĐIỂM ĐỘC ĐÁO CỦA THIẾT KẾ

### Clean và minimal

- Không clutter, mỗi screen tập trung vào 1-2 actions chính
- White space rộng rãi, thoáng đãng
- Ít text, nhiều visual

### Photo-first design

- Ảnh là yếu tố trung tâm, chiếm phần lớn không gian
- Photo grid với spacing đều đặn
- Ảnh có quality cao, không bị pixelated

### Warm và friendly

- Màu sắc ấm (beige, cream, mustard yellow)
- Bo góc mềm mại
- Không sử dụng màu lạnh (blue, purple) làm chủ đạo

### Modern social media aesthetic

- Giống Instagram, Pinterest style nhưng đơn giản hơn
- Card-based layout
- Smooth transitions

### Typography hierarchy rõ ràng

- Contrast rõ giữa headings và body text
- Bold headings, regular body
- Consistent sizing

## 10. RESPONSIVE VÀ ADAPTIVE

### Screen sizes

- Design cho mobile-first (375px width base - iPhone SE/13 mini)
- Adapt lên cho larger phones (390px - iPhone regular, 428px - iPhone Max)
- Tablet: Sử dụng multi-column layout

### Adaptive elements

- Grid columns: 2 columns cho mobile nhỏ, 3 columns cho mobile lớn/tablet
- Navigation: Bottom nav cho mobile, side nav hoặc top nav cho tablet
- Font sizes: Scale up một chút cho màn hình lớn

## 11. ACCESSIBILITY

### Contrast

- Text on background: Minimum 4.5:1 ratio (AA standard)
- Large text: Minimum 3:1 ratio
- Test với màu đen trên kem background

### Touch targets

- Minimum size: 44x44pt (iOS) hoặc 48x48dp (Android)
- Spacing giữa touch targets: Tối thiểu 8px

### Text legibility

- Font size không nhỏ hơn 12px cho bất kỳ text nào
- Line height: 1.4-1.6 cho body text
- Paragraph width: Không quá 75 characters

## 12. DESIGN SYSTEM COMPONENTS SUMMARY

### Must-have components

1. Camera viewfinder với capture button
2. Photo grid (2-3 columns)
3. Avatar (small, medium, large)
4. Primary button (black, pill-shaped)
5. Secondary button (yellow accent)
6. Icon button (circular)
7. Text input field
8. List item với avatar và action
9. Photo card với corner radius
10. Bottom sheet modal
11. Navigation bar
12. Bottom tab bar (nếu dùng)

### Interaction patterns

- Tap to select/open
- Swipe to navigate (carousel, history)
- Pull to refresh
- Long press for contextual menu
- Pinch to zoom (photo detail)

## 13. NGUYÊN TẮC THIẾT KẾ

1. Ưu tiên nội dung (ảnh) hơn chrome (UI elements)
2. Giữ navigation đơn giản và dễ hiểu
3. Feedback ngay lập tức cho mọi action
4. Consistency trong spacing, sizing, styling
5. Ảnh luôn là center of attention
6. Text ngắn gọn, to the point
7. Không overload user với quá nhiều options
8. Mỗi screen có một clear purpose

## 14. MÔ TẢ CHO AI DESIGN TOOLS

Khi sử dụng các công cụ AI như Google Stitch AI để thiết kế, hãy cung cấp prompt theo mẫu:

"Thiết kế mobile app screen cho ứng dụng chia sẻ ảnh với phong cách minimalist hiện đại. Sử dụng màu nền kem sáng (beige #F5F3F0), text màu đen đậm, accent color vàng mustard (#F4C542). Typography sử dụng sans-serif font hiện đại như SF Pro hoặc Inter. Layout clean với nhiều white space, ảnh có border radius 12-16px. Buttons hình pill với màu đen (primary) hoặc vàng (secondary). Icons line style màu đen. Shadow nhẹ subtle. Cảm hứng từ Instagram/Pinterest nhưng đơn giản và ấm áp hơn. Photo-first design với grid 2-3 cột."

### Prompt cho từng loại màn hình

#### Camera Screen

"Fullscreen camera viewfinder với overlay UI. Nút chụp hình tròn lớn màu trắng 72px ở giữa dưới cùng. Icons flash và flip camera 24px màu trắng với background đen semi-transparent hai bên nút chụp. Navigation bar trong suốt ở trên với avatar icon trái và notification icon phải màu đen. Background màu kem khi không trong camera mode."

#### Photo Grid/History Screen

"Grid layout 3 cột với gap 8px. Mỗi ảnh có border radius 16px, aspect ratio vuông. Navigation bar trên có title 'History' bold 24px màu đen căn trái. Filter tabs dưới title với active tab có underline vàng. Bottom padding 16px. Background màu kem sáng #F5F3F0."

#### Profile Screen

"Header với avatar lớn 100px centered, username dưới avatar 20px bold, bio text 14px gray. Edit button pill-shaped màu đen dưới bio. Section title 'Settings' 18px semibold với divider xám nhạt. List items 60px height với icon trái, label giữa, chevron right màu xám. Background trắng cho list, general background màu kem."

#### Friend List Screen

"List view với mỗi item 64px height. Avatar 48px bên trái, name và username stack vertically ở giữa. Add/Remove button pill mini bên phải. Search bar trên cùng height 48px với icon search trái, placeholder 'Search friends'. Tab switcher dưới search với 'Friends' và 'Pending'. Divider 1px xám nhạt giữa items."

## 15. THAM KHẢO DESIGN TOKENS

```
Colors:
--bg-primary: #F5F3F0
--bg-secondary: #FFFFFF
--bg-tertiary: #FAFAFA
--text-primary: #000000
--text-secondary: #666666
--text-tertiary: #AAAAAA
--accent-primary: #F4C542
--accent-hover: #E6B73D
--border-light: #E5E5E5
--border-medium: #CCCCCC
--error: #FF5555
--success: #4CAF50

Spacing:
--space-xs: 4px
--space-sm: 8px
--space-md: 12px
--space-lg: 16px
--space-xl: 24px
--space-xxl: 32px

Border Radius:
--radius-sm: 8px
--radius-md: 12px
--radius-lg: 16px
--radius-xl: 24px
--radius-full: 9999px

Typography:
--font-size-xs: 12px
--font-size-sm: 14px
--font-size-md: 16px
--font-size-lg: 18px
--font-size-xl: 20px
--font-size-xxl: 24px

--font-weight-regular: 400
--font-weight-medium: 500
--font-weight-semibold: 600
--font-weight-bold: 700

Shadow:
--shadow-sm: 0 2px 4px rgba(0,0,0,0.08)
--shadow-md: 0 4px 8px rgba(0,0,0,0.12)
--shadow-lg: 0 8px 16px rgba(0,0,0,0.16)
--shadow-xl: 0 12px 24px rgba(0,0,0,0.20)
```
