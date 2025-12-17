# Recall Butler

> Your AI-Powered Second Brain - Capture, Process, and Recall Anything

Recall Butler is a full-stack mobile application that helps you capture screenshots, photos, voice notes, and links, then processes them using Google's Gemini AI to extract meaningful information, generate summaries, and make everything searchable.

## Features

- **Smart Screenshot Capture** - Floating overlay button to capture any screen instantly
- **Photo Capture** - Take photos and let AI extract text and context
- **Voice Notes** - Record voice memos with AI transcription and summarization
- **Link Capture** - Save URLs with automatic content extraction
- **AI-Powered Processing** - Gemini AI extracts text, generates summaries, and categorizes content
- **Semantic Search** - Find anything using natural language queries
- **Smart Reminders** - AI detects actionable items and creates reminders
- **Weekly Digest** - Get AI-generated summaries of your captures

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Backend** | [Serverpod](https://serverpod.dev) (Dart) |
| **Frontend** | [Flutter](https://flutter.dev) |
| **Database** | PostgreSQL |
| **AI** | Google Gemini 2.5 Flash |
| **State Management** | Riverpod |
| **Storage** | Serverpod Cloud Storage |

## Project Structure

```
recall_butler/
├── recall_butler_server/     # Serverpod backend
│   ├── lib/
│   │   └── src/
│   │       ├── endpoints/    # API endpoints
│   │       ├── services/     # Business logic (Gemini AI, etc.)
│   │       └── generated/    # Auto-generated code
│   └── config/               # Server configuration
├── recall_butler_client/     # Generated client library
└── recall_butler_flutter/    # Flutter mobile app
    ├── lib/
    │   └── src/
    │       ├── screens/      # UI screens
    │       ├── providers/    # Riverpod state management
    │       ├── services/     # Platform services
    │       └── theme/        # App theming
    └── android/              # Android-specific code (overlay, screen capture)
```

## Prerequisites

- **Flutter SDK** >= 3.0.0
- **Dart SDK** >= 3.0.0
- **Docker** (for PostgreSQL database)
- **Android Studio** or **VS Code**
- **Google Gemini API Key** - Get one at [Google AI Studio](https://makersuite.google.com/app/apikey)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/SajalDevX/recall-butler.git
cd recall-butler
```

### 2. Start the Database

```bash
cd recall_butler_server
docker compose up -d --build
```

### 3. Configure Secrets

Create `recall_butler_server/config/passwords.yaml`:

```yaml
shared:
  geminiApiKey: 'YOUR_GEMINI_API_KEY_HERE'

development:
  database: 'YOUR_DB_PASSWORD'  # Check docker-compose.yaml
  redis: 'YOUR_REDIS_PASSWORD'
  serviceSecret: 'YOUR_SERVICE_SECRET'
```

### 4. Run Database Migrations

```bash
cd recall_butler_server
dart bin/main.dart --apply-migrations
```

### 5. Install Dependencies

```bash
# Server
cd recall_butler_server
dart pub get

# Client
cd ../recall_butler_client
dart pub get

# Flutter App
cd ../recall_butler_flutter
flutter pub get
```

## Running the Application

### Start the Server

```bash
cd recall_butler_server
dart bin/main.dart
```

The server will start on:
- API Server: `http://localhost:8080`
- Insights: `http://localhost:8081`
- Web Server: `http://localhost:8082`

### Run the Flutter App

```bash
cd recall_butler_flutter
flutter run
```

### For Physical Device Testing

1. Update `recall_butler_server/config/development.yaml`:

```yaml
apiServer:
  port: 8080
  publicHost: YOUR_COMPUTER_IP  # e.g., 192.168.1.100
  publicPort: 8080
  publicScheme: http
```

2. Update the client URL in `recall_butler_flutter/lib/main.dart` to match.

## Configuration

### Server Configuration

| File | Purpose |
|------|---------|
| `config/development.yaml` | Development server settings |
| `config/production.yaml` | Production server settings |
| `config/passwords.yaml` | API keys and secrets (NOT committed to git) |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `geminiApiKey` | Google Gemini API key for AI processing |
| `database` | PostgreSQL password |
| `serviceSecret` | Inter-service communication secret |

## Android Permissions

The app requires these permissions for full functionality:

```xml
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `capture.createCapture` | POST | Create a new capture with AI processing |
| `capture.getCaptures` | GET | List all captures with filtering |
| `capture.deleteCapture` | DELETE | Remove a capture |
| `search.semanticSearch` | POST | AI-powered semantic search |
| `search.getRecentSearches` | GET | Get search history |
| `userPreference.getPreferences` | GET | Get user settings |
| `userPreference.updatePreferences` | POST | Update user settings |

## Screenshots

<p align="center">
  <img src="docs/screenshots/home.png" width="200" alt="Home Screen"/>
  <img src="docs/screenshots/capture.png" width="200" alt="Capture Modal"/>
  <img src="docs/screenshots/search.png" width="200" alt="Search Screen"/>
  <img src="docs/screenshots/overlay.png" width="200" alt="Floating Overlay"/>
</p>

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### Common Issues

**Server won't start:**
```bash
# Check if ports are in use
lsof -i :8080
# Kill the process if needed
fuser -k 8080/tcp
```

**Database connection failed:**
```bash
# Restart Docker containers
docker compose down
docker compose up -d --build
```

**AI processing fails:**
- Verify your Gemini API key in `passwords.yaml`
- Check server logs for detailed error messages

**Screenshot capture not working:**
- Grant "Display over other apps" permission
- Grant "Screen recording" permission when prompted

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 SajalDevX

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Author

**SajalDevX**

- GitHub: [@SajalDevX](https://github.com/SajalDevX)

## Acknowledgments

- [Serverpod](https://serverpod.dev) - The missing server for Flutter
- [Google Gemini](https://deepmind.google/technologies/gemini/) - AI processing
- [Flutter](https://flutter.dev) - Beautiful native apps
- [Riverpod](https://riverpod.dev) - State management

---

<p align="center">
  Built with Flutter + Serverpod + Gemini AI
</p>
