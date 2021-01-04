#import "EncryptionPlugin.h"
#import <Cordova/CDVPlugin.h>

#import "RSA.h"

@implementation EncryptionPlugin

//@synthesize responseCallbackId = _responseCallbackId;

EncryptionPlugin* encryptionPlugin;


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

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

    NSLog(@"EncryptionPlugin(decryptRSAEASString)-decWithPrivKey: %@", decWithPrivKey);
   
    NSData *prueba05bytes = [self base64DecodeString:decWithPrivKey];

    NSString * TramaAESEncripted = [string substringWithRange:NSMakeRange(684, string.length-684)];

    NSLog(@"EncryptionPlugin(decryptRSAEASString)-TramaAESEncripted: %@", TramaAESEncripted);

    NSData *decryptedResponse = [self doCiphernew:[self base64DecodeString:TramaAESEncripted] key:prueba05bytes context:kCCDecrypt padding:&pad];
    NSString * finalString = [NSString stringWithCString:[decryptedResponse bytes] length:[decryptedResponse length]];

    NSLog(@"EncryptionPlugin(decryptRSAEASString)-finalString: %@", finalString);
    
    return finalString;
}

- (NSData*)base64DecodeString:(NSString *)string
{
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    realloc(bytes, length);
    
    return [NSData dataWithBytesNoCopy:bytes length:length];
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