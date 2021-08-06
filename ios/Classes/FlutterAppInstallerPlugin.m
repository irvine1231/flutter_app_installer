#import "FlutterAppInstallerPlugin.h"
#if __has_include(<flutter_app_installer/flutter_app_installer-Swift.h>)
#import <flutter_app_installer/flutter_app_installer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_app_installer-Swift.h"
#endif

@implementation FlutterAppInstallerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAppInstallerPlugin registerWithRegistrar:registrar];
}
@end
