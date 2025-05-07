
# My Riverpod App (OTP Auth Flow)

This Flutter project demonstrates a clean and testable authentication flow using Riverpod (Notifier-based architecture) and Clean Architecture principles.

## 📦 Project Structure

```
lib/
├── core/
│   ├── common/
│   │   └── providers/
│   │       └── auth_notifier_provider.dart
│   ├── error/
│   │   └── app_exception.dart
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── auth_remote_datasource.dart
│       │   ├── models/
│       │   │   └── login_data_model.dart
│       │   └── repositories_impl/
│       │       └── auth_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── verify_otp_state.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       └── verify_otp_usecase.dart
│       └── presentation/
│           └── providers/
│               └── verify_otp_provider.dart
```

---

## 🚀 Features

- OTP-based login
- Riverpod `NotifierProvider` state management
- Clean separation of data, domain, and presentation
- Full test coverage for UseCases and Providers
- Error handling via `Either<AppException, T>` (Dartz)

---

## 🧪 Testing

### Unit tests

Located in:

```
test/
├── features/
│   ├── auth/
│   │   ├── domain/usecases/verify_otp_usecase_test.dart
│   │   └── presentation/providers/verify_otp_provider_test.dart
```

To run tests:

```bash
flutter test
```

You can run a single file:

```bash
flutter test test/features/auth/presentation/providers/verify_otp_provider_test.dart
```

---

## 🧠 Technologies Used

- Riverpod (Notifier API)
- Dartz for Either / Functional error handling
- Flutter Secure Storage
- Freezed + Build Runner
- Dio HTTP client
- Mocktail for testing

---

## 🛠 Key Concepts

- `UseCase`: Executes logic and returns success or failure
- `Notifier`: Holds state for the UI (loading, data, error)
- `ProviderContainer`: Used for overriding providers in tests
- `Mocktail`: Replaces real dependencies in unit tests
- `Either`: Clean result wrapping for API calls

---

## 🔄 State Flow Diagram

```
UI (Button press)
  ↓
verifyOtpProvider.notifier.verifyOTP()
  ↓
useCase.execute() — returns Either
  ↓
Notifier updates VerifyOtpState
  ↓
UI listens via ref.watch() → rebuilds on change
```

---

## ✍️ Author

Developed and tested by [your name or GitHub].

