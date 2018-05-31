//
//  UXinDownloadTask.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/26.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinDownloadTask.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
@implementation UXinDownloadTask

- (instancetype)initWithSaveName:(NSString *)saveName{
    if (self = [super init]) {
        _saveName = saveName;
    }
    return self;
}

#pragma mark - public
-(void)updateTask
{
    _fileSize=(NSInteger)[_downloadTask.response expectedContentLength];
}
#pragma mark- getter
+(NSString *)savePathWithSaveName:(NSString *)saveName
{
    NSString *saveDir = [self saveDir];
    saveDir =  [saveDir stringByAppendingPathComponent:saveName];
    return saveDir;
}
+ (NSString *)saveDir {
    NSString *saveDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject;
    saveDir = [saveDir stringByAppendingPathComponent:@"BackGroundDownload"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:saveDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:saveDir withIntermediateDirectories:true attributes:nil error:nil];
    }
    return saveDir;
}
+(NSString *)getURLFromTask:(NSURLSessionTask *)task
{
    NSURLRequest *req=[task originalRequest];
    return req.URL.absoluteString;
}
#pragma mark - setter
-(void)setDownloadURL:(NSString *)downloadURL
{
    _downloadURL = downloadURL;
    if (_saveName.length == 0) {
        NSString *fileName = [self cachedFileNameForKey:downloadURL];
        _saveName = fileName;
    }else{
        //没有扩展名，根据自动添加
        if([self.saveName pathExtension].length == 0){
            NSString *pathExtension =  [self getPathExtensionWithUrl:downloadURL];
            _saveName = pathExtension.length>0 ? [_saveName stringByAppendingPathExtension:pathExtension] : _saveName;
        }
    }
   
}
-(void)setDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    if(_downloadTask&&downloadTask&&![_downloadTask isEqual:downloadTask]){
        [_downloadTask cancel];
    }
    _downloadTask=downloadTask;
}
#pragma mark - private
- (NSString *)getPathExtensionWithUrl:(NSString *)url {
    NSString *pathExtension = [url pathExtension];
    //过滤url中的参数，取出单独文件名
    NSRange range = [pathExtension rangeOfString:@"?"];
    if (range.location>0 && range.length == 1) {
        pathExtension = [pathExtension substringToIndex:range.location];
    }
    return pathExtension;
}


/**
 通过md5加密生成->保存文件名
 */
- (NSString *)cachedFileNameForKey:(NSString *)key{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    NSString *pathExtension =  [self getPathExtensionWithUrl:key];
    return pathExtension.length>0 ? [filename stringByAppendingPathExtension:pathExtension] : filename;
    
}
@end
