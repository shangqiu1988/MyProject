//
//  UXinDBHelper.h
//  NewUXin
//
//  Created by tanpeng on 2017/10/24.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
@interface UXinDBHelper : NSObject
@property(nonatomic,strong,readonly) FMDatabaseQueue *dbQueue;
@property(nonatomic,copy) NSString *dbPath;
+(UXinDBHelper *)shareInstance;

-(BOOL)changeDBWithDirectoryName:(NSString *)directoryName;
-(void)setDefaultDBPath:(NSString *)dbPath;
@end
