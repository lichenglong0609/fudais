//
//  SFQueueTasksManager.h
//  Safy
//
//  Created by Jason zhou on 5/16/13.
//  Copyright (c) 2013 四目科技(上海)有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFQueueBaseTask;

/*
 描述: SFQueueTasksManager 业务层队列管理
 输出: 队列
 备注: 队列中需放置SFQueueTask类型的实例
 */
@interface SFQueueTasksManager : NSObject
@property (nonatomic,retain) NSMutableArray* defaultQueueArray;

+ (SFQueueTasksManager*)sharedQueueTasksManager;

- (void)addTask:(SFQueueBaseTask*)task;
- (void)removeTask:(SFQueueBaseTask*)task;
- (BOOL)hasTask:(SFQueueBaseTask*)task;
- (BOOL)hasTaskClass:(Class)taskClass;

@property (nonatomic, retain) NSOperationQueue *operationQueue;

@end

/*
 描述: SFQueueTask 业务层队列任务父类
 输出: actionHandler
 备注: dataModel可以为任意数据类型
 */
@interface SFQueueBaseTask : NSObject
//@property (nonatomic,copy) void (^actionHandler)( id dataModel );

@end
