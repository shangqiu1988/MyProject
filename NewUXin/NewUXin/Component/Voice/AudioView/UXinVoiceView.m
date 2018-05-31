//
//  UXinVoiceView.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/19.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinVoiceView.h"
#import "UXinTalkBackView.h"
#import "UXinRecordView.h"
#import "UXinChangeVoiceView.h"
#import "UIView+Response.h"
@interface UXinVoiceView()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *contentScrollView; // 承载内容的视图

@property (nonatomic,weak) UXinTalkBackView *talkBackView;    // 对讲视图
@property (nonatomic,weak) UXinRecordView *recordView;        // 录音视图
@property (nonatomic,weak) UXinChangeVoiceView *voiceChangeView; // 变声视图

@property (nonatomic,weak) UIView *smallCirle; // 蓝色小圆点
@property (nonatomic,weak) UIView *bottomView; // 下方（变声、对讲、录音）的view

@property (nonatomic,strong) NSArray *bottomsLabels; // bottomView上的标签数组
@property (nonatomic,weak) UILabel *selectLabel;    // 当前选中的label

@end
@implementation UXinVoiceView
{
    CGFloat _labelDistance;
    CGPoint _currentContentOffSize;
}
-(void)dealloc
{
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    // 设置内容滚动视图
    [self contentScrollView];
    // 设置对讲界面
    [self talkBackView];
    // 设置录音界面
    [self recordView];
    // 设置变声界面
    [self voiceChangeView];
    // 设置下方三个标签界面
    [self bottomView];
    // 设置标志小圆点
    [self setupSmallCircleView];
    
    _currentContentOffSize = CGPointMake(self.frame.size.width, 0);
    // 设置对讲标签为选中
    [self setupSelectLabel:self.bottomsLabels[1]];
}
- (void)setupSelectLabel:(UILabel *)label {
    _selectLabel.textColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1.0];;
    label.textColor = [UIColor colorWithRed:83/255.0 green:172/255.0 blue:232/255.0 alpha:1.0];
    _selectLabel = label;
}
#pragma mark - subviews
- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scrollV.pagingEnabled = YES;
        scrollV.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
        scrollV.contentOffset = CGPointMake(self.frame.size.width, 0);
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.delegate = self;
        [self addSubview:scrollV];
        _contentScrollView = scrollV;
    }
    return _contentScrollView;
}
- (UXinTalkBackView *)talkBackView {
    if (_talkBackView == nil) {
        UXinTalkBackView *talkView = [[UXinTalkBackView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.contentScrollView.frame.size.height)];
        [self.contentScrollView addSubview:talkView];
        _talkBackView = talkView;
    }
    return _talkBackView;
}
- (UXinChangeVoiceView *)voiceChangeView {
    if (_voiceChangeView == nil) {
        UXinChangeVoiceView *voiceChangeView = [[UXinChangeVoiceView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.contentScrollView.frame.size.height)];
        [self.contentScrollView addSubview:voiceChangeView];
        _voiceChangeView = voiceChangeView;
    }
    return _voiceChangeView;
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 45, self.frame.size.width, 25)];
        [self addSubview:bottomV];
        //        bottomV.backgroundColor = [UIColor redColor];
        _bottomView = bottomV;
        [self setupBottomViewSubviews];
    }
    return _bottomView;
}
- (void)setupBottomViewSubviews {
    CGFloat margin = 10;
    NSArray *titleArr = @[@"变声",@"对讲",@"录音"];
    
    //    _bottomsLabels = [NSMutableArray array];
    
    UILabel *talkBackLabel = [self labelWithText:titleArr[1]];
    talkBackLabel.center = CGPointMake(self.bottomView.frame.size.width / 2.0, self.bottomView.frame.size.height / 2.0);
    //    talkBackLabel.textColor = kSelectBackGroudColor;
    [self.bottomView addSubview:talkBackLabel];
    
    UILabel *label = [self labelWithText:titleArr[0]];
    label.center = CGPointMake(talkBackLabel.frame.origin.x - margin - label.frame.size.width / 2.0, self.bottomView.frame.size.height / 2.0);
    [self.bottomView addSubview:label];
    
    UILabel *recordLabel = [self labelWithText:titleArr[2]];
    recordLabel.center = CGPointMake(talkBackLabel.frame.origin.x+talkBackLabel.frame.size.width + margin + recordLabel.frame.size.width / 2.0, self.bottomView.frame.size.height / 2.0);
    [self.bottomView addSubview:recordLabel];
    
    _labelDistance = recordLabel.center.x - talkBackLabel.center.x;
    
    self.bottomsLabels = @[label,talkBackLabel,recordLabel];
}
- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.textColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    return label;
}
- (void)setupSmallCircleView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    view.backgroundColor = [UIColor colorWithRed:83/255.0 green:172/255.0 blue:232/255.0 alpha:1.0];
    view.layer.cornerRadius = view.frame.size.width / 2.0;
    view.center = CGPointMake(self.frame.size.width / 2.0, self.bottomView.frame.origin.y - view.frame.size.height / 2.0);
    [self addSubview:view];
    self.smallCirle = view;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollDistance = scrollView.contentOffset.x - _currentContentOffSize.x;
    CGFloat transtionX = scrollDistance / self.contentScrollView.frame.size.width * _labelDistance;
    self.bottomView.transform = CGAffineTransformMakeTranslation(-transtionX, 0);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    [self setupSelectLabel:self.bottomsLabels[index]];
}

#pragma mark - setter
- (void)setState:(VoiceState)state {
    _state = state;
    self.bottomView.hidden = state != VoiceStateDefault;
    self.smallCirle.hidden = state != VoiceStateDefault;
    self.contentScrollView.scrollEnabled = state == VoiceStateDefault;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
