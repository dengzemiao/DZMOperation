//
//  DZMOperation.h
//  DZMOperation
//
//  Created by 邓泽淼 on 2017/11/10.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ _Nonnull DZMOperationCompletionBlock)(void);

typedef void (^ _Nonnull DZMOperationBlock)(DZMOperationCompletionBlock completionBlock);

@interface DZMOperation : NSOperation

/// 创建
+ (nonnull instancetype)operationWithBlock:(DZMOperationBlock)operationBlock;

@end
