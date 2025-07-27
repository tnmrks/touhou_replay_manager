# Touhou Replay Manager

A personal project to create a cross-platform mobile app (Android & iOS) that functions as a storage manager for video and replay (.rpy) files from the Touhou Project game series.
This application is built with Flutter and integrates backend services for authentication, database, and file storage.

---

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

Week 2 Progress (July 21 - July 27, 2025)
This week was dedicated to implementing core application logic. The primary focus was on building a complete user authentication flow from registration to login and logout. We also created the user interface and backend logic for submitting new replay data, and handled a critical security vulnerability.

Key Accomplishments:
Full Authentication Flow: Implemented user registration using Firebase Authentication's email and password provider. Built the user login functionality to authenticate existing users. Added a logout feature to the main homepage.
Session Management: Created an AuthWrapper widget that listens to the user's authentication state in real-time. It automatically navigates users to the login screen if they are logged out, or to the home page if they are logged in, providing a seamless user experience.
Advanced Form Creation: Developed a comprehensive form for submitting new replays, which includes:
A DropdownButtonFormField for selecting a game title from a predefined list.
Multiple CheckboxListTile widgets for common conditions (e.g., No Miss, No Bomb).
Conditional UI to show a text field for "Other" conditions only when its checkbox is ticked.
Database Integration (Create): Successfully implemented the "Create" part of CRUD. The application can now take user input from the form and save it as a new document in the replays collection in Cloud Firestore.
Security Best Practices: Identified and resolved a security alert from GitHub regarding a leaked API key. Learned and executed the process of removing sensitive data from the entire Git history using git filter-repo and force-pushing the clean history.

Next Week's Plan:
Read and display the list of saved replays from Firestore on the HomePage.
Implement file picking (for .rpy and video files) and upload them to Supabase Storage.
Create a detail page to view the full information for a selected replay.
Begin implementing the "Update" and "Delete" functionalities for existing replays.

---
