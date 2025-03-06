# Todo List App

A simple Todo List application built with Flutter.

## Features

- Add, edit, and delete todos
- Drag and drop to reorder todos
- Categorize todos by status (Not Started, In Progress, Completed)
- Responsive UI

## Getting Started

### Prerequisites

todolist/
├── apps/
│   └── todolist_app/
│       ├── lib/
│       │   ├── main.dart
│       │   └── app.dart
│       └── pubspec.yaml         # Chỉ phụ thuộc các packages con
│
├── packages/
│   ├── core/
│   │   ├── lib/
│   │   │   └── core/
│   │   │       └── utils/
│   │   │           └── priority_helper.dart
│   │   └── pubspec.yaml
│   │
│   ├── domain/
│   │   ├── lib/
│   │   │   └── domain/
│   │   │       └── entities/
│   │   │           └── todo.dart
│   │   └── pubspec.yaml
│   │
│   ├── data/
│   │   ├── lib/
│   │   │   └── data/
│   │   │       └── repositories/
│   │   │           └── todo_repository.dart
│   │   └── pubspec.yaml
│   │
│   ├── presentation/
│   │   ├── lib/
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── todo_bloc.dart
│   │   │       │   ├── todo_event.dart
│   │   │       │   └── todo_state.dart
│   │   │       ├── pages/
│   │   │       │   └── todo_page.dart
│   │   │       └── widgets/
│   │   │           ├── status_column.dart
│   │   │           └── todo_card.dart
│   │   └── pubspec.yaml
│
├── config/                     # Không phải package nên không có pubspec.yaml
│   ├── app_config.dart
│   ├── di.dart
│   ├── logger_config.dart
│   └── router.dart
│
├── melos.yaml
├── analysis_options.yaml
└── README.md
Usage
Add, edit, and delete todos
To edit a todo, click the pencil icon.
To delete a todo, click the trash icon.
To reorder todos, drag the handle icon
To change status, long press and drag to another column.

install melos 

1. Get package with melos : 
melos bootstrap 
2 . run project 
cd apps/ 
flutter run -d macos