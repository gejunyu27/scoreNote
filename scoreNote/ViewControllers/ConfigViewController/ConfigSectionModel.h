//
//  ConfigSectionModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/4.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigSectionModel : NSObject
@property (nonatomic, strong) NSMutableArray <ConfigModel *> *models;

@end

NS_ASSUME_NONNULL_END
