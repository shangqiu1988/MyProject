//
//  UXinDBHelper.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/24.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinDBHelper.h"
#import "UXinDBModel.h"
#import <objc/runtime.h>
@interface UXinDBHelper()
@property(nonatomic,strong) FMDatabaseQueue *dbQueue;
@end


@implementation UXinDBHelper

static UXinDBHelper *instance=nil;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [UXinDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [UXinDBHelper shareInstance];
}
-(void)setDefaultDBPath:(NSString *)dbPath
{
    _dbPath=nil;
    _dbPath=[dbPath copy];
}
-(FMDatabaseQueue *)dbQueue
{
    if(_dbQueue==nil){
        _dbQueue=[[FMDatabaseQueue alloc] initWithPath:_dbPath];
    }
   
    
    return _dbQueue;
}
-(instancetype)init
{
    self=[super init];
    if(self){
       
    }
    return self;
}
+(UXinDBHelper *)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init] ;
       
     
        
    }) ;
    
    return instance;
}

-(BOOL)changeDBWithDirectoryName:(NSString *)directoryName
{
    if(_dbQueue){
        [_dbQueue close];
        _dbQueue=nil;
    }
     _dbQueue=[[FMDatabaseQueue alloc] initWithPath:_dbPath];
    Class *classes=NULL;
    int numClasses=objc_getClassList(NULL, 0);
    if(numClasses > 0){
        classes=(Class *)malloc(sizeof(Class)*numClasses);
        numClasses =objc_getClassList(classes, numClasses);
        for(NSInteger i=0;i<numClasses;i++)
        {
            if(class_getSuperclass(classes[i]) == [UXinDBModel class]){
                id class =classes[i];
                [class performSelector:@selector(createTable) withObject:nil afterDelay:0.0];
            }
    }
        free(classes);
    }
    return YES;
        
}
@end
