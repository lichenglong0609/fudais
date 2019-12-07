//
//  UDDGetAddressBookTasks.h
//  UddTrip
//
//  Created by Chuan Liu on 16/9/3.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "SFQueueTasksManager.h"

@interface UDDGetAddressBookTasks : SFQueueBaseTask

+ (void)startGetAddressBookCallBackIndex:(NSInteger)index callBack:(void (^)(BOOL success, NSArray *userArray,NSArray *titleArray ))actionHandler;

@end
