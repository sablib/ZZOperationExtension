//
//  ZZExclusivityController.m
//  aaa
//
//  Created by 张凯 on 15/11/23.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZExclusivityController.h"
#import "ZZOperation.h"
#import "NSArray+ZZExtension.h"
#import "ZZPostlyExclusive.h"

@interface ZZExclusivityController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<ZZOperation *> *> *operations;

@end

@implementation ZZExclusivityController

+ (instancetype)sharedExclusivityController {
    static ZZExclusivityController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[ZZExclusivityController alloc] init];
    });
    return controller;
}

- (instancetype)init {
    if (self = [super init]) {
        self.serialQueue = dispatch_queue_create("Operations.ExclusivityController", DISPATCH_QUEUE_SERIAL);
        self.operations = @{}.mutableCopy;
    }
    return self;
}

- (void)addOperation:(ZZOperation *)operatoin withCategories:(NSArray<NSString *> *)categories {
    dispatch_sync(self.serialQueue, ^{
        for (NSString *category in categories) {
            [self noqueue_addOperation:operatoin category:category];
        }
    });
}

- (void)removeOperation:(ZZOperation *)operation withCategories:(NSArray<NSString *> *)categories {
    dispatch_sync(self.serialQueue, ^{
        for (NSString *category in categories) {
            [self noqueue_removeOperation:operation category:category];
        }
    });
}

- (void)noqueue_addOperation:(ZZOperation *)operation category:(NSString *)category {
    NSArray<ZZOperation *> *operationsWithThisCategories = self.operations[category] ?: @[];
    
    if ([category hasPrefix:@"PostlyExclusive"]) {
        if (operationsWithThisCategories.count) {
            [operationsWithThisCategories makeObjectsPerformSelector:@selector(cancel)];
        }
    } else if ([category hasPrefix:@"KeepFirstExclusive"]) {
        if (operationsWithThisCategories.count && [operationsWithThisCategories zz_filter:^BOOL(NSOperation *each) {
            return ![each isCancelled];
        }].count) {
            [operation cancel];
        }
    } else {
        if (operationsWithThisCategories.count) {
            ZZOperation *last = operationsWithThisCategories.lastObject;
            [operation addDependency:last];
        }
    }
    
    self.operations[category] = [operationsWithThisCategories arrayByAddingObject:operation];
}

- (void)noqueue_removeOperation:(ZZOperation *)operation category:(NSString *)category {
    NSArray<ZZOperation *> *matchingOperations = self.operations[category] ?: @[];
    
    NSUInteger index = [matchingOperations indexOfObject:operation];
    if (index != NSNotFound && index < matchingOperations.count) {
        self.operations[category] = [matchingOperations zz_arrayByRemoveObjectAtIndex:index];
    }
}

@end
