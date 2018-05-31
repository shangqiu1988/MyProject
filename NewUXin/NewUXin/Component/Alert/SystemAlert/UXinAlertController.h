//
//  UXinAlertController.h
//  NewUXin
//
//  Created by tanpeng on 17/8/26.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinAlertAction.h"
typedef NS_ENUM(NSInteger, AlertControllerStyle) {
    AlertControllerStyleActionSheet = 0,
    AlertControllerStyleAlert
};

@interface UXinAlertController : UIViewController
+ (nullable instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(AlertControllerStyle)preferredStyle;

- (void)addAction:(UXinAlertAction * _Nonnull)action;

@property (nonnull, nonatomic, readonly) NSArray<UXinAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *message;

@property (nullable, nonatomic, strong) UIColor *tintColor;
@property(nonatomic,strong) id alertView;

@property (nonatomic, readonly) AlertControllerStyle preferredStyle;

@end
