//
//  UXinBaseParser.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/16.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinBaseParser.h"

@implementation UXinBaseParser

static UXinBaseParser *instance=nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [UXinBaseParser shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [UXinBaseParser shareInstance];
}

+(UXinBaseParser *)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init] ;
    }) ;
    
    return instance;
}

-(instancetype)init
{
    self=[super init];
    if(self){
        parserQueue = dispatch_queue_create("com.parser", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
-(void)parserWithData:(NSData *)data finished:(parserFinished)finishedBlock failed:(parserFailed)failedBlock
{
    
}
-(void)parserWithString:(NSString *)string finished:(parserFinished)finishedBlock failed:(parserFailed)failedBlock
{
    
}
@end
