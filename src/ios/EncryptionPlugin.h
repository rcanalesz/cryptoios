
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
- (void)encryptRSA:(CDVInvokedUrlCommand *)command;
- (void)decryptRSA:(CDVInvokedUrlCommand *)command;
- (void)encryptPassword:(CDVInvokedUrlCommand *)command;


- (NSString*)decryptRSAEASString:(NSString*)string privateKey:(NSString*)pvK;
- (NSString*)encryptRSAAESString:(NSString*)string publicKey:(NSString*)pbK;
- (NSString*)decryptRSAString:(NSString*)string privateKey:(NSString*)pvK;
- (NSString*)encryptRSAString:(NSString*)string publicKey:(NSString*)pbK;
- (NSString*)encryptPasswordLegado:(NSString*)string;

- (NSData*)base64DecodeString:(NSString *)string;
- (NSData *)doCiphernew:(NSData *)plainText key:(NSData *)theSymmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;
- (NSData*)createRandomNSData;
- (NSString *)base64EncodeData:(NSData*)dataToConvert;
- (NSData*)base64DecodeString:(NSString *)string;
- (NSData *)doCipher:(NSData *)plainText key:(NSData *)theSymmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;


@end