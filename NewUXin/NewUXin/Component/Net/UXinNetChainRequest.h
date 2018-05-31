//
//  UXinNetChainRequest.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConst.h"
#import "UXinNetRequest.h"
NS_ASSUME_NONNULL_BEGIN
@interface UXinNetChainRequest : NSObject
{
     NSUInteger _chainIndex;
}
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) UXinNetRequest *runningRequest;

- (UXinNetChainRequest *)onFirst:(RequestConfigBlock)firstBlock;
- (UXinNetChainRequest *)onNext:(BCNextBlock)nextBlock;

- (BOOL)onFinishedOneRequest:(UXinNetRequest *)request response:(nullable id)responseObject error:(nullable NSError *)error;

@end
NS_ASSUME_NONNULL_END
