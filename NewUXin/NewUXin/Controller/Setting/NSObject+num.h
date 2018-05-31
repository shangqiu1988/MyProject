//
//  NSObject+num.h
//  NewUXin
//
//  Created by tanpeng on 2018/3/24.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sunManager.h"
@interface NSObject (num)
+(int)TP_makeConstraints:(void(^)(sunManager *mgr))block;
@end
