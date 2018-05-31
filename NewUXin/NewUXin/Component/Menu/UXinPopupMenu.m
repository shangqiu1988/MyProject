//
//  UXinPopupMenu.m
//  NewUXin
//
//  Created by tanpeng on 17/8/14.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinPopupMenu.h"
#import "UXinPopupMenuCell.h"
@interface UXinPopupMenu()
{
    
}
@property(nonatomic,assign) CGFloat itemWidth;
@end
@implementation UXinPopupMenu
-(void)dealloc
{
    _selectedBlock=nil;
    _beginDismissBlock=nil;
    _didDismissBlock=nil;
}
#pragma mark-init
- (instancetype)initWithTitles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                      delegate:(id<PopupMenuDelegate>)delegate
{
    if(self=[super init]){
               if(delegate){
            self.delegate=delegate;
               }
                   _titles=titles;
                   _icons=icons;
                   _itemWidth=itemWidth;
                   [self setUp];
        
    }
    return self;
}
-(instancetype)initWithTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth selectedHandle:(popUpMenuDidSelected)selectedHandle
           beginDismisshandle:(popUpMenuBeganDismiss)beginDismisshandle
             didDismissHandle:(popUpMenuDidDismiss)didDismissHandle
{
    if(self=[super init]){
        _titles=titles;
        _icons=icons;
        _itemWidth=itemWidth;
        _selectedBlock=[selectedHandle copy];
        _beginDismissBlock=[beginDismisshandle copy];
        _didDismissBlock=[didDismissHandle copy];
        [self setUp];
    }
    return self;
}
-(void)setUp
{
    kArrowWidth=15;
    kArrowHeight=10;
    kButtonHeight=44;
    _cornerRadius=5.0;
    
    _dismissOnSelected=YES;
    _fontSize=15.0;
    _textColor=[UIColor blackColor];
    _offset=0.0;
    _type=PopupMenuTypeDefault;
    _contentColor=[UIColor whiteColor];
    _separatorColor=[UIColor lightGrayColor];
    CGRect frame=self.frame;
    frame.size.width=_itemWidth;
    frame.size.height=(_titles.count>5 ? 5*kButtonHeight :_titles.count*kButtonHeight)+2*kArrowHeight;
    self.frame=frame;
    kArrowPosition=0.5*self.frame.size.width-0.5*kArrowWidth;
    self.alpha=0;
    self.layer.shadowOpacity=0.5;
    self.layer.shadowOffset=CGSizeMake(0, 0);
    self.layer.shadowRadius=2.0;
    _mainView=[[UIView alloc]initWithFrame:self.bounds];
    _mainView.layer.cornerRadius=_cornerRadius;
    _mainView.layer.masksToBounds=YES;
    _contentView = [[UITableView alloc] initWithFrame: _mainView.bounds style:UITableViewStylePlain];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delegate = self;
    _contentView.dataSource= self;
    _contentView.bounces = _titles.count > 5 ? YES : NO;
    _contentView.tableFooterView = [UIView new];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    frame=_contentView.frame;
    frame.size.height-=2*kArrowHeight;
    _contentView.frame=frame;
    CGPoint centerPoint=_mainView.center;
    centerPoint.y=_mainView.center.y;
    _contentView.center=centerPoint;
    [_mainView addSubview:_contentView];
    [self addSubview:_mainView];
    _bgView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
    [_bgView addGestureRecognizer: tap];
}
#pragma mark-private
- (void)showAtPoint:(CGPoint)point
{
    _mainView.layer.mask = [self getMaskLayerWithPoint:point];
    [self show];

    }
