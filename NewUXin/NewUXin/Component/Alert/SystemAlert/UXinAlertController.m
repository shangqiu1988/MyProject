//
//  UXinAlertController.m
//  NewUXin
//
//  Created by tanpeng on 17/8/26.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinAlertController.h"

@interface UXinAlertController()<UIAlertViewDelegate,UIActionSheetDelegate>
@property(nonatomic,readwrite) NSMutableArray<UXinAlertAction *> *mutableActions;
@property(nonatomic,readwrite) AlertControllerStyle preferredStyle;

@end
@implementation UXinAlertController
-(instancetype)init
{
    self=[super init];
    if(self){
        if(IOS8Later){
            _alertView=[[UIAlertController alloc]init];
        }else{
            _alertView=[[UIAlertView alloc]init];
            _mutableActions=[[NSMutableArray alloc]init];
            _preferredStyle=AlertControllerStyleAlert;
            ((UIAlertView *)_alertView).delegate=self;
        }
    }
    return self;
}
+(instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AlertControllerStyle)preferredStyle
{
    UXinAlertController *alertController=[[UXinAlertController alloc]init];
    if(IOS8Later){
        alertController.alertView=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:(NSInteger)preferredStyle];
                                   
    }else{
        switch (preferredStyle) {
            case AlertControllerStyleAlert:
            {
                
                alertController.alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:alertController cancelButtonTitle:nil otherButtonTitles:nil, nil];
            }
                break;
            case AlertControllerStyleActionSheet:
            {
                alertController.alertView = [[UIActionSheet alloc] initWithTitle:title
                                                                        delegate:alertController
                                                               cancelButtonTitle:nil
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
            }
                
                break;
            default:
                
                break;
        }
    }
    return alertController;
}
-(void)addAction:(UXinAlertAction *)action
{
    if(IOS8Later){
        [self.alertView addAction:(UIAlertAction *)action];
    }else{
        [self.mutableActions addObject:action];
        NSInteger actionIndex=[self.alertView addButtonWithTitle:action.title];
        switch (action.style) {
            case AlertActionStyleCancel:{
                [self.alertView setCancelButtonIndex:actionIndex];
            }
                break;
            case AlertActionStyleDefault:{
                
            }
                break;
            case AlertActionStyleDestructive:{
                if ([self.alertView isKindOfClass:[UIActionSheet class]]) {
                    [self.alertView setDestructiveButtonIndex:actionIndex];
                }
            }
                break;
            default:
                break;
        }

    }
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    UXinAlertAction *action = self.mutableActions[buttonIndex];
     __weak __typeof(UXinAlertAction *) weakAction = self.mutableActions[buttonIndex];
    if (action.handler) {
        action.handler(weakAction);
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    __weak __typeof(UXinAlertAction *) weakAction = self.mutableActions[buttonIndex];
    if (self.mutableActions[buttonIndex].handler) {
        self.mutableActions[buttonIndex].handler(weakAction);
    }
}

#pragma Mmark - getter and setter
-(NSString *)title{
    return [self.alertView title];
}

-(void)setTitle:(NSString *)title{
    [self.alertView setTitle:title];
}
-(NSString *)message{
    return [self.alertView message];
}
-(void)setMessage:(NSString *)message{
    [self.alertView setMessage:message];
}

@end
