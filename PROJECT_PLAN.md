# Kế Hoạch Phát Triển Memore - 10 Tuần

## Tổng Quan

| Giai Đoạn            | Tuần | Mục Tiêu                        |
| -------------------- | ---- | ------------------------------- |
| **Design**           | 1-2  | Thiết kế UI/UX tất cả screens   |
| **Frontend**         | 3-4  | Code FE với mock data           |
| **MVP**              | 5    | FE hoàn chỉnh + BE cơ bản       |
| **Backend + Deploy** | 6    | Hoàn thiện BE + Lên Google Play |
| **Post-Launch**      | 7-10 | Nghiệm thu và Marketing         |

---

## TUẦN 1: Design System và Auth Flow

| Lĩnh Vực            | Công Việc                                                                                                                     |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **Design System**   | - Màu sắc, typography, spacing<br>- Component library (buttons, inputs, cards, avatars)<br>- Icons và assets<br>- Grid system |
| **Onboarding Flow** | - Splash screen<br>- Welcome screen<br>- Onboarding slides                                                                    |
| **Auth Flow**       | - Auth screen<br>- Sign in screen<br>- Email input screen<br>- Password setup screen<br>- Name setup screen                   |

**Deliverables**: ✅ Design system hoàn chỉnh | ✅ 8 screens đã design | ✅ Component library

---

## TUẦN 2: Main App Screens Design

| Lĩnh Vực          | Công Việc                                                                                                                                                                    |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Camera Flow**   | - Camera screen<br>- Photo preview screen<br>- Friend select screen                                                                                                          |
| **Photo Flow**    | - Photo feed screen<br>- Photo view screen<br>- Time travel screen                                                                                                           |
| **Friends Flow**  | - Friends list screen<br>- Add friend screen<br>- Friend profile screen<br>- Friend requests screen                                                                          |
| **Messages Flow** | - Messages list screen<br>- Chat screen                                                                                                                                      |
| **Settings Flow** | - Settings screen<br>- Profile screen<br>- Edit profile screen<br>- Notifications screen<br>- Privacy screen<br>- Blocked users screen<br>- Storage screen<br>- About screen |

**Deliverables**: ✅ Tất cả 20 screens còn lại | ✅ Prototype flow hoàn chỉnh | ✅ Design handoff ready

---

## TUẦN 3: Frontend Core + Auth + Camera

| Lĩnh Vực               | Công Việc                                                                                                                   |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Project Setup**      | - Flutter project structure<br>- Riverpod setup<br>- GoRouter configuration<br>- Constants (colors, sizes, strings, routes) |
| **Design System Code** | - AppTheme implementation<br>- Shared widgets (buttons, inputs, cards)<br>- Custom components                               |
| **Auth Flow**          | - 5 auth screens implementation<br>- Mock authentication logic<br>- Auth state management<br>- Form validation              |
| **Camera Flow**        | - Camera screen với camera package<br>- Photo preview screen<br>- Friend select screen<br>- Local photo storage             |

**Deliverables**: ✅ Design system coded | ✅ Auth flow hoạt động (mock) | ✅ Camera chụp và lưu local

---

## TUẦN 4: Frontend Social Features

| Lĩnh Vực          | Công Việc                                                                                                                                                                    |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Friends Flow**  | - Friends list screen<br>- Add friend screen<br>- Friend profile screen<br>- Friend requests screen<br>- Mock friends data                                                   |
| **Photo Flow**    | - Photo feed screen<br>- Photo view screen<br>- Time travel screen<br>- Mock photo data                                                                                      |
| **Messages Flow** | - Messages screen<br>- Chat screen<br>- Mock messages data                                                                                                                   |
| **Settings Flow** | - Settings screen<br>- Profile screen<br>- Edit profile screen<br>- Notifications screen<br>- Privacy screen<br>- Blocked users screen<br>- Storage screen<br>- About screen |
| **Navigation**    | - Bottom navigation<br>- Screen transitions<br>- Deep linking setup                                                                                                          |

