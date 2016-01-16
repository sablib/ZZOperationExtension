//
//  ViewController.m
//  ZZOperationExtension
//
//  Created by 张凯 on 15/11/24.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ViewController.h"
#import "ZZOperationExtension.h"
#import "ZZHelper.h"
#import "ZZGroupOperation.h"

@interface ViewController ()

@property (nonatomic, strong) ZZOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.queue = [[ZZOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    ZZBlockOperation *op = [[ZZBlockOperation alloc] initWithBlock:^(dispatch_block_t block, BOOL(^isCancelled)()){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isCancelled()) {
                block();
                return;
            }

            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = [UIColor greenColor];
            [[ZZHelper topMostVC] presentViewController:vc animated:YES completion:^{
                block();
            }];
        });
    }];
    
    ZZBlockOperation *op1 = [[ZZBlockOperation alloc] initWithBlock:^(dispatch_block_t block, BOOL(^isCancelled)()){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isCancelled()) {
                block();
                return;
            }
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = [UIColor redColor];
            [[ZZHelper topMostVC] presentViewController:vc animated:YES completion:^{
                block();
            }];
        });
    }];
    
    ZZBlockObserver *ob = [[ZZBlockObserver alloc] initWithStartHandler:^(ZZOperation *operation) {
        NSLog(@"operation %@ started", operation);
    } produceHandler:^(ZZOperation *operation, NSOperation *newOperation) {
        NSLog(@"operation %@ produced operation %@", operation, newOperation);
    } finishHandler:^(ZZOperation *operation, NSArray<NSError *> *errors) {
        NSLog(@"operation %@ finished.", operation);
    }];
    
    [op addObserver:ob];
    [op1 addObserver:ob];
    
    [op addCondition:[[ZZMutuallyExclusive alloc] initWithClass:[UIViewController class]]];
    [op1 addCondition:[[ZZMutuallyExclusive alloc] initWithClass:[UIViewController class]]];
    
    ZZGroupOperation *groups = [[ZZGroupOperation alloc] initWithOperations:@[op, op1]];
    
    [self.queue addOperation:groups];
}

@end
