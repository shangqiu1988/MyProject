//
//  NSString+Common.m
//  NewUXin
//
//  Created by tanpeng on 17/9/5.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#define gkey @"vcomnryyvcomnryyvcomnryy"
#define gIv             @"12345678"
#define kSecrectKeyLength 24
@implementation NSString (Common)
+ (NSString *)UUID {
    NSString *macaddress ;
 
        NSUUID *uuid = [[UIDevice currentDevice]identifierForVendor] ;
        
        macaddress=[uuid UUIDString];
        macaddress=[macaddress stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        return macaddress;
    
}
- (NSString *)md5Str
{
    {
        const char *data = self.UTF8String;
        
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        
        CC_MD5(data, (CC_LONG)strlen(data), digest);
        
        NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
            [result appendFormat:@"%02x", digest[i]];
        }
        
        return result;
        
    }

}
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
-(NSString *)ThreeDesByKey:(NSString *)threeDesKey
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [threeDesKey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *probablyresult = [myData description];
    NSString *resultOne = [probablyresult stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *resultTwo = [resultOne substringToIndex:resultOne.length -1];
    NSString *resultThe = [resultTwo substringFromIndex:1];
    //    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return resultThe;
}
@end