**Deliverables**: ✅ Tất cả 28 screens hoạt động | ✅ Navigation smooth | ✅ UI giống design 95%+

---

## TUẦN 5: MVP - Backend Integration

| Lĩnh Vực                | Công Việc                                                                                                                  |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Firebase Setup**      | - Firebase project creation<br>- Firebase Auth setup<br>- Firestore database<br>- Cloud Storage<br>- Security rules cơ bản |
| **Auth Integration**    | - Email/Password authentication<br>- User profile storage<br>- Auth state persistence<br>- Logout functionality            |
| **Photo Integration**   | - Upload ảnh lên Storage<br>- Save metadata vào Firestore<br>- Load ảnh từ Storage<br>- Image compression                  |
| **Friends Integration** | - Send friend request<br>- Accept/decline request<br>- Friends list từ Firestore<br>- Basic friend search                  |
| **Testing**             | - Test auth flow<br>- Test photo upload<br>- Test friend request<br>- Test trên 3+ devices                                 |
| **Bug Fixes**           | - Fix critical bugs<br>- UI polish<br>- Loading states<br>- Error handling                                                 |

**Deliverables**: ✅ MVP với 4 core features | ✅ Firebase integrated | ✅ App stable 95%

---

## TUẦN 6: Backend Complete + Google Play Deploy

| Lĩnh Vực             | Công Việc                                                                                                                                                                                      |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Backend Complete** | - Photo sharing system<br>- Real-time messaging (Firestore)<br>- Push notifications (FCM)<br>- Security rules hoàn chỉnh<br>- Cloud Functions (resize images)<br>- Photo reactions và comments |
| **FE Integration**   | - Integrate photo sharing<br>- Real-time chat<br>- Push notifications handler<br>- Deep linking từ notifications<br>- Offline support<br>- Image caching                                       |
| **Optimization**     | - Code obfuscation<br>- Proguard rules<br>- Image optimization<br>- App size optimization<br>- Performance tuning<br>- Memory leak fixes                                                       |
| **Store Assets**     | - App icon 512x512<br>- Feature graphic 1024x500<br>- Screenshots 8 ảnh<br>- Video demo (optional)<br>- Description EN + VI<br>- Keywords research                                             |
| **Legal Docs**       | - Privacy Policy<br>- Terms of Service<br>- Data safety form                                                                                                                                   |
| **Deploy**           | - Generate keystore<br>- Build release AAB<br>- Google Play Console setup ($25)<br>- Upload AAB<br>- Complete store listing<br>- Content rating<br>- Submit for review                         |

**Deliverables**: ✅ App 100% features | ✅ Live on Google Play | ✅ All docs ready

---

## TUẦN 7: Post-Launch Support

| Lĩnh Vực         | Công Việc                                                                                                                      |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Monitoring**   | - Crashlytics monitoring<br>- Analytics review<br>- User reviews tracking<br>- Performance metrics<br>- Server load monitoring |
| **Bug Fixes**    | - Fix reported bugs<br>- Patch release nếu cần<br>- Performance improvements<br>- UI tweaks                                    |
| **User Support** | - Setup support email<br>- In-app feedback form<br>- FAQ document<br>- Response to reviews                                     |
| **Analytics**    | - User behavior analysis<br>- Feature usage stats<br>- Retention analysis<br>- Drop-off points                                 |

**Deliverables**: ✅ Bug fix release | ✅ Crash-free 99%+ | ✅ Support system active

---

## TUẦN 8: Marketing Launch

