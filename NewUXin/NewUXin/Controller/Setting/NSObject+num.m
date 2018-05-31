//
//  NSObject+num.m
//  NewUXin
//
//  Created by tanpeng on 2018/3/24.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "NSObject+num.h"

@implementation NSObject (num)
+(int)TP_makeConstraints:(void(^)(sunManager *mgr))block
{
    sunManager *mgr=[[sunManager alloc] init];
    block(mgr);
    return mgr.result;
}
@end
