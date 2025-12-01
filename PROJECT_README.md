# MagTapp - AI-Powered In-App Browser

A Flutter-based cross-platform application that combines web browsing capabilities with AI-powered document summarization and translation features.

## 🚀 Features

### 📱 Core Features
- **In-App Browser**: Full-featured web browser with multi-tab support
- **AI Summarization**: Generate concise summaries of any text content
- **AI Translation**: Translate text between 15 languages
- **File Management**: Download and manage documents (PDF, DOCX, PPTX, XLSX)
- **Offline Mode**: All data persisted locally with Hive database
- **Theme Support**: Light, Dark, and System theme modes

### 🌐 Browser Features
- Multi-tab management (create, switch, close tabs)
- URL bar with search support
- Navigation controls (back, forward, refresh)
- Download manager with automatic file persistence
- Progress indicators and error handling
- Pull-to-refresh functionality

### 🤖 AI Features
- **Text Summarization**:
  - Generate summaries with compression statistics
  - Word count tracking (original vs summary)
  - Automatic saving to local database
  
- **Translation**:
  - 15 supported languages
  - Language swap functionality
  - Pre-configured translations for 10 language pairs
  - Automatic saving to local database

### 📁 File Management
- View all downloaded documents
- Search files by name
- Filter by file type
- Open files in external apps
- Delete files with confirmation
- Storage usage tracking

### ⚙️ Settings
- Theme mode selection (System/Light/Dark)
- Clear all cache functionality
- App information display

## 🏗️ Architecture

### Clean Architecture
```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App-wide constants
│   ├── database/           # Hive database service
│   ├── errors/             # Error handling
│   ├── models/             # Data models
│   ├── network/            # Network utilities
│   ├── theme/              # App theming
│   └── utils/              # Utility functions
├── features/               # Feature modules
│   ├── browser/           # Browser feature
│   │   ├── data/          # Data layer
│   │   └── presentation/  # UI layer
│   ├── files/             # File management
│   ├── summarizer/        # AI summarization
│   ├── translator/        # AI translation
│   └── settings/          # App settings
└── shared/                # Shared components
    ├── providers/         # Global providers
    └── widgets/           # Reusable widgets
```

### State Management
- **Flutter Riverpod 2.4.9+**: Modern state management solution
- **StateNotifierProvider**: For complex state logic
- **Provider**: For simple dependencies

### Local Database
- **Hive 2.2.3+**: Fast, lightweight NoSQL database
- **Type Adapters**: Custom serialization for models
- **Boxes**:
  - `tabs`: Browser tabs
  - `documents`: Downloaded files
  - `summaries`: AI-generated summaries
  - `translations`: AI translations
  - `settings`: App preferences

## 📦 Dependencies

### Core
- `flutter_riverpod: ^2.4.9` - State management
- `dio: ^5.4.0` - HTTP client
- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Hive Flutter integration

### Browser
- `flutter_inappwebview: ^6.0.0` - WebView implementation

### File Management
- `file_picker: ^6.1.1` - File selection
- `path_provider: ^2.1.1` - Path utilities
- `open_file: ^3.3.2` - Open files in external apps
- `path: ^1.8.3` - Path manipulation

### UI Components
- `flutter_slidable: ^3.0.1` - Swipe actions
- `shimmer: ^3.0.0` - Loading animations
- `lottie: ^2.7.0` - Lottie animations
- `cached_network_image: ^3.3.0` - Image caching

### Utilities
- `connectivity_plus: ^5.0.2` - Network connectivity
- `share_plus: ^7.2.1` - Share functionality
- `intl: ^0.18.1` - Internationalization

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd magtapp
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (Chrome, Firefox, Safari)

## 🎨 Design

- **Material Design 3**: Modern Material Design components
- **Color Scheme**:
  - Light Mode: Primary #2196F3 (Blue), Secondary #4CAF50 (Green)
  - Dark Mode: Primary #1976D2, Secondary #388E3C
- **Responsive Layout**: Adapts to different screen sizes

## 📝 License

This project is part of an assignment for Kuvakatech.

## 👨‍💻 Development

### Project Structure
- Clean Architecture with separation of concerns
- Feature-based folder structure
- Dependency injection with Riverpod
- Type-safe models with Hive adapters

### Code Quality
- Zero errors in flutter analyze
- All tests passing
- Proper error handling
- Async context management

## 🔮 Future Enhancements

- Real AI API integration (Ollama, Google Translate)
- Cloud sync for summaries and translations
- Browser history and bookmarks
- Reading mode for articles
- PDF viewer integration
- Voice input for translation

