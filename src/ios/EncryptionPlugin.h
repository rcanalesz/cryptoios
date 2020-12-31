#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import "AppDelegate.h"
//#import "FingerViewController.h"

@interface  EncryptionPlugin : CDVPlugin

+ (EncryptionPlugin *)encryptionPlugin;

- (void)encrypt:(CDVInvokedUrlCommand*)command;
- (void)getdecryptwsq:(CDVInvokedUrlCommand*)command;

//- (void)sendResponseFinger:(NSString *)responseText callbackId:(NSString *)callbackId;

//@property (copy, nonatomic) NSString *responseCallbackId;

@end