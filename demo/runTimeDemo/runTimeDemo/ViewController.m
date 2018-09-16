//
//  ViewController.m
//  runTimeDemo
//
//  Created by jimbo on 2018/9/16.
//  Copyright © 2018年 jimbo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73726/world.topo.bathy.200406.3x5400x2700.png"]];

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    UIImage *Image = [UIImage imageWithData:data];
    UIImageView *imView = [[UIImageView alloc] initWithImage:Image];
    [imView setFrame:CGRectMake(0, 0, 1000, 1000)];
    [self.view addSubview:imView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
