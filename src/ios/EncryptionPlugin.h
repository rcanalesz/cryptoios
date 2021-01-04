
#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

//#import "FingerViewController.h"

@interface  EncryptionPlugin : CDVPlugin{
}

+ (EncryptionPlugin *)encryptionPlugin;

- (void)encrypt:(CDVInvokedUrlCommand *)command;
- (void)decrypt:(CDVInvokedUrlCommand *)command;

- (NSString*)decryptRSAEASString:(NSString*)string privateKey:(NSString*)pvK;
- (NSData*)base64DecodeString:(NSString *)string;
- (NSData *)doCiphernew:(NSData *)plainText key:(NSData *)theSymmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;

//- (void)sendResponseFinger:(NSString *)responseText callbackId:(NSString *)callbackId;

//@property (copy, nonatomic) NSString *responseCallbackId;

@end