//
//  StudentModel.m
//  0201FMDBTest
//
//  Created by FengZhen on 16/2/1.
//  Copyright © 2016年 FengZhen. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

-(instancetype)initWithStuID:(NSString *)stuID andStuName:(NSString *)stuName andStuAge:(NSInteger)stuAge andStuSex:(NSString *)stuSex andStuBirth:(NSString *)stuBirth{
    self = [super init];
    if (self) {
        self.stuID = stuID;
        self.stuName = stuName;
        self.stuAge = stuAge;
        self.stuSex = stuSex;
        self.stuBirth = stuBirth;
    }
    return self;
}

@end
