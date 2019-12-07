//
//  SFQueueTasksManager.m
//  Safy
//
//  Created by Jason zhou on 5/16/13.
//  Copyright (c) 2013 四目科技(上海)有限公司. All rights reserved.
//

#import "SFQueueTasksManager.h"

static SFQueueTasksManager* s_queueTasksManager = nil;

@implementation SFQueueTasksManager

+ (SFQueueTasksManager*)sharedQueueTasksManager{
    if(s_queueTasksManager == nil){
        s_queueTasksManager = [[SFQueueTasksManager alloc] init];
    }
    return s_queueTasksManager;
}

- (void)addTask:(SFQueueBaseTask*)task{
    [self.defaultQueueArray addObject:task];
}

- (void)removeTask:(SFQueueBaseTask*)task{
    [self.defaultQueueArray removeObject:task];
}

- (BOOL)hasTask:(SFQueueBaseTask*)task{
    return [self.defaultQueueArray containsObject:task];
}

- (BOOL)hasTaskClass:(Class)taskClass{

    BOOL taskClassValue = NO;
    for (int i = 0; i < [self.defaultQueueArray count]; i++) {
        SFQueueBaseTask *task = [self.defaultQueueArray objectAtIndex:i];
        if ([task isKindOfClass:taskClass]) {
            taskClassValue = YES;
            break;
        }
    }
    return taskClassValue;
}

- (id)init{
    self = [super init];
    if ( self ) {
        
        _defaultQueueArray = [[NSMutableArray alloc] init];
        
        _operationQueue = [[NSOperationQueue alloc] init];
        
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%@ class dealloc",[self class]);

}

@end

@implementation SFQueueBaseTask

- (void)dealloc{
    NSLog( @"%@ dealloced", [self class] );
    //[_actionHandler release];
}

@end
