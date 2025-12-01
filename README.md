MagTapp - AI-Powered In-App Browser & Document Summarizer
📋 Assignment Overview
Build a Flutter-based cross-platform application that combines web browsing capabilities with AI-powered document summarization and translation features. This assignment evaluates your expertise in Flutter development, state management, system architecture, and integration of modern AI services.
Position: SDE-2 Flutter Developer
Company: Kuvakatech
Expected Timeline: 1 Days
Platforms: Android, iOS, Web (PWA)

🎯 Assignment Objectives

Demonstrate proficiency in Flutter cross-platform development
Implement complex state management patterns
Showcase clean architecture principles
Integrate AI/ML services effectively
Handle offline functionality and caching strategies
Create production-ready code with proper documentation


📚 Table of Contents

Core Requirements
Technical Specifications
Implementation Phases
Deliverables
Evaluation Criteria
Submission Guidelines


🔧 Core Requirements
1. In-App Browser Module

WebView Implementation using flutter_inappwebview or webview_flutter
Multi-tab Support (minimum 3 concurrent tabs)
Navigation Controls (back, forward, refresh, URL bar)
Download Manager for documents (PDF, DOCX, PPTX, XLSX)
Cross-platform Compatibility:

Android (Chromium engine)
iOS (WebKit engine)
Web (iframe/PWA)


Error Handling and loading indicators

2. File Management System

Local Storage implementation using path_provider
File Operations:

Download files from browser
Pick files from device storage (file_picker)
View downloaded files
Delete/manage stored files


Supported Formats: PDF, DOCX, PPTX, XLSX
Metadata Management: Track file name, size, date, type
History Tracking: Maintain list of opened/summarized documents

3. AI-Powered Features
Summarization Engine

Text Extraction from:

Web pages (DOM parsing via JavaScript injection)
Local documents (using appropriate parsers)


AI Integration:

Can use mock APIs for development (smmry.com, GPT4All, Ollama)
Or implement a simple Flask mock server


Summary Display:

Collapsible panel below browser
Word count metrics (original vs summarized)
Copy, save, and share functionality



Translation Service

Multi-language Support (minimum 3 languages)

English → Hindi, Spanish, French


Translation APIs:

Google Translate API (free tier)
LibreTranslate (open source)
Or mock API for development


Toggle View between original and translated text
Side-by-side Comparison mode

4. State Management Architecture

Tab State Management:

Dynamic tab creation/deletion
Tab switching with state preservation
Session persistence across app restarts


Caching Strategy:

Avoid redundant API calls
Cache summaries and translations
LRU cache implementation


Framework Options: Riverpod, BLoC, or MobX

5. Offline Capabilities

Content Caching:

Save web pages for offline viewing
Store generated summaries locally
Cache translations


Offline Detection using connectivity_plus
Offline Mode UI:

Clear offline indicator
Access to cached content
Graceful degradation




💻 Technical Specifications
ComponentRequirementsFlutter Version3.x (Stable Channel)Dart SDK2.19+Min Android SDK21 (Android 5.0)Min iOS Version11.0State ManagementRiverpod 2.0+ / BLoC 8.0+Local DatabaseHive 2.0+ / SQLiteBrowser Engineflutter_inappwebview 6.0+HTTP ClientDio 5.0+File Managementfile_picker 6.0+ArchitectureClean Architecture
Required Packages
yamldependencies:
  flutter:
    sdk: flutter
    
  # Core Dependencies
  flutter_riverpod: ^2.4.9
  dio: ^5.4.0
  
  # Browser
  flutter_inappwebview: ^6.0.0
  
  # Storage & Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1
  
  # File Management
  file_picker: ^6.1.1
  open_file: ^3.3.2
  path: ^1.8.3
  
  # UI Components
  flutter_slidable: ^3.0.1
  shimmer: ^3.0.0
  lottie: ^2.7.0
  
  # Utilities
  connectivity_plus: ^5.0.2
  share_plus: ^7.2.1
  cached_network_image: ^3.3.1
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7
  hive_generator: ^2.0.1

🚀 Implementation Phases
PHASE 1: Foundation & Architecture Setup (Days 1-3)
Objectives

Project initialization and configuration
Architecture implementation
Basic navigation setup

Tasks
1.1 Project Setup
bash# Initialize Flutter project
flutter create magtapp --org com.kuvakatech --platforms android,ios,web

# Add required dependencies
flutter pub add flutter_riverpod dio flutter_inappwebview hive hive_flutter
```

**1.2 Architecture Structure**
```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── network_info.dart
│   │   └── dio_client.dart
│   └── utils/
│       ├── text_extractor.dart
│       ├── file_utils.dart
│       └── validators.dart
├── features/
│   ├── browser/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── file_manager/
│   ├── summarizer/
│   └── translator/
├── shared/
│   ├── widgets/
│   └── providers/
└── main.dart
1.3 Core Models Implementation

 Create BrowserTab entity
 Create Document entity
 Create Summary entity
 Create Translation entity
 Implement Hive adapters

