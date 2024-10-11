//
//  DPViewController.m
//  Private
//
//  Created by nick on 08/25/2024.
//  Copyright (c) 2024 nick. All rights reserved.
//

#import "DPViewController.h"
#import "DPSon.h"


@interface DPViewController ()

@property (nonatomic , strong) NSOperationQueue * queue;

@property (nonatomic ) CFRunLoopObserverRef obsever;

@end

@implementation DPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //878978978
	// Do any additional setup after loading the view, typically from a nib.
    NSOperationQueue * queue;
    NSOperation * operation;
    operation.qualityOfService = 0;
//    [self demo];
//    [self testP];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(noti) name:@"123" object:nil];
        NSLog(@"start post");
        [NSNotificationCenter.defaultCenter postNotificationName:@"123" object:nil];
        NSLog(@"end post");
    });
    
    DPSon * son = [DPSon alloc];
    NSLog(@"ssss");
}

- (void)noti {
    NSLog(@"123123");
}

- (void)demo{
    self.queue = [[NSOperationQueue alloc]init];;
    NSBlockOperation *bo1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"请求token");
    }];
    
    NSBlockOperation *bo2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"拿着token,请求数据1");
    }];
    
    NSBlockOperation *bo3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"拿着数据1,请求数据2");
    }];
    
    //因为异步,不好控制,我们借助依赖
    [bo2 addDependency:bo1];
    [bo3 addDependency:bo2];
    //注意这里一定不要构成循环依赖 : 不会报错,但是所有操作不会执行
    //[bo1 addDependency:bo3];
    //waitUntilFinished 堵塞线程
    [self.queue addOperations:@[bo1,bo2,bo3] waitUntilFinished:YES];
//    [self.queue addOperation:bo1];
//    [self.queue addOperation:bo2];
//    [self.queue addOperation:bo3];
    if (@available(iOS 13.0, *)) {
        [self.queue addBarrierBlock:^{
            NSLog(@"执行完了?我要干其他事111");
        }];
    } else {
        // Fallback on earlier versions
    }
    NSLog(@"执行完了?我要干其他事");
}

- (void)testP
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
        NSRunLoop * lp = [NSRunLoop currentRunLoop];
        
        [self addObserver];
//        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            NSLog(@"444");
//        }];
//        [lp addTimer:timer forMode:NSDefaultRunLoopMode];
        [self performSelector:@selector(testPerform) withObject:nil afterDelay:0.5];//
        [lp run];
        NSLog(@"3");
        
        
    });
}
- (void)testPerform{
    NSLog(@"2");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserver
{
    /*
     kCFRunLoopEntry = (1UL << 0),1
     kCFRunLoopBeforeTimers = (1UL << 1),2
     kCFRunLoopBeforeSources = (1UL << 2), 4
     kCFRunLoopBeforeWaiting = (1UL << 5), 32
     kCFRunLoopAfterWaiting = (1UL << 6), 64
     kCFRunLoopExit = (1UL << 7),128
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case 1:
            {
                NSLog(@"进入runloop");
            }
                break;
            case 2:
            {
                NSLog(@"timers");
            }
                break;
            case 4:
            {
                NSLog(@"sources");
            }
                break;
            case 32:
            {
                NSLog(@"即将进入休眠");
            }
                break;
            case 64:
            {
                NSLog(@"唤醒");
            }
                break;
            case 128:
            {
                NSLog(@"退出");
            }
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);//将观察者添加到common模式下，这样当default模式和UITrackingRunLoopMode两种模式下都有回调。
    self.obsever  = observer;
    CFRelease(observer);
}



@end
