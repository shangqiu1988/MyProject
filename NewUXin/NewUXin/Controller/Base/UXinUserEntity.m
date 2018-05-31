//
//  UXinUserEntity.m
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinUserEntity.h"

@implementation UXinUserEntity

+(NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"userId":@"id",
             @"type":@"user_type",
             @"userName":@"name",
             @"realName":@"real_name",
             @"userSign":@"sign",
             @"headImageUrl":@"header_image_url",
             @"schoolId":@"school_id",
             @"areaId":@"area_id",
             @"gradeId":@"grade_id",
             @"classId":@"class_id",
             @"flagOfUpdating":@"flag_of_updating"
             };
}
-(void)saveUser
{
    
}
@end
