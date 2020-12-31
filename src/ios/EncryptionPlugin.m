#import "EncryptionPlugin.h"
#import <Cordova/CDVPlugin.h>

@implementation EncryptionPlugin

//@synthesize responseCallbackId = _responseCallbackId;

EncryptionPlugin* encryptionPlugin;

+ (EncryptionPlugin *) encryptionPlugin {
    return encryptionPlugin;
}

- (void)pluginInitialize {
    NSLog(@"EncryptionPlugin - Starting plugin");
    encryptionPlugin = self;
}

- (void)encrypt:(CDVInvokedUrlCommand*)command
{

    NSLog(@"EncryptionPlugin - INSIDE ENCRYPT");

    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];


    NSLog(@"EncryptionPlugin - INSIDE ENCRYPT2");
    NSLog(@"EncryptionPlugin: %@", echo);

    if (echo != nil && [echo.message length] > 0) {

        NSLog(@"EncryptionPlugin - INSIDE ENCRYPT2.5");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo.message];
    } else {

        NSLog(@"EncryptionPlugin - INSIDE ENCRYPT2.5");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }


    NSLog(@"EncryptionPlugin - INSIDE ENCRYPT3");

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


    NSLog(@"EncryptionPlugin - INSIDE ENCRYPT4");
    
}
- (void)decrypt:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

/*- (void)sendResponseFinger:(NSString *)responseText callbackId:(NSString *)callbackId{
    if (callbackId != nil) {
        NSLog(@"In response = %@",self.responseCallbackId);
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseText];
        [pluginResult setKeepCallbackAsBool:NO];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.responseCallbackId];
    }
}*/

@end