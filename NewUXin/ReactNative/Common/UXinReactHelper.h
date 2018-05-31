//
//  UXinReactHelper.h
//  NewUXin
//
//  Created by tanpeng on 2017/12/11.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#define KPopToNative @"KPopToNative"
@interface UXinReactHelper : NSObject<RCTBridgeModule>

@end
