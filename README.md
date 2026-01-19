# Modern QR Generator 🎨

A beautiful, modern, and fully cross-platform QR code generator built with Flutter. Generate customized QR codes for various content types with advanced styling options, all running completely offline.

![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue)
![Dart](https://img.shields.io/badge/Dart-3.10.4-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

### 📱 Cross-Platform Support
- ✅ **Android** - Native mobile experience
- ✅ **iOS** - Native mobile experience  
- ✅ **Web** - Progressive Web App
- ✅ **Windows** - Native desktop application
- ✅ **macOS** - Native desktop application
- ✅ **Linux** - Native desktop application

### 🎯 Supported QR Content Types
- 📝 **Text** - Plain text messages
- 🌐 **URL** - Website links
- 📞 **Phone** - Phone numbers with click-to-call
- 📧 **Email** - Email addresses with optional subject/body
- 💬 **SMS** - SMS messages
- 📶 **Wi-Fi** - Wi-Fi credentials (SSID, password, security)
- 👤 **Contact** - vCard format with full contact details
- 📍 **Location** - Geographic coordinates
- 📅 **Calendar Event** - iCal format events
- 💚 **WhatsApp** - Direct WhatsApp chat links
- 📷 **Instagram** - Instagram profile links
- ✈️ **Telegram** - Telegram profile links
- 🐦 **Twitter/X** - Twitter profile links

### 🎨 Advanced Customization
- **Size Control** - Adjust QR code size from 100px to 2000px
- **Color Customization** - Full color picker for foreground, background, and eye colors
- **Error Correction** - Choose from 4 levels (L: 7%, M: 15%, Q: 25%, H: 30%)
- **Module Shapes** - Square, rounded, dots, diamond
- **Eye Shapes** - Square, rounded, circular
- **Logo Overlay** - Add custom logos with size and shape controls
- **Scannability Checks** - Real-time validation for QR readability

### 💾 Export & Share
- **PNG Export** - High-resolution image export (up to 1200 DPI)
- **PDF Export** - Professional A4 layout documents
- **Local Save** - Save to gallery (mobile) or file system (desktop/web)
- **Native Share** - Share via system share sheet where supported

### 🎭 Modern UI/UX
- **Material 3 Design** - Latest Material Design guidelines
- **Light & Dark Themes** - Automatic theme switching
- **Responsive Layouts** - Adapts to mobile, tablet, and desktop
- **Keyboard & Mouse Support** - Full desktop navigation
- **Accessibility** - WCAG AA compliant with proper contrast and focus states

### 🔒 Privacy & Security
- **100% Offline** - No internet connection required
- **No Analytics** - Zero tracking or data collection
- **No Authentication** - No accounts or login needed
- **Local Processing** - All QR generation happens on your device

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a modular design:

```
lib/
├── core/                      # Shared utilities and services
│   ├── constants/            # App-wide constants
│   ├── theme/                # Material 3 themes
│   ├── utils/                # Validators, encoders, platform utils
│   ├── errors/               # Error handling
│   ├── widgets/              # Reusable widgets
│   ├── routing/              # Navigation
│   ├── platform/             # Platform abstractions
│   └── di/                   # Dependency injection
├── features/                  # Feature modules
│   ├── qr_generator/         # QR generation feature
│   │   ├── domain/           # Business logic (entities, use cases)
│   │   ├── data/             # Data layer (repositories, data sources)
│   │   └── presentation/     # UI layer (BLoC, views, widgets)
│   └── export_share/         # Export/share feature
│       ├── domain/
│       ├── data/
│       └── presentation/
└── main.dart                  # App entry point
```

### Key Design Patterns
- **BLoC Pattern** - State management with `flutter_bloc`
- **Repository Pattern** - Data access abstraction
- **Dependency Injection** - Using `get_it` for loose coupling
- **Use Cases** - Single-responsibility business logic
- **Either Type** - Functional error handling

## 📦 Dependencies

### Core Packages
- `flutter_bloc: ^8.1.6` - State management
- `equatable: ^2.0.5` - Value equality
- `get_it: ^8.0.2` - Dependency injection

### QR Generation
- `qr: ^3.0.1` - QR encoding logic
- `qr_flutter: ^4.1.0` - QR widget rendering

### File Operations
- `file_picker: ^8.1.4` - Cross-platform file picking
- `path_provider: ^2.1.5` - File system paths
- `permission_handler: ^11.3.1` - Permission management

### Export & Share
- `pdf: ^3.11.1` - PDF generation
- `printing: ^5.13.4` - PDF save/share
- `share_plus: ^10.1.2` - Native sharing

### UI
- `flex_color_picker: ^3.6.0` - Advanced color picker
- `image: ^4.3.0` - Image processing

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.4 or higher
- Dart SDK 3.10.4 or higher

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/freeqrgen.git
cd freeqrgen
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**

For mobile (Android/iOS):
```bash
flutter run
```

For web:
```bash
flutter run -d chrome
```

For desktop:
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

**Windows:**
```bash
flutter build windows --release
```

**macOS:**
```bash
flutter build macos --release
```

**Linux:**
```bash
flutter build linux --release
```

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 🎯 Platform-Specific Notes

### Web
- File saving uses browser download API
- No direct file system access
- Logo picking uses file upload dialog
- Share functionality may be limited

### Desktop (Windows/macOS/Linux)
- Full file system access
- Native file dialogs for save/open
- High DPI support
- Keyboard shortcuts enabled

### Mobile (Android/iOS)
- Gallery integration for saving
- Native share sheet
- Storage permissions handled automatically
- Optimized for touch input

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors to all the open-source packages used
- Material Design team for the design system

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Made with ❤️ using Flutter**
