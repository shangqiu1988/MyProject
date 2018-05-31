//
//  NSObject+BindingNetRequest.m
//  NewUXin
//
//  Created by tanpeng on 17/8/8.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "NSObject+BindingNetRequest.h"
#import <objc/runtime.h>
static NSString * const kRequestBindingKey = @"RequestBindingKey";
@implementation NSObject (BindingNetRequest)

-(void)bindingRequest:(UXinNetRequest *)request
{
    objc_setAssociatedObject(self, (__bridge CFStringRef)kRequestBindingKey, request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UXinNetRequest *)bindedRequest
{
    UXinNetRequest *request=objc_getAssociatedObject(self, (__bridge CFStringRef)kRequestBindingKey);
    return  request;
}
@end
