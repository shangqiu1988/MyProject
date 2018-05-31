//
//  UXinNetChainRequest.m
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinNetChainRequest.h"
@interface UXinNetChainRequest ()
@property (nonatomic, strong, readwrite) UXinNetRequest *runningRequest;

@property (nonatomic, strong) NSMutableArray<BCNextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray *responseArray;

@property (nonatomic, copy) BCSuccessBlock chainSuccessBlock;
@property (nonatomic, copy) BCFailureBlock chainFailureBlock;
@property (nonatomic, copy) BCFinishedBlock chainFinishedBlock;
@end
@implementation UXinNetChainRequest
-(void)dealloc
{
    
}
-(instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _chainIndex = 0;
    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];
    
    
    return self;

}
-(UXinNetChainRequest *)onFirst:(RequestConfigBlock)firstBlock
{
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-onNext:` method");
    _runningRequest=[UXinNetRequest request];
    firstBlock(_runningRequest);
    [_responseArray addObject:[NSNull null]];
    return self;
}
-(UXinNetChainRequest *)onNext:(BCNextBlock)nextBlock
{
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    [_responseArray addObject:[NSNull null]];
    return self;

}
- (BOOL)onFinishedOneRequest:(UXinNetRequest *)request response:(id)responseObject error:(NSError *)error {
    BOOL isFinished = NO;
    if (responseObject) {
        [_responseArray replaceObjectAtIndex:_chainIndex withObject:responseObject];
        if (_chainIndex < _nextBlockArray.count) {
            _runningRequest = [UXinNetRequest request];
            BCNextBlock nextBlock = _nextBlockArray[_chainIndex];
            BOOL isSent = YES;
            nextBlock(_runningRequest, responseObject, &isSent);
            if (!isSent) {
                Net_SAFE_BLOCK(_chainFailureBlock, _responseArray);
                Net_SAFE_BLOCK(_chainFinishedBlock, nil, _responseArray);
                [self cleanCallbackBlocks];
                isFinished = YES;
            }
        } else {
            Net_SAFE_BLOCK(_chainSuccessBlock, _responseArray);
            Net_SAFE_BLOCK(_chainFinishedBlock, _responseArray, nil);
            [self cleanCallbackBlocks];
            isFinished = YES;
        }
    } else {
        if (error) {
            [_responseArray replaceObjectAtIndex:_chainIndex withObject:error];
        }
        Net_SAFE_BLOCK(_chainFailureBlock, _responseArray);
        Net_SAFE_BLOCK(_chainFinishedBlock, nil, _responseArray);
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    _chainIndex++;
    return isFinished;
}


- (void)cleanCallbackBlocks {
    _runningRequest = nil;
    _chainSuccessBlock = nil;
    _chainFailureBlock = nil;
    _chainFinishedBlock = nil;
    [_nextBlockArray removeAllObjects];
}

@end
