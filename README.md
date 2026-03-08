# 📰 NewsWave

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.3+-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/State-BLoC-blueviolet?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Version-1.0.0-orange?style=for-the-badge"/>
</p>

<p align="center">
  Ứng dụng đọc tin tức chuyên nghiệp được xây dựng bằng Flutter, áp dụng Clean Architecture và BLoC pattern.
</p>

---

## ✨ Tính năng nổi bật

| Tính năng | Mô tả |
|-----------|-------|
| 🏠 **Trang chủ** | Hiển thị tin tức nổi bật và danh sách bài viết theo thời gian thực |
| 🔍 **Khám phá** | Tìm kiếm bài viết, xem tin theo danh mục và nguồn tin |
| 🔖 **Bookmark** | Lưu bài viết yêu thích để đọc offline bằng Hive |
| 👤 **Hồ sơ** | Quản lý thông tin cá nhân và chủ đề quan tâm |
| 🌙 **Dark / Light Mode** | Hỗ trợ giao diện tối/sáng, lưu cài đặt người dùng |
| 🎯 **Onboarding** | Màn hình giới thiệu khi mở ứng dụng lần đầu |
| 📂 **Danh mục tin** | Business, Entertainment, Health, Science, Sports, Technology, General |
| 🌐 **Multi-platform** | Chạy trên Android, iOS, Web, Windows, macOS, Linux |

---

## 🏗️ Kiến trúc

Dự án áp dụng **Clean Architecture** với 3 tầng rõ ràng:

```
newsapp/lib/
├── core/                          # Dùng chung toàn app
│   ├── constants/                 # Hằng số (danh mục, quốc gia...)
│   ├── error/                     # Xử lý lỗi (Failures)
│   ├── network/                   # Kiểm tra kết nối mạng
│   └── theme/                     # Theme sáng/tối, màu sắc, font
│
├── features/
│   ├── news/                      # Tính năng tin tức chính
│   │   ├── data/                  # Data sources, repositories, models
│   │   ├── domain/                # Entities, use cases, repository contracts
│   │   └── presentation/          # BLoC, Pages, Widgets
│   ├── onboarding/                # Màn hình giới thiệu
│   ├── settings/                  # Cài đặt (dark mode, ngôn ngữ...)
│   └── profile/                   # Hồ sơ người dùng
│
└── injection_container.dart       # Dependency Injection (GetIt + Injectable)
```

---

## 🛠️ Công nghệ sử dụng

### State Management & Architecture
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| `flutter_bloc` | ^9.0.0 | Quản lý state theo BLoC pattern |
| `equatable` | ^2.0.7 | So sánh object, tối ưu rebuild |
| `dartz` | ^0.10.1 | Xử lý lỗi với kiểu `Either` |

### Networking
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| `dio` | ^5.5.0 | HTTP client mạnh mẽ |
| `internet_connection_checker` | ^3.0.0 | Kiểm tra trạng thái mạng |
| `flutter_dotenv` | ^5.2.1 | Quản lý biến môi trường (.env) |

### Dependency Injection
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| `get_it` | ^8.0.0 | Service Locator |
| `injectable` | ^2.5.0 | Tự động hóa đăng ký DI |

### Local Storage
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| `hive` + `hive_flutter` | ^2.2.3 | Local database nhẹ, nhanh |
| `shared_preferences` | - | Lưu cài đặt đơn giản |
| `path_provider` | ^2.1.3 | Quản lý đường dẫn file |

### UI & Utilities
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| `cached_network_image` | ^3.4.1 | Cache ảnh từ network |
| `shimmer` | ^3.0.0 | Hiệu ứng loading skeleton |
| `flutter_svg` | ^2.0.10 | Hỗ trợ ảnh SVG |
| `flutter_animate` | - | Hiệu ứng animation |
| `url_launcher` | ^6.3.2 | Mở link bài viết |
| `intl` | ^0.19.0 | Format ngày tháng |

---

## 🚀 Bắt đầu

### Yêu cầu

- Flutter SDK `>=3.3.0`
- Dart SDK `>=3.3.0 <4.0.0`
- API Key từ [NewsAPI.org](https://newsapi.org/)

### Cài đặt

**1. Clone repository:**
```bash
git clone https://github.com/huypham200104/NewsWave.git
cd NewsWave/newsapp
```

**2. Cài đặt dependencies:**
```bash
flutter pub get
```

**3. Tạo file `.env` trong thư mục `newsapp/`:**
```env
NEWS_API_KEY=your_api_key_here
```

**4. Chạy code generation:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**5. Chạy ứng dụng:**
```bash
flutter run
```

---

## 📱 Các màn hình

- **Onboarding** — Giới thiệu app khi mở lần đầu, chọn chủ đề quan tâm
- **Home** — Tin tức nổi bật (Featured), danh sách bài viết, lọc theo danh mục
- **Discover** — Tìm kiếm, tin trending, khám phá danh mục & nguồn tin
- **Bookmarks** — Danh sách bài đã lưu (lưu offline bằng Hive)
- **Profile** — Thông tin cá nhân, chủ đề theo dõi
- **Settings** — Chế độ tối/sáng, thông báo, ngôn ngữ
- **Article Detail** — Chi tiết bài viết, bookmark, đọc toàn bài trên trình duyệt

---

## 📂 Cấu trúc thư mục đầy đủ

```
NewsWave/
└── newsapp/                  # Flutter project chính
    ├── lib/
    │   ├── main.dart
    │   ├── injection_container.dart
    │   ├── core/
    │   └── features/
    │       ├── news/
    │       ├── onboarding/
    │       ├── settings/
    │       └── profile/
    ├── assets/
    │   ├── images/
    │   ├── icons/
    │   └── fonts/            # Inter Variable Font
    ├── android/
    ├── ios/
    ├── web/
    ├── windows/
    ├── macos/
    ├── linux/
    └── pubspec.yaml
```

---

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Hãy mở **Issue** hoặc **Pull Request** nếu bạn muốn cải thiện dự án.

---

## 📄 Giấy phép

Dự án này được phân phối dưới giấy phép [MIT](LICENSE).

---

<p align="center">Made with ❤️ using Flutter</p>
