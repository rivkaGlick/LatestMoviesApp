# LatestMoviesApp

##  Overview
LatestMoviesApp is an iOS app that provides the latest movie information, built with **SwiftUI** and **The Composable Architecture (TCA)** for modularity and testability.

##  Architecture
- **TCA-based State Management** – Ensures unidirectional data flow.
- **Networking** – Uses `URLSession` with async/await.
- **SwiftUI UI Layer** – Declarative and responsive UI.
- **Dependency Injection** – Simplifies testing and modularity.

##  Technical Decisions
- **SwiftUI & TCA** – Chosen for scalability and clean state management.
- **Async/Await Networking** – Improves readability and efficiency.
- **Modular Structure** – Enhances maintainability.
- **Unit Testing** – Focus on key features for stability.

##  Limitations & Improvements
-  **Current Limitations**: No offline mode, basic error handling, lacks UI animations.
-  **Future Enhancements**: Offline support, improved UI, dark mode, and better testing.

##  Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/rivkaGlick/LatestMoviesApp.git
   cd LatestMoviesApp
   ```
2. Open `LatestMoviesApp.xcodeproj` in Xcode.
3. Ensure Swift packages are resolved:
   ```bash
   xcodebuild -resolvePackageDependencies
   ```
4. Build and run in the iOS Simulator.


