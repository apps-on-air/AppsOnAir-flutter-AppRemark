// YourPluginClass.m
#import "AppRemarkFlutterSdkPlugin.h"
#if __has_include(<appsonair_flutter_appremark/appsonair_flutter_appremark-Swift.h>)
#import <appsonair_flutter_appremark/appsonair_flutter_appremark-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appsonair_flutter_appremark-Swift.h"
#endif

@implementation AppRemarkFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [AppsonairFlutterAppremarkPlugin registerWithRegistrar:registrar];
}
@end
