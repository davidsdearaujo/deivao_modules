# Deivao Modules

A lightweight and flexible module system for Flutter applications, providing dependency injection and module management capabilities.

## Features

- 🎯 Simple module system for organizing application features
- 💉 Built-in dependency injection using auto_injector
- 🔄 Module imports to handle dependencies between features
- 🚀 Easy module initialization and disposal
- 🎨 Widget integration through ModuleWidget

## Getting Started

Add deivao_modules to your pubspec.yaml:

```yaml
dependencies:
  deivao_modules: ^0.0.1
```

## Usage

### Creating a Module

Create a module by extending the `Module` class:

```dart
class UserModule extends Module {
  @override
  List<Type> imports = []; // Add other modules to import if needed

  @override
  FutureOr<void> registerBinds(InjectorRegister i) {
    // Register your dependencies
    i.addSingleton<UserRepository>(() => UserRepositoryImpl());
    i.addSingleton<UserService>(() => UserServiceImpl());
  }
}
```

### Initializing Modules

Use `ModulesInitializer` to manage multiple modules:

```dart
void main() async {
  final initializer = ModulesInitializer();
  
  // Add your modules
  initializer.addModules([
    UserModule(),
    AuthModule(),
    // ... other modules
  ]);

  // Initialize all modules
  await initializer.initAllModules();
  
  runApp(const MyApp());
}
```

### Using ModuleWidget

Wrap your widget tree with `ModuleWidget` to provide module access:

```dart
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModuleWidget(
      builder: (context) => UserModule(),
      child: UserContent(),
    );
  }
}
```

### Module Dependencies

Modules can depend on other modules using the `imports` property:

```dart
class ProfileModule extends Module {
  @override
  List<Type> imports = [UserModule]; // Import dependencies from UserModule

  @override
  FutureOr<void> registerBinds(InjectorRegister i) {
    i.addSingleton<ProfileService>(() => ProfileServiceImpl());
  }
}
```

## Dependency Injection Types

The package supports different types of dependency injection:

- **Singleton**: `addSingleton<T>()` - Creates a single instance that persists throughout the app
- **Lazy Singleton**: `addLazySingleton<T>()` - Creates a singleton instance only when first requested
- **Factory**: `add<T>()` - Creates a new instance each time it's requested
- **Instance**: `addInstance<T>()` - Registers an existing instance
- **Replace**: `replace<T>()` - Replaces an existing registration

## Example

Here's a complete example showing how to use the module system:

```dart
// User module
class UserModule extends Module {
  @override
  List<Type> imports = [];

  @override
  FutureOr<void> registerBinds(InjectorRegister i) {
    i.addSingleton<UserRepository>(() => UserRepositoryImpl());
    i.addSingleton<UserService>(() => UserServiceImpl());
  }
}

// Profile module depending on User module
class ProfileModule extends Module {
  @override
  List<Type> imports = [UserModule];

  @override
  FutureOr<void> registerBinds(InjectorRegister i) {
    i.addSingleton<ProfileService>(() => ProfileServiceImpl());
  }
}

// Usage in widget
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModuleWidget(
      builder: (context) => ProfileModule(),
      child: ProfileContent(),
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

