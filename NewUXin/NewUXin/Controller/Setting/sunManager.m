//
//  sunManager.m
//  NewUXin
//
//  Created by tanpeng on 2018/3/24.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "sunManager.h"

@implementation sunManager
-(sunManager * (^)(int))add:(int)value
{
    return ^(int value){
        _result+=value;
        return self;
    };
}
@end
