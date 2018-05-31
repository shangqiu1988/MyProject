//
//  UXinReactHelper.m
//  NewUXin
//
//  Created by tanpeng on 2017/12/11.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinReactHelper.h"

@implementation UXinReactHelper
RCT_EXPORT_MODULE(UXinReactHelper);
RCT_EXPORT_METHOD(PopTonative)
{
     [[NSNotificationCenter defaultCenter] postNotificationName:KPopToNative object:nil ];
}
@end
