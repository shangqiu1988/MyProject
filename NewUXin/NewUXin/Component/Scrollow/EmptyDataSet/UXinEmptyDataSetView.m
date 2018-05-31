//
//  UXinEmptyDataSetView.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinEmptyDataSetView.h"

@implementation UXinEmptyDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;
- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
