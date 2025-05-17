# Flutter Riverpod OTP Auth App (Best Practices)

This project is a full-featured authentication flow built with Flutter and Riverpod using Clean Architecture principles. It includes login via phone number, OTP verification, secure token storage, automatic token refreshing, and a home screen that loads data from an API.

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
│   ├── auth/
│   │   ├── data/                  # datasources, models, impl
│   │   ├── domain/                # entities, repositories, usecases
│   │   └── presentation/          # Notifiers and Screens (UI)
│   └── home/
│       ├── data/                  # models, repository implementation
│       ├── domain/                # usecases, repository interface
│       └── presentation/          # notifier, UI widgets/screens
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
- ✅ Modular `Home` feature with repository/usecase/notifier
- ✅ Fully testable UseCases and Notifiers
- ✅ CI: GitHub Actions with test automation

---

## 🧪 Testing

### ✅ Covered:

- `auth_notifier_test.dart`
- `auth_interceptor_test.dart` – adds Authorization header
- `auth_interceptor_401_test.dart` – handles 401 and refreshToken flow
- `token_storage_service_test.dart`
- `token_storage_service_provider_test.dart`
- `home_screen_test.dart` – widget tests: loading, error, data

### 🔜 Next (planned):

- Widget tests for `OtpScreen`, `LoginScreen`
- Integration tests for routing and session restore
- Code coverage badge

### How to run:

```bash
flutter test
```

All tests run on push via GitHub Actions.

---

## 🧭 Feature: `Home` Module

The app shows a home screen after login, using a complete feature module:

```
HomeScreen → HomeNotifier → HomeUseCase → HomeRepositoryImpl → Dio
```

### ✅ Includes:

- `HomeModel` with title/description
- `HomeRepository` interface + `HomeRepositoryImpl` via Dio
- `HomeUseCase.execute()`
- `HomeNotifier` using `AsyncValue<List<HomeModel>>`
- UI screen + `HomeTileWidget` with `ListView.builder`
- Full widget test coverage (`home_screen_test.dart`)

---

## 🔁 Refresh Token Flow

1. User logs in and receives access + refresh tokens
2. Access token is sent with all API requests via `AuthInterceptor`
3. If the server returns 401 (Unauthorized):
   - `AuthInterceptor` catches the error in `onError()`
   - Calls `authNotifier.refreshToken()` to get new tokens
   - Saves new tokens via `TokenStorageService`
   - Retries the original request with updated headers
   - If refresh fails, user is logged out

The flow is fully tested with mocks in `auth_interceptor_401_test.dart`.

---

## 🔄 Navigation Flow

```
/splash   → check saved session → /login or /home
/login    → input phone → /otp
/otp      → verify code → save tokens → /home
/home     → view data → logout → /login
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

Feel free to fork and extend. If you add new modules (e.g. Profile, Settings, Firestore) — PRs welcome!

---

## 📄 Author

Architecture based on `flutter_riverpod_best_practices`.

Built and extended by **[RomanDevelop](https://github.com/RomanDevelop)**.
