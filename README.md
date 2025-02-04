# AppsOnAir-flutter-AppRemark

## ⚠️ Important Notice ⚠️

This plugin is currently in **pre-production**. While the plugin is fully functional, the supported services it integrates with are not yet live in production. Stay tuned for updates as we bring our services to production!

## How it works? 

This SDK is used to submit App Remark (Either it is bug/issue or any suggestion/feedback of your app).

AppsOnAir offers a service to monitor your problems or app recommendations/improvements by taking screenshots of your apps when you shake your device.

When you shake the device, it automatically takes screenshots of your apps. By modifying those app screenshots, users can draw attention to the specific problems or any app suggestions for enhancements.

Users have the option to turn off shakeGesture. They can also manually open the "Add Remark" screen.

## Minimum Requirements

- Android Gradle Plugin (AGP): Version 8.0.2 or higher
- Kotlin: Version 1.7.10 or higher
- Gradle: Version 8.0 or higher


### Android Setup

Add meta-data to the app's AndroidManifest.xml file under the application tag.

>Make sure meta-data name is “appId”.

>Provide your application id in meta-data value.


```sh
</application>
    ...
    <meta-data
        android:name="appId"
        android:value="********-****-****-****-************" />
</application>
```

Add below code to setting.gradle.

```sh
pluginManagement {
    ...
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven { url 'https://jitpack.io' }
    }
}
```

Add below code to your root level build.gradle.

```sh
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

Add below code to your Launcher activity.

>Add the following code because Fluter is preventing the SDK from capturing the current screen.

```sh
class MainActivity : FlutterActivity(){
    override fun getRenderMode(): RenderMode {
        return RenderMode.texture
    }
}
```
## Requirements

Minimum deployment target: 12.0

### iOS Setup

Add APIKey in your app info.plist file.
```xml
<key>AppsOnAirAPIKey</key>
<string>XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX</string>
```
how to get APIKey for more details check this [URL](https://documentation.appsonair.com/Mobile-Quickstart/ios-sdk-setup)

This pod requires photo permissions. Add the following usage description to your Info.plist:


```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>$(PRODUCT_NAME) need permission to choose image from gallery for App Remark feature.</string>
```


## Example

Follow this step to add App Remarks using shakeGesture with the default theme of "Add Remark" screen.

```sh
 @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () async {
      await AppRemarkService.initialize(context);
    });
  }
```

Follow this step to add App Remarks using shakeGesture with the custom theme of "Add Remark" screen.

Here users can customize the theme of "Add Remark" screen according to their app theme by passing "options" inform of Map, which contains key-value pair of user's theme data.

Users have to pass given keys into "options". Using "options", this SDK will set the theme of "Add Remark" screen.

>Make sure keys are same as below.

| Key                     | DataType | Value                       | Description                    |
| :---------------------- | :------- | :-------------------------- | :----------------------------- |
| `pageBackgroundColor`   | `String` | `"#E8F1FF"`               | Set page background color      |
| `appBarBackgroundColor` | `String` | `"#E8F1FF"`               | Set appbar background color    |
| `appBarTitleText`       | `String` | `"Add Remark"`              | Set appbar title text          |
| `appBarTitleColor`      | `String` | `"#000000"`               | Set appbar title color         |
| `remarkTypeLabelText`   | `String` | `"Remark Type"`             | Set remark type label text     |
| `descriptionLabelText`  | `String` | `"Description"`             | Set description label text     |
| `descriptionHintText`   | `int`    | `"Add description here..."` | Set description hint text      |
| `descriptionMaxLength`  | `String` | `255`                       | Set description max length     |
| `buttonText`            | `String` | `"Submit"`                  | Set button text                |
| `buttonTextColor`       | `String` | `"#FFFFFF"`               | Set button text color          |
| `buttonBackgroundColor` | `String` | `"#007AFF"`               | Set button background color    |
| `labelColor`            | `String` | `"#000000"`               | Set textfield label color      |
| `hintColor`             | `String` | `"#B1B1B3"`               | Set textfield hint color       |
| `inputTextColor`        | `String` | `"#000000"`               | Set textfield input text color |


```sh
AppRemarkService.initialize(
    context, 
    options: {
        'pageBackgroundColor': '#FFC0CB',
        'descriptionMaxLength': 25,
    });
```

"shakeGestureEnable" is set to true by default, allowing the device to capture your current screen when it shakes. If it is false, the device shake's auto-capture screen will be disabled.

```sh
AppRemarkService.initialize(
    context,
    shakeGestureEnable: false,
);
```

Follow this step to open AppRemark screen manually,

```sh
AppRemarkService.addRemark(context);
```

Follow this step to send your customize payload, which you want to save in order to monitor your app.

Users have to pass "extraPayload" inform of Map, which contains key-value pair of user's additional meta-data.

```sh
AppRemarkService.addRemark(
    context,
    extraPayload: {
        'title' : 'Initial Demo',
        'isFromIndia' : true
    });
```