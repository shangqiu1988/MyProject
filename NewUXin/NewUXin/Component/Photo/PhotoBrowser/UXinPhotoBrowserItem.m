//
//  UXinPhotoBrowserItem.m
//  NewUXin
//
//  Created by tanpeng on 2018/2/11.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinPhotoBrowserItem.h"

@implementation UXinPhotoBrowserItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _frame = CGRectZero;
        _placeholdSize = CGSizeZero;
        _urlString = @"";
    }
    return self;
}
- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame {
    UXinPhotoBrowserItem *item  = [self init];
    item.urlString = url;
    item.frame = frame;
    return item;
}

- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame placeholdSize:(CGSize)size {
    UXinPhotoBrowserItem *item = [self initWithURLString:url frame:frame];
    item.placeholdSize = size;
    return item;
}

- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame placeholdImage:(UIImage *)image {
    UXinPhotoBrowserItem *item = [self initWithURLString:url frame:frame];
    item.placeholdImage = image;
    return item;
}

- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame placeholdImage:(UIImage *)image placeholdSize:(CGSize)size  {
    UXinPhotoBrowserItem *item = [self initWithURLString:url frame:frame placeholdImage:image];
    item.placeholdSize = size;
    return item;
}

@end
