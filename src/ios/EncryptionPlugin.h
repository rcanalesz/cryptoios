
#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

//#import "FingerViewController.h"

@interface  EncryptionPlugin : CDVPlugin{
}

+ (EncryptionPlugin *)encryptionPlugin;

- (void)encrypt:(CDVInvokedUrlCommand *)command;
- (void)decrypt:(CDVInvokedUrlCommand *)command;

//- (void)sendResponseFinger:(NSString *)responseText callbackId:(NSString *)callbackId;

//@property (copy, nonatomic) NSString *responseCallbackId;

@end