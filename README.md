# Hypnosis Downloads

Online Self Hypnosis MP3 Audio & Scripts Center.

## Getting Started

### For developers:
1. Request access to App Store Connect
3. Request access to Google Play
2. Request access to Firebase

### Install Flutter SDK:
1. `brew install --cask flutter`
2. Add to `~/.zshrc`:
    ```
    # Flutter SDK
    export FLUTTER_ROOT="/opt/homebrew/bin/flutter"
    ```
3. `source ~/.zshrc`

### Install Ruby (for iOS SDK):
1. `brew install rbenv`
2. Add to `~/.zshrc`:
    ```
    # Making sure iOS Cocoapods doesn't have permission errors anymore, since we are not using system Ruby
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
    ```
3. `source ~/.zshrc`
4. `RUBY_CFLAGS="-Wno-error=implicit-function-declaration" rbenv install 2.7.1`
5. `rbenv global 2.7.1`
6. `rbenv rehash`
7. `where ruby` should show:
    ```
    /Users/user/.rbenv/shims/ruby
    /usr/bin/ruby
    ```

### Install iOS SDK:
1. Install XCode via the App Store
2. `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
3. `sudo xcodebuild -runFirstLaunch`

### Install Java (for Android SDK):
1. `brew install java11`
2. `sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk`
3. Add to `~/.zshrc`:
    ```
    # Java
    export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
    JAVA_HOME="/opt/homebrew/opt/openjdk@11"
    ```
4. `source ~/.zshrc`

### Install Android SDK:
1. [Download Android Studio](https://developer.android.com/studio)
2. `yes | sudo ~/Library/Android/sdk/tools/bin/sdkmanager --licenses`
3. Add to `~/.zshrc`:
    ```
    # Android
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/tools/bin
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    ```
4. `source ~/.zshrc`

### Install IDE
1. [Download VS Code](https://code.visualstudio.com/docs/setup)
2. Install [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) in VS Code
3. Run `flutter doctor` to check for any issues

### Run the project
1. Clone this repository
2. Open the project's folder in VS Code
3. Optional: Disable Flutter's web support to avoid cluttering the IDE with irrelevant run targets: `flutter config --no-enable-web`
4. Run `flutter gen-l10n` in root folder
5. Run `flutter packages run build_runner build --delete-conflicting-outputs` to generate files
4. Select a device in the bottom right corner of VS Code and run a simulator
5. Execute `flutter run` command or click the Run button in VS Code

## Deploy

### Install Fastlane
1. `brew install fastlane`
2. Create app-specific password at [appleid.apple.com/account/manage](https://appleid.apple.com/account/manage)
3. Add to `~/.zshrc`:
    ```
    export FASTLANE_PASSWORD="your fastlane password"
    export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="your app specific password"
    ```

### Distribute the app

#### Android
* Via Firebase App Distribution (Staging)
    1. Write release notes separately, to keep them if deployment goes wrong.
    2. `cd android && fastlane alpha && cd ..`
    3. Check the build on [Firebase App Distribution](https://console.firebase.google.com/project/_/appdistribution)
        
* Via Google Play open testing (Production)
    1. `cd android && fastlane beta && cd .. && open build/app/outputs/bundle/`
    2. Open [Google Play Console](https://play.google.com/console/developers)
    3. Paste release notes

#### iOS
1. Write release notes separately, to keep them if deployment goes wrong.
1. `cd ios && pod install --repo-update && fastlane alpha && cd ..`
2. Paste release notes
3. Enter OTP from Apple, if needed
5. Check the build on [AppStore Connect](https://appstoreconnect.apple.com)