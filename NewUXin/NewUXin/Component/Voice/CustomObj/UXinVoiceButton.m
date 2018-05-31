//
//  UXinVoiceButton.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/19.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinVoiceButton.h"

@implementation UXinVoiceButton
+ (instancetype)buttonWithBackImageNor:(NSString *)backImageNor backImageSelected:(NSString *)backImageSelected imageNor:(NSString *)imageNor imageSelected:(NSString *)imageSelected frame:(CGRect)frame isMicPhone:(BOOL)isMicPhone{
    
    UIImage *normalImage = [UIImage imageNamed:backImageNor]; //aio_voice_button_press
    UIImage *selectedImage = [UIImage imageNamed:backImageSelected];
    UXinVoiceButton *btn = [UXinVoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    frame.size =  normalImage.size;;
    btn.frame = frame;
    
    if (isMicPhone) {
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
    }
    btn.normalImage = normalImage;
    btn.selectedImage = selectedImage;
    [btn setImage:[UIImage imageNamed:imageNor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    btn.imageView.backgroundColor = [UIColor clearColor];
    if (!isMicPhone) {
        btn.backgroudLayer.contents = (__bridge id _Nullable)(normalImage.CGImage);
    }
    
    return btn;
}
-(CALayer *)backgroudLayer
{
    if(_backgroudLayer == nil) {
        CALayer *layer=[[CALayer alloc] init];
        layer.frame = self.bounds;
        [self.layer insertSublayer:layer atIndex:0];
        _backgroudLayer = layer;
    }
     return _backgroudLayer;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    UIImage *image = selected ? self.selectedImage : self.normalImage;
    self.backgroudLayer.contents = (__bridge id _Nullable)(image.CGImage);
    [CATransaction commit];
}
- (BOOL)isHighlighted {
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
