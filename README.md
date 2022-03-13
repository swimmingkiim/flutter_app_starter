# flutter_app_starter
This is a boilerplate for my personal project. Anyone can clone, modify and make your own flutter app.

Note : This repository is focused on integration between service from outside(api, google, apple login etc).
So, you need to Customize logic based on your requirements.

* included code
    1. api
    2. google & apple auth
    3. google drive & apple icloud upload, download
    4. android & ios in-app purchase
    5. router bloc
    6. color scheme for material ui


## Getting Started

### For Development
#### Macos M1 : Run this command first!
```
cd ios
arch -x86_64 pod install --repo-update
```

#### Common
```
cd /path/to/desire
/path/to/this/repo/create-from-template.sh [project name]
```

First, you need to copy `lib/config/config.sample.dart` to `lib/config/config.dart` and fill out required information or leave empty if you don't use them.
```
flutter pub get
[open simulator]
flutter run
```

## References
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