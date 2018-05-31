//
//  UXinDownloadItem.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/26.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinDownloadItem.h"
#import <objc/runtime.h>
@implementation UXinDownloadItem
#pragma mark - DownloadTaskDelegate
#pragma mark - YCDownloadSessionDelegate
- (void)downloadProgress:(UXinDownloadTask *)task downloadedSize:(NSUInteger)downloadedSize fileSize:(NSUInteger)fileSize {
    self.downloadedSize = downloadedSize;
    if ([self.delegate respondsToSelector:@selector(downloadItem:downloadedSize:totalSize:)]) {
        [self.delegate downloadItem:self downloadedSize:downloadedSize totalSize:fileSize];
    }
}

- (void)downloadStatusChanged:(DownloadStatus)status downloadTask:(UXinDownloadTask *)task {
    
    if (status == DownloadStatusFinished) {
        self.downloadedSize = self.fileSize;
    }
    self.downloadStatus = status;
    if ([self.delegate respondsToSelector:@selector(downloadItemStatusChanged:)]) {
        [self.delegate downloadItemStatusChanged:self];
    }
    //通知优先级最后，不与上面的finished重合
    if (status == DownloadStatusFinished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadTaskFinishedNoti object:self];
    }
}

- (void)downloadCreated:(UXinDownloadTask *)task {
    self.downloadStatus =DownloadStatusDownloading;
    if(task.fileSize > 0){
        self.fileSize = task.fileSize;
    }
    _saveName = task.saveName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadNeedSaveDataNoti object:nil userInfo:nil];
}
#pragma mark - public

- (NSString *)savePath {
    return [UXinDownloadTask savePathWithSaveName:self.saveName];
}
///  解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (NSInteger i=0; i<count; i++) {
            
            Ivar ivar = ivars[i];
            NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
            if([name isEqualToString:@"_delegate"]) continue;
            id value = [coder decodeObjectForKey:name];
            if(value) [self setValue:value forKey:name];
        }
        
        free(ivars);
    }
    return self;
}

///  归档
- (void)encodeWithCoder:(NSCoder *)coder
{
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (NSInteger i=0; i<count; i++) {
        
        Ivar ivar = ivars[i];
        NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
        if([name isEqualToString:@"_delegate"]) continue;
        id value = [self valueForKey:name];
        if(value) [coder encodeObject:value forKey:name];
    }
    
    free(ivars);
}
@end
