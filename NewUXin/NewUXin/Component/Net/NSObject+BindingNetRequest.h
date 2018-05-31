//
//  NSObject+BindingNetRequest.h
//  NewUXin
//
//  Created by tanpeng on 17/8/8.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinNetRequest.h"
@interface NSObject (BindingNetRequest)
-(void)bindingRequest:(UXinNetRequest *)request;
-(UXinNetRequest *)bindedRequest;
@end
