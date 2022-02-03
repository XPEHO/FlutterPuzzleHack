# Xpeho FlutterPuzzleHack

This project contains the FlutterPuzzleHack Xpeho participation sources

## Getting Started With Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## macOS arm64 Build (M1 chip)

If you use a MacOS machine, you can build the app for arm64 using the following command:

```bash
$ sudo arch -x86_64 gem install ffi
$ cd macos # or ios
$ arch -x86_64 pod install
$ cd ..
$ flutter build macos --debug # or flutter run -d macos
```

This commands will build the macOS app for x86_64 architecture and will run the app using Rosetta.