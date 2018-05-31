//
//  UXinWebViewMessage.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/19.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinWebViewMessage : NSObject
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, copy) NSString *callbackMethod;
@end