1.4 Base UI Setup

 Main scaffold with bottom navigation
 Basic routing configuration
 Theme configuration (Light/Dark)
 Responsive layout helpers

Deliverables

✅ Clean architecture structure
✅ Core models and entities
✅ Basic navigation working
✅ Database initialization


PHASE 2: Browser Implementation (Days 4-6)
Objectives

Fully functional in-app browser
Multi-tab management
Download capabilities

Tasks
2.1 WebView Integration

 Implement InAppWebViewController
 Add navigation controls (back, forward, refresh)
 URL bar with validation
 Progress indicator
 Error handling pages

2.2 Tab Management System
dart// Required functionality
class TabManager {
  void createTab(String url);
  void closeTab(String tabId);
  void switchTab(String tabId);
  List<BrowserTab> getAllTabs();
  void persistTabs();
  void restoreTabs();
}
2.3 Download Manager

 Detect downloadable content
 Implement download service
 Progress tracking
 Save to local storage
 Download history

2.4 JavaScript Bridge
javascript// Text extraction script
window.flutter_inappwebview.callHandler('extractText', {
  text: document.body.innerText,
  title: document.title,
  url: window.location.href
});
Deliverables

✅ Working browser with URL navigation
✅ Tab switching functionality
✅ File download capability
✅ JavaScript text extraction


PHASE 3: File Management System (Days 7-8)
Objectives

Complete file management system
Document viewer integration
Storage optimization

Tasks
3.1 File Storage Service
dartclass FileStorageService {
  Future<String> saveFile(Uint8List bytes, String fileName);
  Future<File> getFile(String fileName);
  Future<void> deleteFile(String fileName);
  Future<List<Document>> getAllDocuments();
  Future<int> getStorageSize();
}
3.2 Document Viewer

 PDF viewer integration
 DOCX parser
 Basic XLSX/PPTX support
 Text extraction from documents

3.3 File Manager UI

 File list with filters (All, PDFs, Recent)
 Search functionality
 Sort options (name, date, size)
 Batch operations (delete multiple)

3.4 Storage Optimization

 Implement LRU cache
 Auto-cleanup old files
 Compression for cached web pages

Deliverables

✅ File picker and viewer
✅ Document management UI
✅ Storage metrics
✅ Text extraction from files


PHASE 4: AI Integration (Days 9-11)
Objectives

Integrate summarization service
Add translation capabilities
Build AI feature UI

Tasks
4.1 Summarization Service
dartabstract class SummarizerService {
  Future<Summary> summarizeText(String text);
  Future<Summary> summarizeUrl(String url);
  Future<Summary> summarizeDocument(File document);
}
Mock Implementation Options:

Local mock service with basic algorithm
Integration with smmry.com API
Flask server with Hugging Face models
Ollama local LLM integration

4.2 Translation Service
dartabstract class TranslationService {
  Future<String> translate(String text, String targetLanguage);
  List<Language> getSupportedLanguages();
  Future<void> downloadLanguagePack(String languageCode);
}
4.3 AI UI Components

 Collapsible summary panel
 Translation toggle view
 Language selector
 Word count statistics
 Copy/Share actions

4.4 Caching Strategy

 Cache summaries by content hash
 Store translations with language key
 Implement cache expiration
 Offline access to cached AI results

Deliverables

✅ Working summarization
✅ Multi-language translation
✅ Smooth UI animations
✅ Cached AI results


PHASE 5: Offline Mode & Optimization (Days 12-13)
Objectives

Complete offline functionality
Performance optimization
Bug fixes

Tasks
5.1 Offline Manager
dartclass OfflineManager {
  Stream<ConnectivityResult> connectivityStream;
  Future<void> cacheWebPage(String url, String html);
  Future<String?> getCachedPage(String url);
  Future<void> syncPendingOperations();
}
5.2 Performance Optimization

 Lazy loading for file list
 Image optimization for web content
 Debouncing for search/API calls
 Memory leak fixes
 FPS monitoring (maintain 60fps)

5.3 Enhanced Features

 Batch summarization
 Export summaries to PDF
 Reading mode for web pages
 Custom theme support

5.4 Error Handling

 Network error recovery
 Corrupted file handling
 API failure fallbacks
 User-friendly error messages

Deliverables

✅ Offline mode working
✅ Performance metrics met
✅ Enhanced user experience
✅ Comprehensive error handling


PHASE 6: Testing & Documentation (Days 14-15)
Objectives

Comprehensive testing
Complete documentation
Deployment preparation

