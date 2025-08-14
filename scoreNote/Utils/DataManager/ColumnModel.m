//
//  ColumnModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/6.
//

#import "ColumnModel.h"

@implementation ColumnModel
+ (ColumnModel *)parsingModelWithName:(NSString *)name type:(nonnull NSString *)type notnull:(BOOL)notnull
{
    ColumnModel *model = [self new];
    model.name    = name?:@"";
    model.type    = type?:@"";
    model.notnull = notnull;
    
    return model;
}

+ (nullable ColumnModel *)parsingModelWithName:(NSString *)name type:(NSString *)type
{
    return [self parsingModelWithName:name type:type notnull:NO];
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"%@ %@%@", self.name, self.type, (self.notnull ? @" NOT NULL" : @"")];
    return str;
}

- (NSString *)descriptionRemoveName
{
    NSString *str = [NSString stringWithFormat:@"%@%@", self.type, (self.notnull ? @" NOT NULL" : @"")];
    return str;
}

@end
