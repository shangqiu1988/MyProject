//
//  UXinNetBatchRequest.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConst.h"
#import "UXinNetRequest.h"
NS_ASSUME_NONNULL_BEGIN
@interface UXinNetBatchRequest : NSObject
{
    dispatch_semaphore_t _lock;
    NSUInteger _finishedCount;
    BOOL _failed;
}
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSMutableArray *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray *responseArray;
@property (nonatomic, copy) BCSuccessBlock batchSuccessBlock;
@property (nonatomic, copy) BCFailureBlock batchFailureBlock;
@property (nonatomic, copy) BCFinishedBlock batchFinishedBlock;
- (BOOL)onFinishedOneRequest:(UXinNetRequest *)request response:(nullable id)responseObject error:(nullable NSError *)error;

@end
NS_ASSUME_NONNULL_END
