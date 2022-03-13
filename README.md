# flutter_app_starter

A new Flutter project.

## Getting Started

### For Development
#### Macos M1 : Run this command first!
```
cd ios
arch -x86_64 pod install --repo-update
```

#### Common
```
flutter pub get
[open simulator]
flutter run
```

## commands for Mac M1
```
cd ./ios
arch -x86_64 pod install --repo-update
```

## commands for android keystore generation
```
mkdir ./android/keystore
keytool -genkey -v -keystore ./android/keystore/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```