- (void)showRelyOnView:(UIView *)view
{
    CGRect absoluteRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    _mainView.layer.mask=[self getMaskLayerWithPoint:relyPoint];
    CGRect frame=self.frame;
    if(frame.origin.y<_anchorPoint.y){
        frame.origin.y-=absoluteRect.size.height;
    }
    [self show];
}
-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UXinPopupMenuCell *cell=[self getLastVisibleCell];
    cell.isShowSeparator=NO;
    self.layer.affineTransform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform=CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha=1;
        _bgView.alpha=1;
    }];
}
- (void)setAnimationAnchorPoint:(CGPoint)point
{
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;

}
-(void)determineAnchorPoint
{
    CGPoint aPoint=CGPointMake(0.5, 0.5);
    if(CGRectGetMaxY(self.frame)>[UIScreen mainScreen].bounds.size.height){
        aPoint=CGPointMake(fabs(kArrowPosition)/self.frame.size.width, 1);
    }else{
        aPoint=CGPointMake(fabs(kArrowPosition)/self.frame.size.width, 0);
    }
    [self setAnimationAnchorPoint:aPoint];
}
-(CAShapeLayer *)getMaskLayerWithPoint:(CGPoint)point
{
    [self setArrowPointingWhere:point];
    CAShapeLayer *layer=[self drawMaskLayer];
    [self determineAnchorPoint];
     CGRect frame=self.frame;
    if(CGRectGetMaxY(self.frame)>[UIScreen mainScreen].bounds.size.height){
        kArrowPosition=self.frame.size.width-kArrowPosition-kArrowWidth;
        layer=[self drawMaskLayer];
        layer.affineTransform= CGAffineTransformMakeRotation(M_PI);
       
        frame.origin.y=_anchorPoint.y-frame.size.height;
        self.frame=frame;
    }
    frame.origin.y+=frame.origin.y>=_anchorPoint.y ? _offset :-_offset;
    return layer;
    
}
- (void)setArrowPointingWhere: (CGPoint)anchorPoint
{
    _anchorPoint=anchorPoint;
    CGRect frame=self.frame;
    frame.origin.x=anchorPoint.x-kArrowPosition-0.5*kArrowWidth;
    frame.origin.y=anchorPoint.y;
    CGFloat maxX=CGRectGetMaxX(self.frame);
    CGFloat minX=CGRectGetMaxX(self.frame);
    if(maxX>[UIScreen mainScreen].bounds.size.width-10){
        frame.origin.x=[UIScreen mainScreen].bounds.size.width-10-frame.size.width;
    }else if (minX<10){
        frame.size.width=10;
    }
    self.frame=frame;
    maxX=CGRectGetMaxX(self.frame);
    minX=CGRectGetMaxX(self.frame);
    if((anchorPoint.x<=maxX-_cornerRadius)&&(anchorPoint.x>=minX+_cornerRadius)){
        kArrowPosition=anchorPoint.x=minX-0.5*kArrowWidth;
    }else if (anchorPoint.x<minX+_cornerRadius){
        kArrowPosition=_cornerRadius;
    }else{
        kArrowPosition=self.frame.size.width-_cornerRadius-kArrowWidth;
    }
}
-(CAShapeLayer *)drawMaskLayer
{
    CAShapeLayer *maskLayer=[CAShapeLayer layer];
    maskLayer.frame=_mainView.bounds;
    CGRect frame=self.frame;
    CGPoint topRightArcCenter = CGPointMake(frame.size.width-_cornerRadius, kArrowHeight+_cornerRadius);
    CGPoint topLeftArcCenter = CGPointMake(_cornerRadius, kArrowHeight+_cornerRadius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width-_cornerRadius, self.height - kArrowHeight - _cornerRadius);
    CGPoint bottomLeftArcCenter = CGPointMake(_cornerRadius, frame.size.height - kArrowHeight - _cornerRadius);
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, kArrowHeight+_cornerRadius)];
    [path addLineToPoint:CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter:bottomLeftArcCenter radius:_cornerRadius startAngle:-M_PI  endAngle:-M_PI-M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height-kArrowHeight)];
    [path addArcWithCenter:bottomRightArcCenter radius:_cornerRadius startAngle:-M_PI-M_PI_2 endAngle:-M_PI*2 clockwise:NO];
    [path addLineToPoint:CGPointMake(frame.size.width, kArrowHeight+_cornerRadius)];
    [path addArcWithCenter:topRightArcCenter radius:_cornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(kArrowPosition+kArrowWidth, kArrowHeight)];
    [path addLineToPoint:CGPointMake(kArrowPosition+0.5*kArrowWidth, 0)];
    [path addLineToPoint:CGPointMake(kArrowPosition, kArrowHeight)];
    [path addLineToPoint:CGPointMake(_cornerRadius, kArrowHeight)];
    [path addArcWithCenter:topLeftArcCenter radius:_cornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
    [path closePath];
    maskLayer.path=path.CGPath;
    return maskLayer;
    
}
#pragma mark-setter

