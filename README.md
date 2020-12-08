# Welcome to OVGU

An official app by Magdeburg University

## Getting Started

Install Flutter: https://flutter.dev/docs/get-started/install

Get dependencies: `flutter pub get`

Generate specific files: `flutter pub run build_runner build`

Run: `flutter run`

## Deploy

### Preparation

Only important if you are allowed to submit this app.

Ignore security related files:
- `git update-index --skip-worktree lib/constants.dart`
- `git update-index --skip-worktree android/app/build.gradle`

Now add the signing key for android according to the config.

### Android

run `flutter build appbundle`

### iOS

run `flutter build ios`

in Xcode select target `Generic iOS Device`

in Xcode run `Product` > `Archive`
