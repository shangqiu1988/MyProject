//
//  UXinPhotoBrowserItem.h
//  NewUXin
//
//  Created by tanpeng on 2018/2/11.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinPhotoBrowserItem : NSObject
// 加载图片的url
@property (nonatomic , strong)NSString *urlString;
//imageView的frame
@property (nonatomic , assign)CGRect frame;
//站位图的大小
@property (nonatomic , assign)CGSize placeholdSize;
//占位图片  default is [UIImage imageNamed:@"LBLoading.png"]
@property (nonatomic , strong)UIImage *placeholdImage;
- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame;
- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame placeholdImage:(UIImage *)image;
- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame placeholdSize:(CGSize)size;
- (instancetype)initWithURLString:(NSString *)url frame:(CGRect)frame placeholdImage:(UIImage *)image placeholdSize:(CGSize)size;
@end
