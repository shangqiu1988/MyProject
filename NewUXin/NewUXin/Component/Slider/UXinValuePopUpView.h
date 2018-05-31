//
//  UXinValuePopUpView.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/9.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UXinValuePopUpViewDelegate <NSObject>
- (CGFloat)currentValueOffset; //expects value in the range 0.0 - 1.0
- (void)colorAnimationDidStart;
- (void)popUpViewDidHide;
@end
@interface UXinValuePopUpView : UIView<CAAnimationDelegate>
@property (weak, nonatomic) id <UXinValuePopUpViewDelegate> delegate;
@property (nonatomic) CGFloat cornerRadius;

- (UIColor *)color;
- (void)setColor:(UIColor *)color;
- (UIColor *)opaqueColor;

- (void)setTextColor:(UIColor *)textColor;
- (void)setFont:(UIFont *)font;
- (void)setString:(NSString *)string;

- (void)setAnimatedColors:(NSArray *)animatedColors withKeyTimes:(NSArray *)keyTimes;

- (void)setAnimationOffset:(CGFloat)offset;
- (void)setArrowCenterOffset:(CGFloat)offset;

- (CGSize)popUpSizeForString:(NSString *)string;

- (void)show;
- (void)hide;

@end
