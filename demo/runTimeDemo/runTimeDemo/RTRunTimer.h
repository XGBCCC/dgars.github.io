//
//  RTRunTimer.h
//  runTimeDemo
//
//  Created by jimbo on 2018/9/16.
//  Copyright © 2018年 jimbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTRunTimer : NSObject

+ (instancetype)shareInstance;
- (void)beginMonitor;

@end
