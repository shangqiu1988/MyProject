//
//  UXinVoiceButton.h
//  NewUXin
//
//  Created by tanpeng on 2017/10/19.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UXinVoiceButton : UIButton
@property(nonatomic,weak) CALayer *backgroudLayer;
@property(nonatomic,strong) UIImage *normalImage;
@property(nonatomic,strong) UIImage *selectedImage;
+ (instancetype)buttonWithBackImageNor:(NSString *)backImageNor backImageSelected:(NSString *)backImageSelected imageNor:(NSString *)imageNor imageSelected:(NSString *)imageSelected frame:(CGRect)frame isMicPhone:(BOOL)isMicPhone;
@end
