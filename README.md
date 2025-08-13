#  Expense Gem Mobile

<div align="center">
  <img src="https://via.placeholder.com/200x200/4CAF50/FFFFFF?text=💰" alt="Expense Gem Mobile Logo" width="200" height="200">
  
  <p><strong>A modern, feature-rich expense tracking mobile application built with Flutter</strong></p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
</div>

## 📱 Introduction

**Expense Gem Mobile** is a comprehensive personal finance management application that helps users track their income, expenses, and financial goals with an intuitive and modern interface. Built with Flutter, it provides a seamless cross-platform experience for both iOS and Android users.

### ✨ Key Features

- 📊 **Dashboard Analytics** - Visual insights into your spending patterns
- 💳 **Account Management** - Multiple account support with balance tracking
- 🏷️ **Category Organization** - Customizable expense and income categories
- 📈 **Transaction Tracking** - Detailed transaction history with filtering

---

## ️ Technology Used

### **Core Framework**
- **[Flutter](https://flutter.dev/)** - Cross-platform mobile development framework
- **[Dart](https://dart.dev/)** - Programming language for Flutter development

### **State Management & Architecture**
- **[Riverpod](https://riverpod.dev/)** - State management and dependency injection
- **[Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)** - Separation of concerns with domain, data, and presentation layers
- **[Repository Pattern](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design)** - Data access abstraction

### **Networking & API**
- **[Dio](https://pub.dev/packages/dio)** - HTTP client for API communication
- **[GoRouter](https://pub.dev/packages/go_router)** - Declarative routing solution

### **Data Management**
- **[SharedPreferences](https://pub.dev/packages/shared_preferences)** - Local data persistence
- **[Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)** - Secure token storage
- **[Hive](https://pub.dev/packages/hive_flutter)** - Local database for caching

### **UI/UX Libraries**
- **[Flutter Animate](https://pub.dev/packages/flutter_animate)** - Smooth animations and transitions
- **[FL Chart](https://pub.dev/packages/fl_chart)** - Beautiful charts and graphs
- **[Google Fonts](https://pub.dev/packages/google_fonts)** - Typography enhancement

### **Development Tools**
- **[Build Runner](https://pub.dev/packages/build_runner)** - Code generation
- **[Riverpod Generator](https://pub.dev/packages/riverpod_generator)** - Automatic provider generation
- **[Logger](https://pub.dev/packages/logger)** - Debugging and logging
- **[Alice](https://pub.dev/packages/alice)** - HTTP inspector for debugging

### **Utilities**
- **[Equatable](https://pub.dev/packages/equatable)** - Value equality for Dart objects
- **[Dartz](https://pub.dev/packages/dartz)** - Functional programming utilities
- **[Get It](https://pub.dev/packages/get_it)** - Service locator for dependency injection
- **[Intl](https://pub.dev/packages/intl)** - Internationalization and formatting

---

## 🚀 Getting Started

### **Prerequisites**

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.7.2 or higher) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/ekady/expense_gem_mobile.git
   cd expense_gem_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   # Edit .env with your configuration
   # Add your API base URL and other environment-specific variables
   ```

4. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

### **Project Structure**

```
lib/
├── config/                 # App configuration (theme, router, env)
├── core/                   # Core utilities and shared code
│   ├── entities/          # Shared domain entities
│   ├── error/             # Error handling
│   ├── services/          # Service locator
│   └── utils/             # Utility functions
└── features/              # Feature-based modules
    ├── auth/              # Authentication feature
    ├── accounts/          # Account management
    ├── categories/        # Category management
    ├── transactions/      # Transaction tracking
    ├── dashboard/         # Dashboard analytics
    ├── profile/           # User profile
    └── settings/          # App settings
```

---


### **Build for Production**

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🤝 How to Contribute

We welcome contributions from the community! Here's how you can help:

### **Ways to Contribute**

- 🐛 **Report Bugs** - Found a bug? Open an issue with detailed information
-  **Suggest Features** - Have an idea? We'd love to hear it!
- 📝 **Improve Documentation** - Help make our docs better
- 🔧 **Submit Code** - Fix bugs or add new features

### **Development Workflow**

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style and patterns
   - Write tests for new functionality
   - Update documentation as needed

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git commit -m "feat: add new feature description"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Provide a clear description of your changes
   - Reference any related issues
   - Include screenshots for UI changes

### **Code Style Guidelines**

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Write comprehensive comments for complex logic
- Ensure all tests pass before submitting

### **Issue Guidelines**

When reporting issues, please include:
- Flutter and Dart version
- Device/OS information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)
