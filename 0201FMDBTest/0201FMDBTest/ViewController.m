//
//  ViewController.m
//  0201FMDBTest
//
//  Created by FengZhen on 16/2/1.
//  Copyright © 2016年 FengZhen. All rights reserved.
//

#import "ViewController.h"
#import "StudentModel.h"
@interface ViewController ()
@property(nonatomic,strong)FMDatabase * database;
@property(nonatomic,strong)NSMutableArray * studentArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openDataBase];
}
-(NSMutableArray *)studentArr{
    if (!_studentArr) {
        _studentArr = [NSMutableArray array];
    }
    return _studentArr;
}
-(void)openDataBase{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dbPath = [path stringByAppendingString:@"student.sqlite"];
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT,stuID text NOT NULL,stuName text NOT NULL,stuAge integer NOT NULL,stuSex text NOT NULL,stuBirth text NOT NULL)"];
        if (result) {
            NSLog(@"建表成功");
        }else{
            NSLog(@"建表失败");
        }
    }
    self.database = db;
}
-(void)insert{
    for (int i = 0; i < 10; i++) {
        NSString * stuID = [NSString stringWithFormat:@"2015%d%d",arc4random_uniform(100),arc4random_uniform(100)];
        NSString * stuName = [NSString stringWithFormat:@"Enzo-%d", arc4random_uniform(100)];
        NSInteger stuAge = arc4random_uniform(30);
        NSString * stuSex;
        if (i % 2 == 0) {
            stuSex = @"男";
        }else{
            stuSex = @"女";
        }
        NSString * stuBirth = [NSString stringWithFormat:@"1993%d%d",arc4random_uniform(12),arc4random_uniform(30)];
        [self.database executeUpdate:@"INSERT INTO t_student (stuID,stuName,stuAge,stuSex,stuBirth) VALUES (?,?,?,?,?);",stuID,stuName,@(stuAge),stuSex,stuBirth?:[NSNull null]];
    }
}

-(void)deleteDatabase{
    [self.database executeUpdate:@"DROP TABLE IF EXISTS t_student"];
    [self.database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT,stuID text NOT NULL,stuName text NOT NULL,stuAge integer NOT NULL,stuSex text NOT NULL,stuBirth text NOT NULL)"];
}
-(void)delete{
    BOOL result = [self.database executeUpdate:@"DELETE FROM t_student WHERE stuSex=?",@"女"];
    if (result) {
        NSLog(@"=====删除成功");
    }else{
        NSLog(@"=====删除失败");
    }
    [self query];
}
-(void)update{
    BOOL result = [self.database executeUpdate:@"UPDATE t_student  SET stuName=? WHERE stuSex=?",@"zhen",@"男"];
    if (result) {
        NSLog(@"=====更新成功");
    }else{
        NSLog(@"=====更新失败");
    }
    [self query];
}
-(void)query{
    
   FMResultSet * resultSet = [self.database executeQueryWithFormat:@"SELECT * FROM t_student"];
//    FMResultSet * resultSet = [_database executeQuery:@"SELECT * FROM t_student"];
    while ([resultSet next]) {
        StudentModel * student = [[StudentModel alloc]initWithStuID:[resultSet stringForColumn:@"stuID"] andStuName:[resultSet stringForColumn:@"stuName"] andStuAge:[resultSet intForColumn:@"stuAge"] andStuSex:[resultSet stringForColumn:@"stuSex"] andStuBirth:[resultSet stringForColumn:@"stuBirth"]];
        [self.studentArr addObject:student];
    }
    //NSLog(@"====%@",self.studentArr);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.studentArr = nil;
    [self deleteDatabase];
    [self insert];
    [self delete];
    //[self update];
    //[self query];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
