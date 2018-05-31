//
//  UXinDownloadItem.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/26.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinDownloadTask.h"
/**某一的任务下载完成的通知*/
static NSString * const kDownloadTaskFinishedNoti = @"kDownloadTaskFinishedNoti";
/**保存下载数据通知*/
static NSString * const kDownloadNeedSaveDataNoti = @"kDownloadNeedSaveDataNoti";
@class  UXinDownloadItem;
@protocol DownloadItemDelegate <NSObject>

@optional
- (void)downloadItemStatusChanged:(UXinDownloadItem *)item;
- (void)downloadItem:(UXinDownloadItem *)item downloadedSize:(int64_t)downloadedSize totalSize:(int64_t)totalSize;

@end
@interface UXinDownloadItem : NSObject<DownloadTaskDelegate>
/**下载任务标识*/
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *thumbImageUrl;
@property (nonatomic, copy) NSString *downloadUrl;
/**下载完成后保存在本地的路径*/
@property (nonatomic, readonly) NSString *savePath;
@property (nonatomic, assign) NSUInteger fileSize;
@property (nonatomic, assign) NSUInteger downloadedSize;
@property (nonatomic, assign) DownloadStatus downloadStatus;
@property (nonatomic, copy, readonly) NSString *saveName;
@property (nonatomic, weak) id <DownloadItemDelegate> delegate;
@end
