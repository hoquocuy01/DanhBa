# 📒 Ứng dụng Quản lý Danh bạ

Ứng dụng quản lý danh bạ được xây dựng bằng **Flutter** và **Dart**, hướng đến việc giúp người dùng lưu trữ, tra cứu và quản lý thông tin liên hệ trên giao diện đơn giản, dễ sử dụng.

**Mã nguồn:** [hoquocuy01/DanhBa](https://github.com/hoquocuy01/DanhBa)

## 📌 Giới thiệu

Dự án được phát triển nhằm thực hành xây dựng ứng dụng di động với Flutter, tổ chức mã nguồn theo màn hình và dịch vụ, đồng thời sử dụng các package hỗ trợ lưu trữ dữ liệu và thao tác với ứng dụng.

## ✨ Chức năng

- Xem danh sách và thông tin liên hệ.
- Thêm, chỉnh sửa và xóa liên hệ.
- Tìm kiếm liên hệ, nếu chức năng này đã được triển khai trong phiên bản hiện tại.
- Đăng nhập/đăng ký, nếu các màn hình xác thực đã được tích hợp trong phiên bản hiện tại.

> Hãy bỏ các mục chưa được triển khai trong mã nguồn của phiên bản bạn nộp. README nên phản ánh chính xác chức năng thực tế.

## 🧰 Công nghệ sử dụng

| Công nghệ / thư viện | Vai trò |
|---|---|
| [Flutter](https://flutter.dev/) | Xây dựng giao diện và ứng dụng đa nền tảng |
| [Dart](https://dart.dev/) | Ngôn ngữ lập trình |
| `shared_preferences` | Lưu dữ liệu dạng key-value trên thiết bị |
| `intl` | Hỗ trợ định dạng ngày giờ và dữ liệu theo locale |
| `share_plus` | Tích hợp chức năng chia sẻ nội dung |
| `cupertino_icons` | Bộ biểu tượng phong cách Cupertino |

Các package trên được khai báo trong `pubspec.yaml`. Việc một package được cài đặt không có nghĩa mọi chức năng của nó đã được sử dụng.

## 📱 Nền tảng

Repository có các thư mục nền tảng Flutter cho Android, iOS, Web, Windows, Linux và macOS. Khả năng chạy thực tế trên từng nền tảng còn phụ thuộc vào mã nguồn và cấu hình ứng dụng.

## 🚀 Cài đặt và chạy

### Yêu cầu

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (được cài kèm Flutter)
- Android Studio hoặc Visual Studio Code
- Android Emulator hoặc thiết bị thật để chạy thử

Kiểm tra môi trường:

```bash
flutter doctor
```

### 1. Tải mã nguồn

```bash
git clone https://github.com/hoquocuy01/DanhBa.git
cd DanhBa
```

### 2. Cài đặt thư viện

```bash
flutter pub get
```

### 3. Chạy ứng dụng

```bash
flutter run
```

Nếu có nhiều thiết bị, kiểm tra danh sách bằng:

```bash
flutter devices
```

## 🗂️ Cấu trúc dự án

```text
DanhBa/
├── android/                # Cấu hình Android
├── assets/
│   └── logo.png            # Tài nguyên logo
├── ios/                    # Cấu hình iOS
├── lib/                    # Mã nguồn Dart
├── linux/                  # Cấu hình Linux
├── macos/                  # Cấu hình macOS
├── web/                    # Cấu hình Web
├── windows/                # Cấu hình Windows
├── pubspec.yaml            # Package và tài nguyên
├── pubspec.lock            # Phiên bản package đã phân giải
└── README.md               # Tài liệu dự án
```

## 🧪 Kiểm tra chất lượng

Chạy kiểm thử nếu dự án có các bài test:

```bash
flutter test
```

Phân tích mã nguồn:

```bash
flutter analyze
```

Nên chạy các lệnh trên trước khi phát hành hoặc nộp dự án và xử lý những lỗi được báo.

## 🔐 Dữ liệu và quyền riêng tư

- Không đưa mật khẩu, khóa API hoặc thông tin cá nhân nhạy cảm vào repository.
- `shared_preferences` là cơ chế lưu trữ cục bộ dạng key-value, không phải cơ sở dữ liệu bảo mật.
- Nếu có chức năng đăng nhập, hãy kiểm tra cách xác thực và lưu thông tin đăng nhập thực tế trước khi mô tả mức độ bảo mật.
- Kiểm tra dữ liệu thử nghiệm và thông tin cá nhân trước khi công khai mã nguồn.

## 🛠️ Khắc phục sự cố

**Không tải được package**

```bash
flutter pub get
```

**Lỗi build ứng dụng**

```bash
flutter clean
flutter pub get
flutter run
```

**Không nhận diện thiết bị**

```bash
flutter doctor
flutter devices
```

Nếu vẫn lỗi, hãy xem đầy đủ thông báo trong Terminal và kiểm tra phiên bản Flutter/Dart đang sử dụng.

## 🤝 Đóng góp

1. Tạo một nhánh mới cho thay đổi.
2. Thực hiện thay đổi và kiểm tra bằng `flutter analyze` cùng `flutter test`.
3. Gửi Pull Request kèm mô tả rõ nội dung đã thay đổi.

## 📄 Giấy phép

Repository hiện chưa thể hiện rõ giấy phép phân phối. Nếu muốn cho phép người khác sử dụng hoặc chỉnh sửa mã nguồn, hãy bổ sung tệp `LICENSE` và ghi rõ điều kiện sử dụng.

---

**Tác giả:** [hoquocuy01](https://github.com/hoquocuy01)  
**Repository:** [github.com/hoquocuy01/DanhBa](https://github.com/hoquocuy01/DanhBa)