| Lĩnh Vực         | Công Việc                                                                                                                                           |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Website**      | - Landing page design<br>- Landing page development<br>- Feature highlights<br>- Screenshots gallery<br>- Download buttons<br>- Deploy website      |
| **Social Media** | - Facebook page setup + 10 posts<br>- Instagram account + 10 posts<br>- TikTok account (optional)<br>- Content calendar<br>- Daily posting schedule |
| **Content**      | - App demo video<br>- Tutorial videos<br>- Tips & tricks posts<br>- User testimonials                                                               |
| **Outreach**     | - Influencer list<br>- Influencer outreach emails<br>- Tech blogs outreach<br>- Press kit                                                           |
| **ASO**          | - Keywords optimization<br>- Description updates<br>- Screenshot A/B testing                                                                        |

**Deliverables**: ✅ Website live | ✅ Social active | ✅ 500+ downloads | ✅ Marketing running

---

## TUẦN 9: Growth & Feature Update

| Lĩnh Vực           | Công Việc                                                                                                           |
| ------------------ | ------------------------------------------------------------------------------------------------------------------- |
| **Feature Update** | - Top 3 requested features<br>- UI improvements<br>- Performance enhancements<br>- New animations                   |
| **Engagement**     | - In-app events<br>- Push notification campaigns<br>- Email marketing setup<br>- Re-engagement campaigns            |
| **Growth Hacking** | - Referral program<br>- Share feature improvements<br>- Viral loops<br>- Gamification elements                      |
| **Community**      | - Facebook group creation<br>- Community guidelines<br>- User-generated content campaigns<br>- Contests & giveaways |
| **Analytics**      | - A/B testing setup<br>- Cohort analysis<br>- Funnel optimization<br>- Feature experiments                          |

**Deliverables**: ✅ Major update released | ✅ 1000+ downloads | ✅ Engagement +30%

---

## TUẦN 10: Nghiệm Thu

| Lĩnh Vực          | Công Việc                                                                                                                                                                  |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Documentation** | - Technical documentation<br>- User guide (EN + VI)<br>- API documentation<br>- Architecture diagrams<br>- Code comments review<br>- README update                         |
| **Presentation**  | - Slides preparation<br>- Feature demo video<br>- Use cases walkthrough<br>- Technical achievements<br>- User statistics charts<br>- Future roadmap                        |
| **Reports**       | - User acquisition report<br>- Engagement metrics report<br>- Technical performance report<br>- Financial report (nếu có)<br>- Lessons learned<br>- Challenges & solutions |
| **Final Testing** | - Complete regression testing<br>- Security audit final<br>- Performance benchmarking<br>- Accessibility check                                                             |
| **Handover**      | - Code repository cleanup<br>- Deploy documentation<br>- Admin credentials<br>- Firebase access                                                                            |

**Deliverables**: ✅ Presentation complete | ✅ Full documentation | ✅ Final report | ✅ Demo video

---

## Success Metrics

| Phase                  | Target Metrics                                      |
| ---------------------- | --------------------------------------------------- |
| **MVP (T5)**           | 4 core features, 0 crashes, app works offline       |
| **Launch (T6)**        | Live on Play Store, store listing 100%              |
| **Week 1 Post-Launch** | 100+ downloads, 4.0+ rating                         |
| **Week 4 Post-Launch** | 1000+ downloads, 30% D7 retention, 99.5% crash-free |

---

## Tech Stack

| Layer     | Technology                                          |
| --------- | --------------------------------------------------- |
| Design    | Figma                                               |
| Frontend  | Flutter, Riverpod, GoRouter, Camera                 |
| Backend   | Firebase (Auth, Firestore, Storage, FCM, Functions) |
| Analytics | Firebase Analytics, Crashlytics                     |
| CI/CD     | GitHub Actions                                      |

---

## Risk & Mitigation

| Risk              | Mitigation                         |
| ----------------- | ---------------------------------- |
| Design chậm       | Bắt đầu code với wireframes        |
| Firebase costs    | Monitor usage, optimize queries    |
| Play Store reject | Submit sớm tuần 6, có plan B       |
| Ít downloads      | Marketing sớm từ tuần 5            |
| Team burnout      | Realistic goals, avoid scope creep |
