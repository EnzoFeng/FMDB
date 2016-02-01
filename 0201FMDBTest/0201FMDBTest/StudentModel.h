//
//  StudentModel.h
//  0201FMDBTest
//
//  Created by FengZhen on 16/2/1.
//  Copyright © 2016年 FengZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

@property(nonatomic,strong)NSString * stuID;
@property(nonatomic,strong)NSString * stuName;
@property(nonatomic,assign)NSInteger  stuAge;
@property(nonatomic,strong)NSString * stuSex;
@property(nonatomic,strong)NSString * stuBirth;

-(instancetype)initWithStuID:(NSString *)stuID andStuName:(NSString *)stuName andStuAge:(NSInteger)stuAge andStuSex:(NSString *)stuSex andStuBirth:(NSString *)stuBirth;

@end
