//
//  UXinDomainRequest.m
//  NewUXin
//
//  Created by tanpeng on 2018/2/22.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinDomainRequest.h"

@implementation UXinDomainRequest
-(YTKRequestMethod)requestMethod
{
    return  YTKRequestMethodGET;
}
-(NSString *)requestUrl
{
    return @"http://192.168.149.3/get_yx_url.php";
}

@end
