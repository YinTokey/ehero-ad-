//
//  JKDataBase.m
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//
// github:https://github.com/Joker-King/JKDBModel

#import <objc/runtime.h>

#import "JKDBHelper.h"
#import "JKDBModel.h"

@interface JKDBHelper ()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end

@implementation JKDBHelper

static JKDBHelper *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance;
}

+ (NSString *)dbPathWithDirectoryName:(NSString *)directoryName
{
 //   NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (directoryName == nil || directoryName.length == 0) {
        cachePath = [cachePath stringByAppendingPathComponent:@"eHero_database"];
    } else {
        cachePath = [cachePath stringByAppendingPathComponent:directoryName];
    }
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:cachePath isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [cachePath stringByAppendingPathComponent:@"ehero.sqlite"];
    return dbpath;
}

+ (NSString *)dbPath
{
    return [self dbPathWithDirectoryName:nil];
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName
{
    if (_instance.dbQueue) {
        _instance.dbQueue = nil;
    }
    _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:[JKDBHelper dbPathWithDirectoryName:directoryName]];
    
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);
    
    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            if (class_getSuperclass(classes[i]) == [JKDBModel class]){
                id class = classes[i];
                [class performSelector:@selector(createTable) withObject:nil];
            }
        }
        free(classes);
    }
    
    return YES;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [JKDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [JKDBHelper shareInstance];
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}
#endif

@end