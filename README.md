# Student Records App 📚

A Flutter mobile application that allows administrators to manage student records using Firebase Firestore as the backend.

## Features
- ➕ **Create** — Add new students with name, ID, email, course and age
- 📋 **Read** — Live dashboard that fetches all students from Firestore
- ✏️ **Update** — Edit existing student details
- 🗑️ **Delete** — Remove student records instantly
- 👁️ **View** — Tap a student to see full details

## Tech Stack
- Flutter (Dart)
- Firebase Firestore

## Project Structure
lib/
├── models/student.dart
├── services/firebase_service.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── add_student_screen.dart
│   ├── edit_student_screen.dart
│   └── student_detail_screen.dart
└── main.dart