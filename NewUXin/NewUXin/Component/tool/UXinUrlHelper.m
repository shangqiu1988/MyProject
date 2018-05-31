//
//  UXinUrlHelper.m
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinUrlHelper.h"

@implementation UXinUrlHelper
+(NSURL *)getUrl:(NSString *)domain interface:(NSString *)interface;
{
 
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",domain,interface]];
    return url;
}
+(NSString *)getUrlString:(NSString *)domain interface:(NSString *)interface
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",domain,interface];
    return urlString;
}
@end
