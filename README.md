# FMDB


使用Cocoapods 导入FMDB或者下载导入工程

FMDB 有三个主要的类

（1）FMDatabase

	一个FMDatabase对象就代表一个单独的sqlite数据库
			
	用来执行查询语句
	
	 (2) FMResultSet
	 
	使用FMDatabase查询结果后的结果集
			
	 (3) FMDatabaseQueue	
	 
	用于在多线程中执行查询或更新，它是线程安全的
			
			
	对数据库的操作包括增、删、改、查，其中只有查的时候所调用的方法与其它三个操作不一样，
	
查用

self.database executeQuery:<#(NSString *), ...#>

self.database executeQueryWithFormat:<#(NSString *), ...#>

增删改用

self.database executeUpdate:<#(NSString *), ...#>

self.database executeUpdateWithFormat:<#(NSString *), ...#>

#打开数据库

通过指定的sqlite数据库的地址来创建FMDatabase对象
	
NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
NSString * dbPath = [path stringByAppendingString:@"student.sqlite"];

FMDatabase * db = [FMDatabase databaseWithPath:dbPath];

如果数据库打开成功则创建想要的表

integer 为整型

text	为NSString字符串

PRIMARY KEY 为主键

AUTOINCREMENT 为自增长

NOT NULL 指定该列的值不能为空

#打开数据库并创建表

if ([db open]) {

        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT,stuID text NOT NULL,stuName text NOT NULL,stuAge integer NOT NULL,stuSex text NOT NULL,stuBirth text NOT NULL)"];
        
        if (result) {
        
            NSLog(@"建表成功");
            
        }else{
        
            NSLog(@"建表失败");
            
        }
        
    }
    
#插入数据

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

在插入数据时要注意，如果所要插入的值为不确定的，则用？代替，在后边跟值的名称，如果要插入的值为非NSString型，则需要转换为NSString进行存储，否则程序会崩溃

#更新数据

-(void)update{

    BOOL result = [self.database executeUpdate:@"UPDATE t_student  SET stuName=? WHERE stuSex=?",@"zhen",@"男"];
    
    if (result) {
    
        NSLog(@"=====更新成功");
        
    }else{
    
        NSLog(@"=====更新失败");
        
    }
    
}

sql语句

@"UPDATE t_student SET stuName=?",@"zhen"

@"UPDATE t_student  SET stuName=? WHERE stuSex=?",@"zhen",@"男"

＃查询数据

-(void)query{

   FMResultSet * resultSet = [self.database executeQueryWithFormat:@"SELECT * FROM t_student"];
   
//FMResultSet * resultSet = [_database executeQuery:@"SELECT * FROM t_student"];

    while ([resultSet next]) {
    
        StudentModel * student = [[StudentModel alloc]initWithStuID:[resultSet stringForColumn:@"stuID"] andStuName:[resultSet stringForColumn:@"stuName"] andStuAge:[resultSet intForColumn:@"stuAge"] andStuSex:[resultSet stringForColumn:@"stuSex"] andStuBirth:[resultSet stringForColumn:@"stuBirth"]];
        
        [self.studentArr addObject:student];
        
    }
    
}

sql语句

@”SELECT * FROM t_student”

@”SELECT * FROM t_student WHERE stuName = ?”,@”Enzo”

#删除数据

-(void)delete{

    BOOL result = [self.database executeUpdate:@"DELETE FROM t_student WHERE stuSex=?",@"女"];
    
    if (result) {
    
        NSLog(@"=====删除成功");
        
    }else{
    
        NSLog(@"=====删除失败");
        
    } 
    
}

sql语句

@"DELETE FROM t_student"(删除表的所有数据)

@"DELETE FROM t_student WHERE stuSex=?",@"女"(按条件删除)

#删除表格

-(void)deleteDatabase{

    [self.database executeUpdate:@"DROP TABLE IF EXISTS t_student"];
    
}

当表不再使用时使用drop删除

如果只是想要删除表中的数据则用delete

