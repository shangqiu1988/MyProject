//
//  UXinNetBatchRequest.m
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinNetBatchRequest.h"

@implementation UXinNetBatchRequest
-(void)dealloc
{
    
}
-(instancetype)init
{
    self=[super init];
    if(!self){
        return nil;
    }
    _failed=NO;
    _finishedCount=0;
    _lock=dispatch_semaphore_create(1);
    _requestArray=[NSMutableArray array];
    _responseArray=[NSMutableArray array];
    return self;
}
-(BOOL)onFinishedOneRequest:(id)request response:(id)responseObject error:(NSError *)error
{
    BOOL isFinished=NO;
    NetLock();
     NSUInteger index = [_requestArray indexOfObject:request];
    if (responseObject) {
        [_responseArray replaceObjectAtIndex:index withObject:responseObject];
    } else {
        _failed = YES;
        if (error) {
            [_responseArray replaceObjectAtIndex:index withObject:error];
        }
    }
    _finishedCount++;
    if(_finishedCount==_requestArray.count){
        if(!_failed){
            Net_SAFE_BLOCK(_batchSuccessBlock,_responseArray);
            Net_SAFE_BLOCK(_batchFinishedBlock,_responseArray,nil);
        }else{
            Net_SAFE_BLOCK(_batchFailureBlock, _responseArray);
            Net_SAFE_BLOCK(_batchFinishedBlock, nil, _responseArray);
        }
        [self cleanCallbackBlocks];
        isFinished = YES;

    }
    NetUnlock();
    return isFinished;
}
-(void)cleanCallbackBlocks
{
    _batchSuccessBlock=nil;
    _batchFailureBlock=nil;
    _batchFinishedBlock=nil;
}
@end
