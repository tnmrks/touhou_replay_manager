# Touhou Replay Manager

A personal project to create a cross-platform mobile app (Android & iOS) that functions as a storage manager for video and replay (.rpy) files from the Touhou Project game series.
This application is built with Flutter and integrates backend services for authentication, database, and file storage.

---

## English

Week 1 Progress (July 14 - July 19, 2025)
The first week was focused on building a solid technical foundation for the entire project. This included setting up the development environment, making backend architecture decisions, establishing the initial connection between the app and cloud services, and designing the first user interface.

Key Accomplishments:
Environment & Tooling: Successfully set up a complete Flutter development environment with VS Code and Git on Windows.
Project Initialization: Initialized the Flutter project and resolved various initial synchronization issues with the GitHub repository (including branch naming and merging histories).
Hybrid Backend Architecture: Designed and set up a flexible backend architecture:
Firebase: Utilized for Authentication (user login & registration) and Firestore Database (replay metadata storage).
Supabase: Selected as the Storage solution to handle video and .rpy file uploads to meet the no-budget constraint.
Frontend-Backend Connection: Successfully connected the Flutter app to Firebase. This process involved solving various Android native build challenges, such as Gradle (.kts) configuration, NDK versions, and OS permissions.

UI & Navigation Basics:
Built a basic page navigation system using Navigator.
Designed the static UI for the Login page, complete with TextField for input and Button for actions.

Next Week's Plan:
Implement Login and Registration functionality using Firebase Authentication.
Manage user session state (determining if a user is logged in or out).
Begin building the UI for the main dashboard after a user successfully logs in.

---