-(void)setType:(PopupMenuType)type
{
    _type = type;
    switch (type) {
        case PopupMenuTypeDark:
        {
            _textColor = [UIColor lightGrayColor];
            _contentColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.29 alpha:1];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
            
        default:
        {
            _textColor = [UIColor blackColor];
            _contentColor = [UIColor whiteColor];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
    }
    _mainView.backgroundColor = _contentColor;
    [_contentView reloadData];

}
-(void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [_contentView reloadData];


}
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [_contentView reloadData];
}
-(void)setDismissOnSelected:(BOOL)dismissOnSelected
{
    _dismissOnSelected=dismissOnSelected;
    if(!dismissOnSelected){
        for(UIGestureRecognizer *gr in _bgView.gestureRecognizers)
        {
            [_bgView removeGestureRecognizer:gr];
        }
    }
}
-(void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    if (!isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }

}
-(void)setOffset:(CGFloat)offset
{
    _offset = offset;
    if (offset < 0) {
        offset = 0.0;
    }
    CGRect frame=self.frame;
    frame.origin.y+=frame.origin.y>_anchorPoint.y ? offset :-offset;
}
-(void)setCornerRadius:(CGFloat)cornerRadius
{
    if(_cornerRadius==cornerRadius){
        return;
    }
    _cornerRadius=cornerRadius;
    if(self.frame.origin.y<_anchorPoint.y){
        _mainView.layer.mask.affineTransform=CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark-消失
-(void)dismiss
{
    if(self.delegate&&[self respondsToSelector:@selector(popUpMenyBeganDismiss)]){
        [self.delegate popUpMenyBeganDismiss];
    }else{
        if(_beginDismissBlock){
            _beginDismissBlock();
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform=CGAffineTransformMakeScale(0.1,  0.1);
        self.alpha=0;
        _bgView.alpha=0;
    } completion:^(BOOL finished) {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(popUpMenuDidDismiss)]){
            [self.delegate popUpMenuDidDismiss];
        }else{
            if(_didDismissBlock){
                _didDismissBlock();
            }
        }
        self.delegate=nil;
        _selectedBlock=nil;
        _beginDismissBlock=nil;
        _didDismissBlock=nil;
        [self removeFromSuperview];
        [_bgView removeFromSuperview];
    }];

}
#pragma mark-class  init
+(instancetype)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth delegate:(id<PopupMenuDelegate>)delegate
{
    UXinPopupMenu *popUpMenu=[[UXinPopupMenu alloc]initWithTitles:titles icons:icons menuWidth:itemWidth delegate:delegate];
    [popUpMenu showAtPoint:point];
    return popUpMenu;
}
+(instancetype)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth delegate:(id<PopupMenuDelegate>)delegate
{
    UXinPopupMenu *popUpMenu=[[UXinPopupMenu alloc]initWithTitles:titles icons:icons menuWidth:itemWidth delegate:delegate];
    [popUpMenu showRelyOnView:view];
    return popUpMenu;

}
+(instancetype)showAtPoint:(CGPoint)point
                    titles:(NSArray *)titles
                     icons:(NSArray *)icons
                 menuWidth:(CGFloat)itemWidth
            selectedHandle:(popUpMenuDidSelected)selectedHandle
        beginDismisshandle:(popUpMenuBeganDismiss)beginDismisshandle
          didDismissHandle:(popUpMenuDidDismiss)didDismissHandle
{
    UXinPopupMenu *popUpMenu=[[UXinPopupMenu alloc]initWithTitles:titles icons:icons menuWidth:itemWidth selectedHandle:selectedHandle beginDismisshandle:beginDismisshandle didDismissHandle:didDismissHandle];
    [popUpMenu showAtPoint:point];
    return popUpMenu;
}
+ (instancetype)showRelyOnView:(UIView *)view
                        titles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                selectedHandle:(popUpMenuDidSelected)selectedHandle
            beginDismisshandle:(popUpMenuBeganDismiss)beginDismisshandle
              didDismissHandle:(popUpMenuDidDismiss)didDismissHandle
{
   UXinPopupMenu *popUpMenu= [[UXinPopupMenu alloc]initWithTitles:titles icons:icons menuWidth:itemWidth selectedHandle:selectedHandle beginDismisshandle:beginDismisshandle didDismissHandle:didDismissHandle];
    [popUpMenu showRelyOnView:view];
    return popUpMenu;
    
}
#pragma mark-UITableViewDelegate &dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString * identifier = @"PopupMenu";
    UXinPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UXinPopupMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    cell.textLabel.text = _titles[indexPath.row];
    cell.separatorColor = _separatorColor;
    if (_icons.count >= indexPath.row + 1) {
        if ([_icons[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.imageView.image = [UIImage imageNamed:_icons[indexPath.row]];
        }else if ([_icons[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _icons[indexPath.row];
        }else {
            cell.imageView.image = nil;
        }
    }else {
        cell.imageView.image = nil;
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnSelected) [self dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popUpMenuDidSelectedAtIndex:popUpMenu:)]) {
        
        [self.delegate popUpMenuDidSelectedAtIndex:indexPath.row popUpMenu:self];
    }else{
        if(_selectedBlock){
            _selectedBlock(indexPath.row);
        }
    }

}
#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UXinPopupMenuCell *cell=[self getLastVisibleCell];
    cell.isShowSeparator=YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UXinPopupMenuCell *cell=[self getLastVisibleCell];
    cell.isShowSeparator=NO;
}
- (UXinPopupMenuCell *)getLastVisibleCell
{
    NSArray<NSIndexPath *> *indexPaths=[_contentView indexPathsForVisibleRows];
    indexPaths=[indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath*  _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
        return  obj1.row<obj2.row;
    }];
    NSIndexPath *indexPath=indexPaths.firstObject;
    return [_contentView cellForRowAtIndexPath:indexPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
