#import "EncryptionPlugin.h"
#import <Cordova/CDVPlugin.h>

#import "RSA.h"

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
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];


    if (echo != nil && [echo length] > 0) {

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    
}
- (void)decrypt:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* message = [command.arguments objectAtIndex:0];
    NSString* privateKey = [command.arguments objectAtIndex:1];

    NSLog(@"EncryptionPlugin(decrypt)-message: %@", message);
    NSLog(@"EncryptionPlugin(decrypt)-privateKey: %@", privateKey);

    if (message != nil && [message length] > 0 && privateKey != nil && [privateKey length] > 0) {
        
        NSLog(@"EncryptionPlugin(decrypt)- LOG1");

        NSString *result = [self decryptRSAEASString: message privateKey:privateKey ];

        NSLog(@"EncryptionPlugin(decrypt)-result: %@", result);
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (NSString*)decryptRSAEASString:(NSString*)string privateKey:(NSString*)pvK
{
    NSLog(@"EncryptionPlugin(decryptRSAEASString)-string: %@", string);

    NSString *privkey = pvK;

    NSLog(@"EncryptionPlugin(decryptRSAEASString)-privKey: %@", privkey);

    NSString * KeyRSAEncripted = [string substringWithRange:NSMakeRange(0, 684)];

    NSLog(@"EncryptionPlugin(decryptRSAEASString)-keyRSAEnc: %@", KeyRSAEncripted);
  
    NSString * decWithPrivKey = [RSA decryptString:KeyRSAEncripted privateKey:privkey];

    NSLog(@"EncryptionPlugin(decryptRSAEASString)-decWithPrivKey: %@", KeyRSAEncripted);
   
    NSData *prueba05bytes = [self base64DecodeString:decWithPrivKey];

    return decWithPrivKey;
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