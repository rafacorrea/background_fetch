#import "BackgroundFetchPlugin.h"

@interface BackgroundFetchPlugin ()

@property (strong, nonatomic) FlutterMethodChannel *channel;

@end

@implementation BackgroundFetchPlugin


+ (instancetype)sharedInstance
{
    static BackgroundFetchPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [BackgroundFetchPlugin new];
    });
    return sharedInstance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  BackgroundFetchPlugin.sharedInstance.channel = [FlutterMethodChannel
      methodChannelWithName:@"background_fetch"
            binaryMessenger:[registrar messenger]];
    
  [registrar addApplicationDelegate:BackgroundFetchPlugin.sharedInstance];
  [registrar addMethodCallDelegate:BackgroundFetchPlugin.sharedInstance channel:BackgroundFetchPlugin.sharedInstance.channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    printf("performing fetch..\n");
    
    [self.channel invokeMethod:@"BackgroundFetch#performFetch" arguments:nil result:^(id _Nullable answer){
        
        NSInteger casted = [answer integerValue];
        UIBackgroundFetchResult fetchResult;
        switch (casted)
        {
            case 0:
                fetchResult = UIBackgroundFetchResultNewData;
                break;
            case 1:
                fetchResult = UIBackgroundFetchResultNoData;
                break;
            case 2:
                fetchResult = UIBackgroundFetchResultFailed;
                break;
            default:
                fetchResult = UIBackgroundFetchResultFailed;
                
        }
        completionHandler(fetchResult);
    }];
    
}

@end
