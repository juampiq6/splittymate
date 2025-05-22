# SplittyMate

## Table of Contents
- [Overview](#overview)
- [Why SplittyMate?](#why-splittymate)
- [Flutter Project Structure](#flutter-project-structure)
  - [Directory Organization](#directory-organization)
  - [State Management](#state-management)
  - [Key Dependencies](#key-dependencies)
  - [Development Tools](#development-tools)
  - [Testing Strategy (Planned)](#testing-strategy-planned)
- [Backend Architecture](#backend-architecture)
  - [Authentication (Supabase Auth)](#authentication-supabase-auth)
  - [Database (Supabase PostgreSQL)](#database-supabase-postgresql)
  - [Backend Services (Supabase Functions)](#backend-services-supabase-functions)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Base64 Encoding/Decoding](#base64-encodingdecoding)
  - [Encode base64 the .env file](#encode-base64-the-env-file)
  - [Decode base64 the .env file](#decode-base64-the-env-file)
- [Development Resources](#development-resources)
  - [Flutter Documentation](#flutter-documentation)
  - [First Flutter App](#first-flutter-app)
  - [Flutter Cookbook](#flutter-cookbook)
- [Contributing](#contributing)
- [License](#license)

## Overview
SplittyMate is an open-source expense sharing application, similar to Splitwise, designed to make splitting expenses with friends and family simple and hassle-free.

## Why SplittyMate?

- **Open Source**: Full access to the source code
- **Easy to Use**: Intuitive interface for managing shared expenses
- **Self-Hostable**: Deploy and run on your own infrastructure
- **Privacy-Focused**: 
  - No advertisements
  - No data monetization
  - Passwordless authentication for hassle-free login

## Flutter Project Structure

The application is built using Flutter and follows a clean, organized structure:

#### Directory Organization
```
lib/
├── consts.dart             # Application constants
├── env_vars.dart           # Environment variables
├── models/                 # Data models and DTOs
├── providers/              # Riverpod providers for state management
├── routes/                 # Application routing configuration
├── services/               # Service layer (API clients, etc.)
├── ui/                     # UI components and screens
│   ├── common/             # Common UI components and screens
│   ├── themes.dart         # App theming
│   ├── utils.dart          # Utility functions
│   └── ...                 # Screens, features, etc.
└── main.dart               # Application entry point
```

#### State Management
The app uses a combination of state management solutions:
- **Riverpod**: Primary state management solution for global state and dependency injection
- **BLoC**: Used for complex feature-specific state management

#### Key Dependencies
- **Authentication & Backend**:
  - `supabase_flutter`: Backend and authentication services
  - `flutter_dotenv`: Environment variables management
  - `dart_jsonwebtoken`: JWT token handling (only decoding and expiration check)

- **State Management & Routing**:
  - `flutter_riverpod`: State management
  - `flutter_bloc`: Feature-specific state management
  - `go_router`: Declarative routing

- **UI & UX**:
  - `google_fonts`: Typography
  - `flutter_svg`: SVG rendering
  - `device_preview`: Device preview for development purposes
  - `pin_code_fields`: OTP code input field
  - `share_plus`: Native sharing capabilities

- **Development**:
  - `flutter_lints`: Code quality and style enforcement
  - `flutter_launcher_icons`: App icon generation

#### Development Tools
- **Flutter Version**: 3.29.3 (specified in `.tool-versions` and `pubspec.yaml`)
- **Dart SDK**: >=3.3.0 <4.0.0
- **Code Quality**: Uses Flutter lints for consistent code style

#### Testing Strategy (Planned)
The following testing layers will be implemented to ensure code quality and reliability:

- **Unit Tests**:
  - Test individual functions and methods
  - Focus on business logic in services and providers
  - Mock Supabase client and other external dependencies
  - Target coverage: 80% for critical business logic

- **Widget Tests**:
  - Test UI components in isolation
  - Verify widget rendering and interactions
  - Test form validations and user inputs
  - Focus on reusable widgets in `ui/widgets/`

- **Integration Tests**:
  - Test complete features and user flows
  - Verify Supabase integration
  - Test authentication flows
  - Test expense management workflows
  - Test group management and invitations

- **End-to-End Tests**:
  - Focus on main user flows:
    - User registration and login
    - Group creation and management
    - Expense creation and settlement
    - Payment creation and settlement

Testing tools to be used:
- `flutter_test` for unit and widget tests
- `integration_test` package for integration tests
- `mockito` for mocking dependencies
- GitHub Actions for continuous testing

## Backend Architecture

### Authentication (Supabase Auth)
SplittyMate integrates Supabase for authentication, which is leveraged to the open source auth GoTrue API, with the following features:
- Passwordless login via email magic links
- Authenticated user can change their email address
- Customizable email templates (available in project repository)

### Database (Supabase PostgreSQL)
The application uses a PostgreSQL database with the following structure:

#### Tables
- `users`: User account information
- `groups`: Expense sharing groups
- `expenses`: Individual expense records
- `payments`: Payment tracking
- `member`: Group membership management

#### Security
- Row Level Security (RLS) policies implemented for each table
- Comprehensive access control

#### Database Triggers
Automated actions on:
- Insert operations
    - When a row is inserted, the updated_at, created_at and updated_by columns are updated
- Update operations
    - When a row is updated, the updated_at, updated_by columns are updated


### Backend Services (Supabase Functions)
TypeScript-based serverless functions for:
- JWT token generation for group invitations:
    - A JWT token is created with a payload containing the group id and other invitation data.
    - The JWT token is signed to ensure the integrity and authenticity of the data.
- JWT token verification and group member management:
    - The JWT token is verified to ensure it is valid and not expired.
    - The group id and other invitation data are extracted from the JWT token.
    - The user is added to the group as a member.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Environment Variables

The application requires a `.env` file in the root directory. See [newReadme.md](newReadme.md) for detailed setup instructions.

## Base64 Encoding/Decoding

### Encode base64 the .env file

```bash
base64 -i .env > .env.base64
```

### Decode base64 the .env file

```bash
base64 -d -i .env.base64 > .env
```

## Contributing
We welcome contributions! Please feel free to submit pull requests or open issues to help improve SplittyMate.

## License
*[License information to be added]* 