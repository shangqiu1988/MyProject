//
//  UXinGCDSemaphore.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinGCDSemaphore : NSObject
@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

#pragma 初始化
- (instancetype)init;
- (instancetype)initWithValue:(long)value;

#pragma mark - 用法
- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end
