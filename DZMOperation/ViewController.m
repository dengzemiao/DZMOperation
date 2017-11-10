//
//  ViewController.m
//  DZMOperation
//
//  Created by 邓泽淼 on 2017/11/10.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "ViewController.h"
#import "DZMOperation.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.queue = [[NSOperationQueue alloc] init];
    
//    self.queue.maxConcurrentOperationCount = 1;
    
}

- (IBAction)start:(UIButton *)sender {
    
    DZMOperation *operation1 = [DZMOperation operationWithBlock:^(DZMOperationCompletionBlock completionBlock) {
        
        NSLog(@"请求1完成 %@",[NSThread currentThread]);
        
        completionBlock();
    }];
    
    DZMOperation *operation2 = [DZMOperation operationWithBlock:^(DZMOperationCompletionBlock completionBlock) {
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            NSLog(@"请求2完成 %@",[NSThread currentThread]);
            
            completionBlock();
        });
        
    }];
    
    DZMOperation *operation3 = [DZMOperation operationWithBlock:^(DZMOperationCompletionBlock completionBlock) {
        
        NSLog(@"请求3开始 %@",[NSThread currentThread]);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_global_queue(0, 0), ^{
                
                NSLog(@"请求3完成 %@",[NSThread currentThread]);
                
                completionBlock();
            });
        });
        
    }];
    
    DZMOperation *operation4 = [DZMOperation operationWithBlock:^(DZMOperationCompletionBlock completionBlock) {
        
        NSLog(@"请求4完成 %@",[NSThread currentThread]);
        
        completionBlock();
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    [operation4 addDependency:operation3];
    
    [self.queue addOperation:operation1];
    [self.queue addOperation:operation2];
    [self.queue addOperation:operation3];
    [self.queue addOperation:operation4];
}

- (IBAction)suspend:(UIButton *)sender {
    
    [self.queue setSuspended:YES];
}

- (IBAction)continue:(UIButton *)sender {
    
    [self.queue setSuspended:NO];
}

- (IBAction)cancelAll:(UIButton *)sender {
    
    [self.queue cancelAllOperations];
}

@end
