# Todo List App

A simple Todo List application built with Flutter.

## Features

- Add, edit, and delete todos
- Drag and drop to reorder todos
- Categorize todos by status (Not Started, In Progress, Completed)
- Responsive UI

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine
- An IDE such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. Clone the repository:

```sh
git clone https://github.com/yourusername/todolist.git
cd todolist

2. Install dependencies:

flutter pub get

3.Run the app:

flutter run

Project Structure
todolist/
├── lib/
│   ├── core/
│   │   └── utils/
│   │       └── priority_helper.dart
│   ├── domain/
│   │   └── entities/
│   │       └── todo.dart
│   ├── src/
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   │   ├── todo_bloc.dart
│   │   │   │   ├── todo_event.dart
│   │   │   │   └── todo_state.dart
│   │   │   ├── pages/
│   │   │   │   └── todo_page.dart
│   │   │   └── widgets/
│   │   │       ├── status_column.dart
│   │   │       └── todo_card.dart
│   │   └── repositories/
│   │       └── todo_repository.dart
├── analysis_options.yaml
└── pubspec.yaml

Usage : 

- Add, edit, and delete todos
- To edit a todo, click the pencil icon.
- To delete a todo, click the trash icon.
- To reorder todos, drag the handle icon
- To change status longpress and drag to other column.