//
//  UXinAlertAction.h
//  NewUXin
//
//  Created by tanpeng on 17/8/26.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)
typedef NS_ENUM(NSInteger, AlertActionStyle) {
    AlertActionStyleDefault = 0,
    AlertActionStyleCancel,
    AlertActionStyleDestructive
};


@interface UXinAlertAction : NSObject
@property (nullable, nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) AlertActionStyle style;

@property (nonatomic, assign) BOOL enabled;

@property (nullable, nonatomic, copy ,readonly) void(^handler)(UXinAlertAction *_Nonnull);

+ (nullable id)actionWithTitle:(nullable NSString *)title style:(AlertActionStyle)style handler:(void (^ __nullable)( UXinAlertAction * _Nonnull action))handler;

@end
