//
//  TagModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import "TagModel.h"

@implementation TagModel

- (void)setName:(NSString *)name
{
    _name = name;
    _pinyinFirstChar = [SCUtilities getPinyinFirstCharFromString:name?:@""];
}

@end
