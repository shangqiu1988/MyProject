//
//  UXinAlertAction.m
//  NewUXin
//
//  Created by tanpeng on 17/8/26.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinAlertAction.h"

@interface UXinAlertAction()
@property (nullable, nonatomic, readwrite) NSString *title;

@property (nonatomic, readwrite) AlertActionStyle style;

@property (nullable, nonatomic, copy, readwrite) void (^handler)(UXinAlertAction *);

@end
@implementation UXinAlertAction
+(id)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(void (^)(UXinAlertAction * _Nonnull))handler
{
    if(IOS8Later){
        UIAlertActionStyle actionStyle=(NSInteger)style;
        UIAlertAction *action=[UIAlertAction actionWithTitle:title style:actionStyle handler:(void (^ __nullable)(UIAlertAction *))handler];
        return action;
    }else{
        UXinAlertAction *action=[[UXinAlertAction alloc]init];
        action.title=title;
        action.style=style;
        action.handler=handler;
        return action;
    }
}
@end
