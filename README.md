# Xpeho FlutterPuzzleHack

![Photo Booth Header][logo]

A slide puzzle built for [Flutter Challenge](https://flutterhack.devpost.com/).

*Built by [XPEHO][xpeho_link].*


---

## Getting Started 🚀

To run the project either use the launch configuration in VSCode/Android Studio/IntelliJ or use the following command:

```sh
$ flutter run -d chrome
```

---


## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "team_name": "Xpeho mobile",
    "@team_name": {
      "description": "Team name"
    }
}
```

---

## XPEHO FlutterPuzzleHack Cross Platform ⌚️💻📱

Available platforms : 

- [Web][pwa_link]
- IOS 
- Android
- MacOS
- Windows 

Coming soon Linux and ... WatchOS


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


---


[logo]: assets/images/header_readme.png
[xpeho_link]: https://xpeho.fr/
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[pwa_link]: https://xpeho-flutter-puzzle-hack.web.app/
