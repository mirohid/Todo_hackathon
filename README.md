# Today-Only Todo App

A minimalist iOS todo application built with SwiftUI that focuses exclusively on today's tasks. Tasks automatically reset at midnight, encouraging users to stay focused on what matters right now.

## 📱 Overview

This app was built as a take-home exercise demonstrating iOS development fundamentals, architecture patterns, and thoughtful product design. The core philosophy is simplicity: **one day at a time, no backlogs, no overdue tasks**.

## ✨ Features

### Core Functionality
- ✅ Add tasks for today only
- ✅ Mark tasks as complete with smooth animations
- ✅ Automatic task expiration at midnight
- ✅ Persistent local storage using Core Data
- ✅ Clean, modern SwiftUI interface

### Enhanced Features
- 🎨 **Light/Dark Mode Support** - System, light, and dark appearance modes
- 🔔 **Local Notifications** - Reminders scheduled for task expiration times (today only)
- 📱 **iOS Widget** - Home screen widget showing today's task count
- 🎤 **Siri Integration** - Add tasks via App Intents
- 📳 **Haptic Feedback** - Tactile responses for task interactions
- 🎭 **Empty States** - Thoughtful UI when no tasks exist
- ⏰ **Task Expiration Times** - Set reminder times within the current day

## 🏗️ Architecture

### MVVM Pattern
The app follows a clean **Model-View-ViewModel** architecture:

- **Views**: SwiftUI views (`TodayTasksView`, `AddTaskView`, `TaskRowView`)
- **ViewModels**: `TodayTasksViewModel` manages business logic and state
- **Models**: Core Data entities (`Task`)
- **Core Services**: Reusable managers for notifications, haptics, and persistence

### Key Architectural Decisions

#### 1. **Separation of Concerns**
- Business logic isolated in `TodayTasksViewModel`
- Core services (`NotificationManager`, `HapticManager`, `CoreDataStack`) are singletons with clear responsibilities
- Views are purely presentational, delegating actions to the ViewModel

#### 2. **Date Abstraction**
- `DateProviding` protocol allows for testable date-dependent logic
- `Date+Extensions` provides reusable date calculations (`startOfDay`, `endOfDay`)
- All date operations respect the "today only" constraint

#### 3. **Automatic Cleanup**
- Timer-based midnight reset (checks every minute) ensures old tasks are removed
- Tasks are filtered by `createdAt` date to show only today's tasks
- Old tasks are deleted on app launch and during scheduled checks

#### 4. **Data Persistence**
- Core Data for robust local storage
- Singleton `CoreDataStack` manages the persistent container
- Preview support with in-memory store for SwiftUI previews

## 🔧 Technical Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Minimum iOS Version**: iOS 16.0
- **Persistence**: Core Data
- **Architecture**: MVVM with Combine
- **Platform Features**: WidgetKit, App Intents, UserNotifications

## 📁 Project Structure

```
Todo_hackathon/
├── App/
│   └── Todo_hackathonApp.swift          # App entry point
├── Features/
│   └── TodayTasks/
│       ├── Views/
│       │   ├── TodayTasksView.swift     # Main task list view
│       │   ├── AddTaskView.swift        # Task creation sheet
│       │   └── TaskRowView.swift        # Individual task row
│       └── ViewModel/
│           └── TodayTasksViewModel.swift # Business logic
├── Core/
│   ├── Persistence/
│   │   └── CoreDataStack.swift          # Core Data setup
│   ├── Date/
│   │   ├── DateProviding.swift          # Date abstraction protocol
│   │   └── Date+Extentions.swift        # Date utilities
│   ├── Notifications/
│   │   └── NotificationManager.swift    # Local notifications
│   └── Haptics/
│       └── HapticManager.swift          # Haptic feedback
├── Widgets/
│   └── TodayWidget/
│       ├── Provider.swift               # Widget timeline provider
│       └── TodayWidgetEntry.swift       # Widget data model
└── AppIntents/
    └── AddTaskIntent.swift              # Siri integration
```

## 🎯 Key Decisions & Tradeoffs

### 1. **Core Data vs SwiftData**
**Decision**: Used Core Data instead of SwiftData  
**Rationale**: 
- More mature and stable for production use
- Better compatibility with WidgetKit (shared App Group support)
- More control over persistence layer

### 2. **Timer-Based Reset vs Background Tasks**
**Decision**: Timer checks every minute for midnight reset  
**Rationale**:
- Simpler implementation without background task complexity
- Reliable for this use case (tasks reset when app is used)
- Background tasks would require App Group and more setup

### 3. **Date Provider Protocol**
**Decision**: Abstracted date access via `DateProviding` protocol  
**Rationale**:
- Enables unit testing of date-dependent logic
- Allows for time manipulation in tests
- Follows dependency injection principles

### 4. **Clamping Expiration Times**
**Decision**: Task expiration times are clamped to end of day  
**Rationale**:
- Enforces "today only" constraint at the data layer
- Prevents invalid states
- User-friendly: automatically adjusts invalid inputs

### 5. **Singleton Managers**
**Decision**: Used singleton pattern for managers  
**Rationale**:
- Simple and appropriate for app-scoped services
- Easy to access from anywhere (ViewModels, Widgets, App Intents)
- No complex dependency injection needed for this scope

## 🚀 Getting Started

### Requirements
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- macOS 13.0+ for development

### Installation
1. Clone the repository
2. Open `Todo_hackathon.xcodeproj` in Xcode
3. Build and run on a simulator or device

### Running the Widget
1. Build the app
2. Add the widget to your home screen
3. The widget shows the count of today's tasks

### Using Siri Integration
1. Add a task via Siri: "Add task [task name] for today"
2. The task will be created with expiration at end of day

## 🧪 Testing

The project includes:
- Unit test targets (`Todo_hackathonTests`)
- UI test targets (`Todo_hackathonUITests`)
- SwiftUI previews for rapid iteration

## 🔮 Future Improvements

Given more time, I would focus on:

1. **Comprehensive Unit Tests**
   - Test ViewModel logic with mocked date providers
   - Test date filtering and cleanup logic
   - Test notification scheduling

2. **Background Task Support**
   - Implement background app refresh for midnight cleanup
   - Use App Groups for shared data between app and widget

3. **Widget Enhancements**
   - Show actual task list in widget (not just count)
   - Support multiple widget sizes
   - Interactive widget actions

4. **Accessibility**
   - VoiceOver support improvements
   - Dynamic Type support
   - Accessibility labels and hints

5. **Performance Optimizations**
   - Core Data fetch optimizations
   - Reduce timer frequency when app is backgrounded
   - Implement NSFetchedResultsController for reactive updates

6. **Error Handling**
   - Better error messages for Core Data failures
   - Notification permission handling
   - Graceful degradation when services fail

7. **User Experience**
   - Swipe gestures for task deletion
   - Task editing capability
   - Undo/redo support
   - Task categories or tags

## 📝 License

This project was created as a take-home exercise.

## 👤 Author

Built with attention to code quality, architecture, and user experience.

---

**Note**: This app intentionally focuses only on today's tasks. Tasks from previous days are automatically removed, and you cannot schedule tasks for future dates. This constraint is by design to encourage focus and simplicity.
