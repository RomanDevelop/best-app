# Flutter Riverpod OTP Auth App (Best Practices)

This project is a full-featured authentication flow built with Flutter and Riverpod using Clean Architecture principles. It includes login via phone number, OTP verification, secure token storage, and automatic token refreshing.

---

## 🧱 Architecture Layers

```
lib/
├── core/
│   ├── common/                    # Shared providers, models
│   ├── error/                     # AppException definitions
│   ├── network/                   # Dio & AuthInterceptor
│   └── services/                  # TokenStorageService (secure)
├── features/
│   └── auth/
│       ├── data/                  # datasources, models, impl
│       ├── domain/                # entities, repositories, usecases
│       └── presentation/          # Notifiers and Screens (UI)
```

---

## 🚀 Features

- ✅ Phone Number Login via OTP
- ✅ Riverpod Notifier-based state management
- ✅ Clean separation of layers (Data / Domain / Presentation)
- ✅ Secure access/refresh token storage (flutter_secure_storage)
- ✅ `authNotifier.init()` + auto-login on app start
- ✅ Logout with token clear
- ✅ Dio interceptor with automatic token refresh on 401
- ✅ Fully testable UseCases and Notifiers
- ✅ CI: GitHub Actions with test automation

---

## 🧪 Testing

### ✅ Covered:

- `login_usecase_test.dart`
- `verify_otp_usecase_test.dart`
- `auth_notifier_test.dart`
- `login_provider_test.dart`
- `verify_otp_provider_test.dart`
- `auth_repository_test.dart`
- `auth_remote_datasource_test.dart`

### 🔜 Next (planned):

- `auth_interceptor_test.dart`
- Integration tests (navigation, flow, retry)
- Code coverage badge

### How to run:

```bash
flutter test
```

All tests run on push via GitHub Actions.

---

## 🔁 Refresh Token Flow

1. User logs in and receives access + refresh tokens
2. Access token is sent with all API requests via `AuthInterceptor`
3. If the server returns 401:
   - interceptor calls `refreshToken(...)`
   - new tokens are saved via `authNotifier.saveLogin(...)`
   - original request is retried with the new token

---

## 🔄 Navigation Flow

```
/splash   → check saved session → /login or /home
/login    → input phone → /otp
/otp      → verify code → save tokens → /home
/home     → view user info → logout → /login
```

---

## 🔧 CI/CD

GitHub Actions is configured to:

- Check out code
- Install dependencies
- Run `flutter test`

Config path: `.github/workflows/flutter_test.yml`

---

## 📦 Tech Stack

- Flutter 3.19+ (tested with 3.27.3)
- Riverpod (Notifier-based)
- Dio for networking
- GoRouter for navigation
- Freezed + Build Runner
- Dartz (Either, functional error handling)
- flutter_secure_storage
- mocktail + flutter_test
- GitHub Actions (CI)

---

## 👨‍💻 Contributing

Feel free to fork and extend. If you build on this and add production features — test coverage, push notifications, Firestore, etc. — feel free to open a PR or issue.

---

## 📄 Author

Architecture based on `flutter_riverpod_best_practices` and extended for production use.

Built and extended by **[RomanDevelop](https://github.com/RomanDevelop)**.