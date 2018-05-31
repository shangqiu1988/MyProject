//
//  UXinUrlHelper.h
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinUrlHelper : NSObject
+(NSURL *)getUrl:(NSString *)domain interface:(NSString *)interface;
+(NSString *)getUrlString:(NSString *)domain interface:(NSString *)interface;
    

@end
