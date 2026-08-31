# todo-frontend

An iOS client for the to-do list, written in SwiftUI. It communicates with
[todo-backend](https://github.com/XulunH/todo-backend) and follows the Figma prototype for
layout and styling.

## Requirements

- Xcode 16 or later
- An iOS 17.6+ simulator or device

## Running

Start the API first (see the backend README) and leave it running on `http://localhost:5248`.
Then, open `TodoApp/TodoApp.xcodeproj` and run the project.

Simulator screenshots were taken on an iPhone 16e (390x844 points), which matches the Figma frame exactly.

If you need to point the app to a different environment, you can update the base URL at the top of
`Networking/APIClient.swift`. Note that `Info.plist` currently allows local HTTP so the simulator can reach
localhost without TLS; this development exception should be removed before shipping.

## Layout

```text
TodoApp/TodoApp/
  Models/       TodoTask, request bodies, user settings
  Networking/   APIClient, error type, shared JSON coders
  ViewModels/   TaskListViewModel, TaskFormViewModel
  Views/        TaskListView, TaskRowView, TaskFormView, SettingsView
  Support/      Theme, date formatting, settings persistence
  Resources/    Inter font files
```

The app uses the MVVM architecture. Views handle layout and user input, view models manage state and API calls,
and `APIClient` is the only type that knows about URLs, HTTP methods, and status codes.
Any non-2xx response is returned as a single `APIError` carrying the server's message, relieving
views from having to interpret status codes.

`TaskFormView` backs both the Create and Edit screens. They differ only in the title and
whether the fields start populated, so a `Mode` enum covers the difference rather than
duplicating the screen.

Filter and sort choices persist to `UserDefaults`, so they survive relaunches.

## Design

`Support/Theme.swift` holds the measurements taken from the prototype (sizes, spacing,
colors, and fonts). This ensures the numbers live in one place rather than being scattered as
literals throughout the views.

Inter is bundled in `Resources/Fonts` because the design specifies it and it isn't a system
font. Only Regular and Medium are included, as those are the two weights used in the design.

Icons are SF Symbols rather than the Material icons in the prototype. They ship with iOS,
scale to any size without separate assets, and are already recognizable to iOS users. The
trade-off is that a few don't match the mockup exactly; the calendar in the date field is
the most noticeable.

Two areas where I deliberately went beyond the prototype:

- Create, Edit, and Settings are presented as sheets. The original design shows them as full screens
  with only a Save button, which would leave no way to exit the Create screen without saving.
  Using a sheet allows users to simply swipe it away.
- The list has loading and empty states, which the prototype doesn't cover.

The Save button remains enabled even when the name is empty (matching the design). However,
tapping it will prompt the user about the missing information. This mirrors the server's validation rules,
catching the problem locally before it results in a 400 Bad Request.

## Known gaps

Font sizes are currently fixed rather than scaling with Dynamic Type. The design pins the task card
to a 90pt height, which larger text would overflow. While supporting accessibility text sizes
properly would require letting the card grow (which is the right approach for a production app), I
kept the design's original proportions here.

There are currently no automated tests. The first areas worth covering would be the
`sort_by` parameter construction and date decoding, as both have edge cases that are easy to get
wrong and might remain invisible until displayed incorrectly.
