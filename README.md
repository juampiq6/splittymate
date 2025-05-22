# SplittyMate

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

### Environment Variables Setup

The application requires a `.env` file in the root directory with the following variables:

```bash
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
DEEP_LINK_BASE=your_deep_link_base_url
```

To set up the environment variables:

1. Create a new file named `.env` in the root directory
2. Copy the template above and replace the values with your actual credentials:
   - `SUPABASE_URL`: Get this from your Supabase project settings
   - `SUPABASE_ANON_KEY`: Get this from your Supabase project settings
   - `DEEP_LINK_BASE`: The base URL for deep linking (e.g., `https://splittymate.jpq.com.ar`)

For security reasons, the `.env` file is gitignored. When deploying or sharing the project, you can encode the `.env` file to base64:

```bash
base64 -i .env > .env.base64
```

And decode it when needed:

```bash
base64 -d -i .env.base64 > .env
```

### Continuous Integration/Deployment

The project uses GitHub Actions for continuous integration and deployment. The workflow is triggered on pushes to the `prod` branch and performs the following steps:

1. **Environment Setup**
   - Decodes the base64-encoded `.env` file from GitHub Secrets
   - Sets up Flutter with caching for faster builds

2. **Build Process**
   - Installs project dependencies
   - Builds an Android App Bundle (AAB) in release mode

3. **Deployment**
   - Uploads the AAB as a GitHub artifact
   - Distributes the app to internal testers via Firebase App Distribution

To set up the workflow for your own deployment:

1. Add the following secrets to your GitHub repository:
   - `ENV_BASE64`: Your base64-encoded `.env` file
   - `FIREBASE_APP_ID`: Your Firebase App ID
   - `FIREBASE_SERVICE_ACCOUNT`: Your Firebase service account credentials as a raw JSON file

2. Ensure your Firebase project and your Google Play Console project is properly configured for app distribution

The workflow file is located at `.github/workflows/build_publish_artifact.yml` and can be customized as needed.

## Contributing
We welcome contributions! Please feel free to submit pull requests or open issues to help improve SplittyMate.

## License
*[License information to be added]* 