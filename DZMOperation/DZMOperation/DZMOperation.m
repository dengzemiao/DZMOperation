//
//  DZMOperation.m
//  DZMOperation
//
//  Created by 邓泽淼 on 2017/11/10.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMOperation.h"

@interface DZMOperation()

/// 执行状态
@property (nonatomic, assign, getter = isExecuting) BOOL executing;

/// 执行完成 
@property (nonatomic, assign, getter = isFinished) BOOL finished;

/// 回调Block
@property (nonatomic, copy) DZMOperationBlock operationBlock;
@end

@implementation DZMOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

+ (nonnull instancetype)operationWithBlock:(DZMOperationBlock)operationBlock {
    
    return [[DZMOperation alloc] initWithBlock:operationBlock];
}

- (nonnull instancetype)initWithBlock:(DZMOperationBlock)operationBlock {
    
    if (self = [super init]) {
        
        _finished = NO;
        _executing = NO;
        _operationBlock = operationBlock;
    }
    
    return self;
}

- (void)start {
    
    @synchronized(self) {
        
        if (self.isCancelled) {
            
            self.finished = YES;
            
            return;
        }
        
        self.executing = YES;
        
        __weak DZMOperation *weakSelf = self;
        
        self.operationBlock(^{
            
            weakSelf.executing = NO;
            
            weakSelf.finished = YES;
        });
        
        [self operationBlock];
    }
}

- (void)setFinished:(BOOL)finished {
    
    [self willChangeValueForKey:@"isFinished"];
    
    _finished = finished;
    
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = executing;
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    
    return YES;
}

@end
