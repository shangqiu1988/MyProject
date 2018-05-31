//
//  UXinHotUpdateVersionCheck.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/6.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinHotUpdateVersionCheck : NSObject
@property(copy) void (^completionHandler)(NSDictionary*, NSError*);
+ (void)getVersionInfo:(NSURL *)url 
completionHandler:(void (^)(NSDictionary *info, NSError *error))completionHandler;
-(void)sendCheckRequest:(NSURL *)url;
@end
