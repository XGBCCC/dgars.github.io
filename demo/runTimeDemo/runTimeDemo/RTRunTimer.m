//
//  RTRunTimer.m
//  runTimeDemo
//
//  Created by jimbo on 2018/9/16.
//  Copyright © 2018年 jimbo. All rights reserved.
//

#import "RTRunTimer.h"
#include <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>

#include <mach/task.h>
#include <mach/vm_map.h>
#include <mach/mach_init.h>
#include <mach/thread_act.h>
#include <mach/thread_info.h>

@interface RTRunTimer(){
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
    @public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}

@end

@implementation RTRunTimer

+ (instancetype)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)beginMonitor{
    dispatchSemaphore = dispatch_semaphore_create(0);
    CFRunLoopObserverContext context = {0,(__bridge void *)self,NULL,NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 16 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
//                    if (++(self->timeoutCount) < 3) {
//                        continue;
//                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                       //获取当前堆栈
                        NSArray *syms = [NSThread callStackSymbols];
                        NSLog(@"%@", syms);
                    });
                }
            }
        }
    });
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    RTRunTimer *runTimeInfo = (__bridge RTRunTimer*)info;
    runTimeInfo->runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = runTimeInfo->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

//
//- (NSString *)callStacks{
//    thread_act_array_t threads;
//    mach_msg_type_number_t thread_count = 0;
//    const task_t this_task = mach_task_self();
//    kern_return_t kr = task_threads(this_task, &threads, &thread_count);
//    if (kr != KERN_SUCCESS) {
//        return @"fail get all threads";
//    }
//
//}
@end
