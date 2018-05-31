//
//  UXinBaseParser.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/16.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONKit/JSONKit.h>
#import "UXinStatusEntity.h"
typedef  void (^parserFinished)(NSDictionary *result);
typedef  void (^parserFailed)(UXinStatusEntity * status);
typedef  void (^parserModelFinished)(NSArray * models);
typedef void (^parserModelFailed)();
@interface UXinBaseParser : NSObject
{
    dispatch_queue_t parserQueue;
}
-(void)parserWithData:(NSData *)data finished:(parserFinished)finishedBlock failed:(parserFailed)failedBlock ;
-(void)parserWithString:(NSString *)string finished:(parserFinished)finishedBlock failed:(parserFailed)failedBlock;

+(UXinBaseParser *)shareInstance;
@end
