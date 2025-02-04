# PAMI

PAMI is a location-based social interaction app designed to help users connect in real life through temporary shout-outs. Users can broadcast their availability, interests, or requests, allowing nearby users to engage and interact in a meaningful way. The app emphasizes spontaneity, safety, and ease of use while fostering real-world connections.

## Project Structure

PAMI follows a **Domain-Driven Design (DDD)** approach, with a feature-based folder structure:

```
lib/
│── core/               # Shared utilities, themes, constants
│── data/               # Repositories, API calls, services
│── domain/             # Entities, value objects, business rules
│── application/        # BLoCs, state management
│── views/              # UI components, widgets, screens
│── main.dart           # App entry point
```

Each feature (e.g., Authentication, Map, Messaging) follows this structure within `lib/`.

## Contribution Guidelines

### Branch Naming Conventions
All new work should follow this pattern:
```
pami-[task number]-[task name]
```
Example:
```
pami-101-login-form
```

### Workflow for Collaboration
1. **Fetch the latest `develop` branch**
   ```bash
   git checkout develop
   git pull origin develop
   ```
2. **Create a new feature branch**
   ```bash
   git checkout -b pami-[task number]-[task name]
   ```
3. **Work on the feature, making commits with meaningful messages**
4. **Push changes and create a pull request to `develop`**
   ```bash
   git push origin pami-[task number]-[task name]
   ```
5. **Code review & testing**
6. **Merge to `develop`**, and after testing, into `main`.

## Resources for New Contributors

Familiarize yourself with Flutter and clean architecture using these tutorials:
- [Flutter Clean Architecture & TDD](https://www.youtube.com/watch?v=dc3B_mMrZ-Q)
- [Flutter Firebase & DDD](https://www.youtube.com/playlist?list=PLB6lc7nQ1n4iS5p-IezFFgqP6YvAJy84U)

For general Flutter development, check:
- [Flutter Codelabs](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
