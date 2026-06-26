# 🚀 Syncro: AI-Powered Seminar Management

> *Making seminar registration, attendance, and multilingual communication faster, smarter, and more secure with AI.*

Syncro is a modern mobile application designed to streamline the entire seminar experience—from participant registration and attendance verification to real-time multilingual communication. By integrating **AI Face Recognition**, **Speech-to-Text Translation**, and a **role-based management system**, Syncro provides a secure, intelligent, and user-friendly platform for seminars and academic events.

Built with **Flutter**, and modern mobile architecture, Syncro enables participants, gatekeepers, moderators, and speakers to collaborate seamlessly in a single application.

---

# ✨ Key Features

## 👤 User

* 🔐 Secure authentication with **Google OAuth**.
* 👤 Manage personal account information.
* 📅 Browse and register for available seminars.
* 📄 View seminar details and schedules.
* 🤖 Register personal facial data for attendance.
* ✅ View attendance status and seminar history.

---

## 🚪 Gatekeeper

* 👁️ Verify participant identity using AI Face Recognition.
* ⚡ Perform fast and secure attendance validation.
* 📋 Monitor participant check-in activity in real time.

---

## 🎤 Moderator

* 📢 Manage seminar sessions efficiently.
* 👥 Monitor participant information.
* 🌍 Support multilingual communication using AI Speech Translation.
* 🎯 Ensure smooth seminar execution.

---

## 🎙️ Speaker

* 📚 Access assigned seminar sessions.
* 🎤 Speak naturally while Syncro converts speech into text.
* 🌐 Instantly translate speech between **Indonesian 🇮🇩** and **English 🇺🇸**.
* 📄 View seminar information and attendance overview.

---

# 🤖 AI Face Recognition

Syncro leverages AI-powered Face Recognition to enhance attendance security and participant verification.

### Current Implementation

* ✅ Face registration is available **only for User accounts**.
* 👤 Each user can register **their own facial data**.
* 🔒 Face embeddings are used exclusively for attendance verification.
* 🚫 Registering another participant's face is currently not supported.

---

# 🌍 AI Speech Translation

Syncro provides **real-time multilingual communication** through Speech-to-Text and AI Translation.

### Current Capabilities

* 🎤 Convert spoken language into text using Speech-to-Text.
* 🌐 Automatically translate conversations between **Indonesian 🇮🇩** and **English 🇺🇸**.
* 📝 Display translated results instantly as readable text.
* 🤝 Help moderators, speakers, and participants communicate without language barriers.

---

# 🎓 Seminar Management

Syncro simplifies seminar operations with an integrated management system.

* 📅 Seminar registration
* 🎟️ Participant management
* 📍 Attendance tracking
* 👥 Multi-role access control
* 📊 Attendance history

---

# 🛠 Tech Stack

| Category                 | Technology                                                              |
| ------------------------ | ----------------------------------------------------------------------- |
| 📱 Mobile                | Flutter, Dart                                                           |
| 🏛 Architecture          | Clean Architecture                                                      |
| ⚡ State Management       | GetX                                                                    |
| 🔑 Authentication        | Google OAuth                                                            |
| 🌐 Backend               | Next.js REST API                                                         |
| 🗄 Database              | Supabase                                                                |
| 🤖 AI & Machine Learning | MobileFaceNet, TensorFlow Lite (TFLite), Speech-to-Text, AI Translation |

---

# 👥 User Roles

| Role              | Description                                                                                     |
| ----------------- | ----------------------------------------------------------------------------------------------- |
| 👤 **User**       | Register seminars, enroll facial data, and attend seminar sessions.                             |
| 🚪 **Gatekeeper** | Verify participant attendance using AI Face Recognition.                                        |
| 🎤 **Moderator**  | Manage seminar sessions, participants, and multilingual communication.                          |
| 🎙️ **Speaker**   | Access seminar information, deliver presentations, and communicate using AI Speech Translation. |

---

# 🌐 Supported Languages

Currently available:

* 🇮🇩 Indonesian
* 🇺🇸 English

> 🌍 More languages are planned for future releases.

---

# ⭐ System Highlights

* 🤖 AI-powered Face Recognition Attendance
* 🌍 Real-Time Speech-to-Text Translation
* 🔐 Secure Google OAuth Authentication
* 👥 Multi-role Seminar Management
* 📱 Modern Flutter Mobile Application
* 🏛 Clean Architecture Implementation
* ⚡ High-performance State Management with GetX
* 🔒 Secure and Reliable Attendance Verification

---

# 🚧 Current Limitations

* Face registration is currently available only for **User** accounts.
* AI Translation currently supports **Indonesian 🇮🇩 ↔ English 🇺🇸**.
* Facial verification is used exclusively for seminar attendance.
* Additional language support is planned for future releases.

---

# 🛣️ Roadmap

* 🔔 Push Notifications
* 📈 Attendance Analytics Dashboard
* 📷 QR Code Attendance Backup
* 🌏 Additional Language Support
* ☁️ Offline Attendance Synchronization
* 📅 Organizer Web Dashboard

---

# 📄 License

This project was developed for educational, research, and portfolio purposes.
