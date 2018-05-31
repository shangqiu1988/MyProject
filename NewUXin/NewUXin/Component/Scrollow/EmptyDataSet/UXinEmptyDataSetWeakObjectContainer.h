//
//  UXinEmptyDataSetWeakObjectContainer.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinEmptyDataSetWeakObjectContainer : NSObject
@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end
