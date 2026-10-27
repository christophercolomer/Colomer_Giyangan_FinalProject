# RainCheck: Class-Day Planner with Weather

> TODO: replace "RainCheck" everywhere if you pick a different app name.

A Flutter mobile app that helps students manage class tasks and deadlines while keeping an eye on the day's weather. It shows a daily forecast and suggests what to prepare for, such as bringing an umbrella or leaving earlier.

Final Project for **SE2142 Software Engineering Tools and Practices**, BSSE 2.

## Screenshots

> TODO: add real screenshots to `docs/screenshots/` and keep the paths below in sync.

| Today | Task list | Add / edit task |
| --- | --- | --- |
| ![Today](docs/screenshots/today.png) | ![Task list](docs/screenshots/task_list.png) | ![Add task](docs/screenshots/add_task.png) |

| Task detail | Forecast | Settings |
| --- | --- | --- |
| ![Task detail](docs/screenshots/task_detail.png) | ![Forecast](docs/screenshots/forecast.png) | ![Settings](docs/screenshots/settings.png) |

## Problem and target users

Students juggle deadlines, classes, and commutes in separate places. A missed deadline or an unexpected downpour can cost grades or a whole day, and no single app connects the two. RainCheck is for college students, especially those who commute.

## Features

- Add, view, edit, complete, and delete class tasks (full CRUD)
- Today screen with pending tasks and a current-weather summary
- Weather-based suggestions (umbrella, leave earlier, outdoor tasks may need rescheduling)
- Multi-day forecast from a live REST API
- Filters for pending and completed tasks
- Form validation on add/edit
- Empty states, loading indicators, and failed-request messages
- Offline handling that shows the last saved forecast
- Custom app icon and splash screen

> TODO: remove anything you don't actually finish. Every feature listed here must be demonstrable in the live demo.

## Tech stack

| Item | Choice |
| --- | --- |
| Framework | Flutter |
| Language | Dart |
| Platform | Android |
| State management | Provider (`ChangeNotifier`) |
| API | [Open-Meteo](https://open-meteo.com/) forecast API (free, no API key) |

## Packages used

> TODO: update this list to match your final `pubspec.yaml`.

| Package | Purpose |
| --- | --- |
| `provider` | Shared app state |
| `http` | REST API calls |
| `intl` | Date formatting |
| `shared_preferences` | Saving settings and the last forecast for offline use |
| `connectivity_plus` | Detecting no-internet state |
| `flutter_launcher_icons` | Custom app icon |
| `flutter_native_splash` | Splash screen |

## Project structure

```
lib/
  main.dart            # App entry point, theme, named routes
  models/              # Task, Forecast (JSON parsing)
  providers/           # TaskProvider, WeatherProvider
  services/            # WeatherService (http calls)
  screens/             # Home, TaskList, TaskDetail, AddEditTask, Forecast, Settings
  widgets/             # Reusable widgets (TaskCard, WeatherCard, EmptyState, ...)
```

> TODO: adjust the folder contents to match your repo.

## API

RainCheck uses the Open-Meteo forecast endpoint:

```
GET https://api.open-meteo.com/v1/forecast
    ?latitude={lat}&longitude={lon}
    &daily=weather_code,temperature_2m_max,precipitation_probability_max
    &timezone=auto
```

The JSON response is parsed into a `Forecast` model in `lib/models/`, and `WeatherProvider` exposes loading, success, and error states to the UI.

## Setup and run

### Requirements

- Flutter SDK (run `flutter --version` and note the version here: TODO)
- Android Studio or VS Code with the Flutter extension
- An Android emulator or a physical Android device

### Steps

```bash
git clone https://github.com/TODO-username/TODO-repo.git
cd TODO-repo
flutter pub get
flutter run
```

### Code quality checks

```bash
flutter analyze
dart format .
```

### Build the release APK

```bash
flutter build apk --release
```

The APK is generated at `build/app/outputs/flutter-apk/app-release.apk`.

> TODO: document how you set up the app icon and splash screen (for example, the `flutter_launcher_icons` and `flutter_native_splash` commands you ran) and what changed between your debug and release builds.

## Team

| Member | Role and responsibilities | GitHub |
| --- | --- | --- |
| Christopher Colomer | TODO (for example: UI lead, Git/repo manager) | @TODO |
| TODO | TODO | @TODO |

## Workflow

- Branches follow `feature/<name>` (for example, `feature/api-service`) and are merged into `main` through pull requests with review comments.
- Tasks are planned and assigned with GitHub Issues / the Projects board.

> TODO: add links to your Projects board and a few example pull requests once they exist.

## Debugging case

> TODO: fill this in with a real bug your team found. The rubric needs the bug, how you found it, and the fix. Do not invent one; write it up when it happens and take the screenshot then.

**Bug:** what went wrong, as a user would see it.

**How we found it:** which tool you used (Flutter DevTools inspector or debugger, hot reload/restart, or reading a stack trace), with a screenshot in `docs/screenshots/`.

**Fix:** what you changed, in which file, and why it works.

## References

> TODO: list every package, API, tutorial, documentation page, and AI tool you used. The course requires proper citations, including AI tools.

- [Flutter documentation](https://docs.flutter.dev/)
- [Dart documentation](https://dart.dev/guides)
- [Open-Meteo API docs](https://open-meteo.com/en/docs)
- [Provider package](https://pub.dev/packages/provider)
- [http package](https://pub.dev/packages/http)