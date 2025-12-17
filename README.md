# La'abob 🎮

An educational and entertainment app for children built with Flutter, providing safe video content and interactive educational and physical games.

## 📱 Overview

**La3bob** is a comprehensive platform that combines:
- **Safe Video Content**: Filtered and checked YouTube videos to ensure halal and child-appropriate content
- **Educational Games**: Interactive games for learning letters, numbers, colors, and matching
- **Physical Games**: Games that use the device camera and ML Kit to analyze movement (jump, squat, freeze, simon says)

## ✨ Key Features

### 🎥 Video Content
- Browse checked YouTube videos based on child interests
- Filter by categories: Drawing & Coloring, Reading & Stories, Games, Sports, Animals, Nature, Science, Mathematics, Letters, Numbers, Languages, Entertainment, Songs, Religion
- Built-in video player
- Fully Arabic interface

### 🎮 Educational Games
- **Letters Game**: Learn Arabic letters with audio
- **Numbers Game**: Learn numbers and counting
- **Colors Game**: Learn basic colors
- **Matching Game**: Match images and shapes

### 🏃 Physical Games
- **Jump Game**: Detect jump movements using the camera
- **Squat Game**: Squat exercises with movement tracking
- **Freeze Game**: Freeze when you hear the signal
- **Simon Says Game**: Follow movement instructions

### 👤 Profile Management
- Create multiple child profiles
- Set interests for each child
- Set age group for each child
- Manage profiles (add, edit, delete)

### 🔐 Security & Privacy
- Secure authentication system
- Kiosk Mode to prevent app exit
- Biometric authentication (fingerprint/face)
- Advanced AI-powered content filtering

## 🛠️ Technologies Used

- **State Management**: Flutter Bloc
- **Dependency Injection**: GetIt + Injectable
- **Navigation**: GoRouter
- **Local Storage**: GetStorage
- **Backend**: Supabase
- **Camera**: camera package
- **ML Kit**: google_mlkit_pose_detection
- **Video Player**: video_player, youtube_player_flutter
- **Audio**: audioplayers
- **UI**: Material Design with RTL support for Arabic

## 📋 Requirements

### To run the Flutter app:
- Flutter SDK 3.10.0 or later
- Dart SDK
- Android Studio / Xcode (for Android/iOS development)
- Supabase account
- `.env` file containing:
  ```
  SUPABASE_URL=your_supabase_url
  SUPABASE_ANON_KEY=your_supabase_anon_key
  ```



## 🚀 Installation & Setup

### 1. Clone the repository
```bash
git clone <repository-url>
cd la3bob
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Setup environment file
Create a `.env` file in the root folder:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4. Run the app
```bash
flutter run
```

## 📁 Project Structure

```
la3bob/
├── lib/
│   ├── core/                 # Core utilities, DI, theme
│   ├── features/             # Feature modules
│   │   ├── auth/            # Authentication
│   │   ├── profiles/        # Child profiles management
│   │   ├── videos/          # Video browsing & playback
│   │   ├── games/           # Educational & physical games
│   │   ├── navigation_bar/
│   │   ├── onboarding/
│   │   └── splash_screen/
│   └── router/              # App routing
├── assets/                   # Images, audio files
└── pubspec.yaml
```

## 🎯 Technical Features

### Clean Architecture
The project follows Clean Architecture with clear separation between:
- **Presentation Layer**: UI, BLoC
- **Domain Layer**: Entities, Use Cases, Repositories (interfaces)
- **Data Layer**: Models, Data Sources, Repository implementations

### State Management
Using Flutter Bloc for state management:
- `AuthBloc`: Authentication management
- `ProfileBloc`: Profile management
- `VideosBloc`: Video management
- `GamesBloc`: Games management
- Separate BLoCs for each physical game

### Dependency Injection
Using GetIt + Injectable:
- Register all services and Use Cases
- Automatic dependency injection

## 🔧 Configuration

### Supabase Setup
1. Create a new Supabase project
2. Create the following tables:
   - `profiles`: For user profiles
   - `videos`: For checked videos
   - `children`: For child data
3. Add the URL and Key in the `.env` file


## 👥 Team

- Saad Alharbi
- Talal Alharthi
- Omar Alharbi

