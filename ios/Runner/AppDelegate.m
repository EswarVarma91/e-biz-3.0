#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyBqgribdISpSb392mekKstHkm-bzC9GBTY"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"AIzaSyBqgribdISpSb392mekKstHkm-bzC9GBTY";
  }
  [GMSServices provideAPIKey:mapsApiKey];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
