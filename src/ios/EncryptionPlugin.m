#import "EncryptionPlugin.h"
#import <Cordova/CDVPlugin.h>

#import "RSA.h"

#define LOGGING_FACILITY(X, Y)  \
if(!(X)) {          \
NSLog(Y);       \
}

#define LOGGING_FACILITY1(X, Y, Z)  \
if(!(X)) {              \
NSLog(Y, Z);        \
}

#define kInitVector2 "PyrcyeOXUR2WVCP3v2sIkA=="

@implementation EncryptionPlugin

//@synthesize responseCallbackId = _responseCallbackId;

EncryptionPlugin* encryptionPlugin;


static CCOptions pad = 0;
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (EncryptionPlugin *) encryptionPlugin {
    return encryptionPlugin;
}

- (void)pluginInitialize {
    NSLog(@"EncryptionPlugin - Starting plugin");
    encryptionPlugin = self;
}

//Cordova Functions
- (void)encrypt:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* message = [command.arguments objectAtIndex:0];
    NSString* publicKey = [command.arguments objectAtIndex:1];


    if (message != nil && [message length] > 0 && publicKey != nil && [publicKey length] > 0) {
        
        NSLog(@"EncryptionPlugin(encrypt)- LOG1");

        NSString *result = [self encryptRSAAESString: message publicKey:publicKey ];

        NSLog(@"EncryptionPlugin(encrypt)-result: %@", result);
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];

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
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];

    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

//Main ios Functions
- (NSString*)decryptRSAEASString:(NSString*)string privateKey:(NSString*)pvK
{
    NSString *privkey = pvK;

    NSString * KeyRSAEncripted = [string substringWithRange:NSMakeRange(0, 684)];
  
    NSString * decWithPrivKey = [RSA decryptString:KeyRSAEncripted privateKey:privkey];
   
    NSData *prueba05bytes = [self base64DecodeString:decWithPrivKey];

    NSString * TramaAESEncripted = [string substringWithRange:NSMakeRange(684, string.length-684)];

    NSData *decryptedResponse = [self doCiphernew:[self base64DecodeString:TramaAESEncripted] key:prueba05bytes context:kCCDecrypt padding:&pad];
    NSString * finalString = [NSString stringWithCString:[decryptedResponse bytes] length:[decryptedResponse length]];
    
    return finalString;
}
- (NSString*)encryptRSAAESString:(NSString*)string publicKey:(NSString*)pbK
{
    NSData * sKey = [self createRandomNSData];
    NSString *signatureString = [sKey base64EncodedStringWithOptions:0];
 
    NSString* pubkey = pbK;
    
    NSString *encWithPubKey = [RSA encryptString:signatureString publicKey:pubkey];

    NSData *plainText = [string dataUsingEncoding:NSUTF8StringEncoding];
 
    NSData *encryptedResponse = [self doCiphernew:plainText key:sKey context:kCCEncrypt padding:&pad];

    NSString *UnionKey_Trama = [NSString stringWithFormat:@"%@%@", encWithPubKey,[self base64EncodeData:encryptedResponse]];
    
    return UnionKey_Trama;
}


//Additional Functions
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

- (NSData *)doCiphernew:(NSData *)plainText key:(NSData *)theSymmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7
{
    
    //NSData * iv = [@kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    NSData* iv = [[NSData alloc] initWithBase64EncodedString:@kInitVector2 options:0];
    CCCryptorStatus ccStatus = kCCSuccess;
    
    // Initialization vector; dummy in this case 0's.
    uint8_t auxIV[32];
    memset((void *) auxIV, 0x0, (size_t) sizeof(auxIV));
    
    LOGGING_FACILITY(plainText != nil, @"PlainText object cannot be nil." );
    LOGGING_FACILITY(theSymmetricKey != nil, @"Symmetric key object cannot be nil." );
    LOGGING_FACILITY(pkcs7 != NULL, @"CCOptions * pkcs7 cannot be NULL." );
    //NSLog(@"Contandokey %lu",[theSymmetricKey length]);
    LOGGING_FACILITY([theSymmetricKey length] == kCCKeySizeAES256, @"Disjoint choices for key size." );
    
    size_t operationSize = plainText.length + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(encryptOrDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          theSymmetricKey.bytes,
                                          kCCKeySizeAES256,
                                          [iv bytes],
                                          plainText.bytes,
                                          plainText.length,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    if (cryptStatus == ccStatus) {
        return  [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
        
    }
    
    return nil;
}

-(NSData*)createRandomNSData
{
    int twentyMb           = 32;//20971520; Definir los bytes
    NSMutableData* theData = [NSMutableData dataWithCapacity:twentyMb];
    for( unsigned int i = 0 ; i < twentyMb/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void*)&randomBits length:4];
    }
    
    return theData;
}

- (NSString *)base64EncodeData:(NSData*)dataToConvert
{
    if ([dataToConvert length] == 0)
        return @"";
    
    char *characters = malloc((([dataToConvert length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [dataToConvert length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [dataToConvert length])
            buffer[bufferLength++] = ((char *)[dataToConvert bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}


@end