Tasks
6.1 Testing
Unit Tests (minimum 70% coverage)
dartvoid main() {
  group('SummarizerService', () {
    test('should summarize text correctly', () {});
    test('should handle empty text', () {});
    test('should cache summaries', () {});
  });
}
Widget Tests
darttestWidgets('Browser navigation works', (tester) async {});
testWidgets('Tab switching works', (tester) async {});
testWidgets('Summary panel displays correctly', (tester) async {});
Integration Tests
dartvoid main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Full user journey test', (tester) async {
    // Open browser → Navigate → Summarize → Translate → Save
  });
}
6.2 Documentation
Required Documentation:

 API documentation
 Architecture diagrams
 Setup instructions
 Deployment guide
 Known limitations
 Future improvements

6.3 Deployment
Build Commands:
bash# Android Release Build
flutter build apk --release --obfuscate --split-debug-info=debug_info

# Web Build (PWA)
flutter build web --release --web-renderer html --pwa-strategy offline

# iOS Build (if available)
flutter build ios --release
6.4 Demo Preparation

 Create 5-10 minute demo video
 Prepare presentation slides
 Write user guide
 Create test credentials

Deliverables

✅ Test coverage report
✅ Complete documentation
✅ Deployment packages
✅ Demo video and materials


📦 Deliverables Checklist
1. GitHub Repository

 Clean commit history with conventional commits
 Branching strategy (main, develop, feature branches)
 Pull request for each phase
 GitHub Actions CI/CD setup
 Issue tracking for bugs/features

2. Code Requirements

 Clean Architecture implementation
 SOLID principles followed
 Code documentation (dartdoc)
 No linting errors
 Minimum 70% test coverage

3. README.md Contents
markdown# MagTapp

## 📱 Screenshots
[Include app screenshots]

## 🏗️ Architecture
[Architecture diagram]

## 🚀 Getting Started
### Prerequisites
### Installation
### Configuration
### Running the app

## 📁 Project Structure
[Directory structure explanation]

## 🔧 Technical Decisions
### State Management
### Database Choice
### API Integration

## 🧪 Testing
### Running Tests
### Coverage Report

## 📊 Performance Metrics
- App size
- Load time
- Memory usage
- FPS metrics

## 🐛 Known Issues

## 🔮 Future Enhancements

## 👥 Contributors

## 📄 License
```

### 4. **Demo Video Requirements**
- Introduction (30 seconds)
- Browser navigation demo (2 minutes)
- File management demo (1 minute)
- AI summarization demo (2 minutes)
- Translation feature demo (1 minute)
- Offline mode demo (1 minute)
- Architecture explanation (2 minutes)
- Conclusion (30 seconds)

---

## 📊 Evaluation Criteria

### **Technical Excellence (40%)**
- Clean, maintainable code
- Proper architecture implementation
- Performance optimization
- Error handling

### **Feature Completeness (30%)**
- All core features working
- Cross-platform compatibility
- Offline functionality
- AI integration

### **UI/UX Quality (20%)**
- Smooth animations
- Intuitive navigation
- Responsive design
- Consistent theme

### **Documentation & Testing (10%)**
- Comprehensive documentation
- Test coverage
- Clear commit history
- Demo quality

---

## 📝 Submission Guidelines

### **Repository Structure**
```
magtapp/
├── android/
├── ios/
├── web/
├── lib/
├── test/
├── assets/
├── docs/
│   ├── architecture.md
│   ├── api_documentation.md
│   └── user_guide.md
├── screenshots/
├── .github/
│   └── workflows/
├── README.md
├── pubspec.yaml
└── .gitignore
Submission Checklist

 GitHub repository link
 Demo video (uploaded to YouTube/Loom)
 APK file (via GitHub releases)
 Web deployment link (optional)
 Test coverage report
 Architecture documentation

Naming Convention

Repository: magtapp-flutter-sde2
Branch: main (production), develop (development)
Commits: Use conventional commits

feat: new feature
fix: bug fix
docs: documentation
test: testing
refactor: code refactoring
style: formatting
perf: performance



Contact for Queries

Technical queries: [technical-email]
Submission issues: [hr-email]
Deadline: [15 days from start date]


🏆 Bonus Points
Optional Enhancements (Extra Credit)

Voice Features

Speech-to-text for URL input
Text-to-speech for summaries


Advanced AI

Sentiment analysis
Key points extraction
Auto-tagging documents


PWA Features

Install prompt
Push notifications
Background sync


Analytics

Firebase/Sentry integration
User behavior tracking
Crash reporting


Accessibility

Screen reader support
High contrast mode
Font size adjustment




🔗 Resources
Flutter Documentation

Flutter Official Docs
Flutter Cookbook
Flutter Gallery

Package Documentation

flutter_inappwebview
Riverpod
Hive Database

AI/ML Resources

Hugging Face Models
Ollama Documentation
Google Translate API

Design Resources

Material Design 3
Flutter UI Challenges


📜 License
This assignment is proprietary to Kuvakatech. The code you write remains your intellectual property, but Kuvakatech reserves the right to review and evaluate it for assessment purposes.#   m a g t a p p  
 