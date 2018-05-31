//
//  UXinEmptyDataSetWeakObjectContainer.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinEmptyDataSetWeakObjectContainer.h"

@implementation UXinEmptyDataSetWeakObjectContainer
- (instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}
@end
