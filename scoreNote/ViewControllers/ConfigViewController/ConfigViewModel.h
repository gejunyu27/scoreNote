//
//  ConfigViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/4.
//

#import <Foundation/Foundation.h>
#import "ConfigSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <ConfigSectionModel *> *sectionList;

@property (nonatomic, assign) BOOL isDeveloper;

- (BOOL)verifyDeveloperPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
