

#import "NSArray+Log.h"

@implementation NSArray (Log)


/*
 *  类别重写NSArray的类别方法
 *  如果是字典类别遍历
 */
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:@"(\n"];
    
    /*block快速遍历*/
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stringM appendFormat:@"\t%@,\n",obj];
    }];
    [stringM appendString:@")\n"];
    
    return stringM;
}

@end

@implementation NSDictionary (Log)
/*
 *  如果是字典类别遍历
 *  重写的字典的方法
 */
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:@"{\n"];
    /*block快速遍历*/
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringM appendFormat:@"\t%@ = %@;\n",key,obj];
    }];
    [stringM appendString:@"}\n"];
    
    return stringM;
}

@end
