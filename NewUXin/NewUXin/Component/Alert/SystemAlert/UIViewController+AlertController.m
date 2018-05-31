//
//  UIViewController+AlertController.m
//  NewUXin
//
//  Created by tanpeng on 17/8/26.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIViewController+AlertController.h"
#import "UXinAlertController.h"
@implementation UIViewController (AlertController)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        
        SEL swizzlingSelector = @selector(alert_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSelector);
        
        BOOL didAddMethod = class_addMethod(class, swizzlingSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzlingSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzlingMethod);
        }
    });

}
- (void)alert_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    if([viewControllerToPresent isKindOfClass:[UXinAlertController class]]){
        UXinAlertController *alert=(UXinAlertController *)viewControllerToPresent;
        if(IOS8Later){
            ((UIAlertController *)alert.alertView).view.tintColor = alert.tintColor;
            [self alert_presentViewController:((UXinAlertController *)viewControllerToPresent).alertView animated:flag completion:completion];
        }else{
            if ([alert.alertView isKindOfClass:[UIAlertView class]]) {
                [alert.alertView show];
            }else if ([alert.alertView isKindOfClass:[UIActionSheet class]]) {
                [alert.alertView showInView:self.view];
            }

        }
    }else{
        [self alert_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}
@end
