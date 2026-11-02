# AppsOnAir-flutter-AppRemark

A Flutter plugin for [AppsOnAir AppRemark](https://documentation.appsonair.com) — capture in-app feedback and bug reports via shake gesture or manual trigger.

When the user shakes the device, the SDK automatically takes a screenshot. The user can annotate it, select a remark type, add a description, and submit. You can also open the remark sheet programmatically at any time.

---

## Minimum Requirements

### Android

| Tool | Minimum version |
|------|----------------|
| Android Gradle Plugin (AGP) | 9.0.1 |
| Kotlin | 2.2.20 |
| Gradle | 9.1.0 |
| `minSdk` | 21 |

### iOS

Minimum deployment target: **iOS 15.0**

---

## Android Setup

### 1. App ID in AndroidManifest.xml

Add the following `<meta-data>` inside the `<application>` tag:

```xml
<application>
    ...
    <meta-data
        android:name="AppsonairAppId"
        android:value="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" />
</application>
```

### 2. JitPack repository

Add JitPack to `settings.gradle` (or `settings.gradle.kts`):

```groovy
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven { url 'https://jitpack.io' }
    }
}
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

### 3. TextureView rendering (required for screenshots)

Flutter's default `SurfaceView` uses hardware GPU rendering that cannot be captured by standard Android screenshot APIs, resulting in a black image. Switch to `TextureView` in your `MainActivity`:

```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode

class MainActivity : FlutterActivity() {
    override fun getRenderMode(): RenderMode = RenderMode.texture
}
```

---

## iOS Setup

### 1. App ID in Info.plist

```xml
<key>AppsonairAppId</key>
<string>XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX</string>
```

For more details on obtaining your application ID, see the [AppsOnAir documentation](https://documentation.appsonair.com/MobileQuickstart/GettingStarted).

### 2. Photo library permission in Info.plist

Required for attaching screenshots to remarks:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to attach screenshots to remarks.</string>
```

### 3. Dependency manager

This plugin supports both **CocoaPods** and **Swift Package Manager (SPM)**. SPM requires Flutter 3.24.0 or higher.

#### Swift Package Manager (recommended)

Enable SPM globally:

```sh
flutter config --enable-swift-package-manager
```

Then run `flutter pub get`. Flutter resolves `AppsOnAir-iOS-AppRemark v1.2.3` via SPM automatically — no additional Xcode configuration needed.

Alternatively, enable per-project in `pubspec.yaml`:

```yaml
flutter:
  config:
    enable-swift-package-manager: true
```

#### CocoaPods

```sh
flutter pub get
cd ios && pod install
```

| `enable-swift-package-manager` | Flutter version | Result |
|:---:|:---:|:---|
| `true` or global on | ≥ 3.24.0 | **SPM** |
| `false` or global off | any | **CocoaPods** |

> **Recommendation:** Use Swift Package Manager — it is Apple's actively maintained dependency manager and receives updates first.

---

## Usage

### Initialize

Call `initialize` once, typically in `initState`. It registers the shake gesture listener and sets up the remark sheet.

```dart
import 'package:appsonair_flutter_appremark/app_remark_service.dart';

@override
void initState() {
  super.initState();
  AppRemarkService.initialize(
    context,
    onRemarkResponse: (result) {
      // Called after each remark is submitted
      debugPrint('AppRemark response: $result');
    },
  );
}
```

### Initialize with custom shake sensitivity

Control how easy it is to trigger the shake gesture:

```dart
AppRemarkService.initialize(
  context,
  shakeSensitivity: ShakeSensitivity.high,
  onRemarkResponse: (result) { },
);
```

#### ShakeSensitivity values

| Value | Description |
|-------|-------------|
| `ShakeSensitivity.veryLow` | Very hard, deliberate shake required |
| `ShakeSensitivity.low` | Firm shake required |
| `ShakeSensitivity.medium` | Normal shake (default) |
| `ShakeSensitivity.high` | Light shake triggers feedback |
| `ShakeSensitivity.veryHigh` | Any motion triggers feedback |

### Initialize with custom theme

Pass `options` as a `Map<String, dynamic>` to override the remark sheet appearance:

```dart
AppRemarkService.initialize(
  context,
  options: {
    'pageBackgroundColor':   '#FFFFFF',
    'appBarBackgroundColor': '#007AFF',
    'appBarTitleText':       'Send Feedback',
    'appBarTitleColor':      '#FFFFFF',
    'buttonText':            'Submit',
    'buttonTextColor':       '#FFFFFF',
    'buttonBackgroundColor': '#007AFF',
    'labelColor':            '#000000',
    'hintColor':             '#B1B1B3',
    'inputTextColor':        '#000000',
    'remarkTypeLabelText':   'Remark Type',
    'descriptionLabelText':  'Description',
    'descriptionHintText':   'Describe the issue…',
    'descriptionMaxLength':  500,
  },
  onRemarkResponse: (result) { },
);
```

#### Theme options reference

| Key | Type | Default | Description |
|:----|:-----|:--------|:------------|
| `pageBackgroundColor` | `String` | `"#FFFFFF"` | Page background color |
| `appBarBackgroundColor` | `String` | `"#FFFFFF"` | App bar background color |
| `appBarTitleText` | `String` | `"Add Remark"` | App bar title |
| `appBarTitleColor` | `String` | `"#000000"` | App bar title color |
| `remarkTypeLabelText` | `String` | `"Remark Type"` | Remark type field label |
| `descriptionLabelText` | `String` | `"Description"` | Description field label |
| `descriptionHintText` | `String` | `"Add description here..."` | Description placeholder |
| `descriptionMaxLength` | `int` | `255` | Max characters in description |
| `buttonText` | `String` | `"Submit"` | Submit button label |
| `buttonTextColor` | `String` | `"#FFFFFF"` | Submit button text color |
| `buttonBackgroundColor` | `String` | `"#007AFF"` | Submit button background |
| `labelColor` | `String` | `"#000000"` | Field label color |
| `hintColor` | `String` | `"#B1B1B3"` | Field hint text color |
| `inputTextColor` | `String` | `"#000000"` | Field input text color |

### Disable shake gesture

To disable automatic shake detection and rely solely on `addRemark`:

```dart
AppRemarkService.initialize(
  context,
  shakeGestureEnable: false,
  onRemarkResponse: (result) { },
);
```

### Open remark sheet manually

```dart
await AppRemarkService.addRemark(context);
```

### Attach custom metadata

Send additional key-value data with every remark. Call this any time before or after `initialize` — the payload is merged server-side.

```dart
await AppRemarkService.setAdditionalMetaData(extraPayload: {
  'userId':    'USER_ID',
  'userName':  'USER_NAME',
  'userEmail': 'user@example.com',
  'screen':    'CheckoutScreen',
});
```

---

## Full example

```dart
import 'package:appsonair_flutter_appremark/app_remark_service.dart';
import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    AppRemarkService.initialize(
      context,
      shakeSensitivity: ShakeSensitivity.medium,
      options: const {},
      onRemarkResponse: (result) {
        debugPrint('Remark submitted: $result');
      },
    );
    AppRemarkService.setAdditionalMetaData(extraPayload: {
      'userId':   'USER_ID',
      'userName': 'USER_NAME',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => AppRemarkService.addRemark(context),
          child: const Text('Send Feedback'),
        ),
      ),
    );
  }
}
```
