SmartTracker - Flutter Mobile Application
📱 Project Overview
SmartTracker is a cross-platform Flutter application that integrates mobile device sensors (GPS, Camera) with a REST API backend. The app allows users to track their live location, capture images, and sync activity logs in real-time.

✨ Features
Live Location Tracking: Real-time GPS tracking with embedded maps

Camera Integration: Capture images and attach them to activities

REST API Sync: Automatic synchronization with remote backend

Offline Storage: Stores recent 5 activities locally for quick access

Activity History: View, search, and delete logged activities

Responsive UI: Works on both phones and tablets

🛠️ Technologies Used
Flutter & Dart - Cross-platform framework

Provider - State management

REST API - Node.js/Express backend

Google Maps - Location visualization

Geolocator - GPS services

Camera - Device camera access

SharedPreferences - Local storage

📁 Project Structure
text
lib/
├── models/          # Data models
├── services/        # API, Location, Camera services
├── providers/       # State management
├── screens/         # UI screens
└── widgets/         # Reusable components
🚀 Getting Started
Prerequisites
Flutter SDK (>= 3.0.0)

Dart (>= 3.0.0)

Android Studio/VSCode

Google Maps API Key (for maps feature)

Installation
Clone the repository

bash
git clone <repository-url>
cd smart_tracker
Install dependencies

bash
flutter pub get
Add API configuration

Add Google Maps API key to AndroidManifest.xml

Update API base URL in api_service.dart
