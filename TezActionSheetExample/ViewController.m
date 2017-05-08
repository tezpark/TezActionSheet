//
//  ViewController.m
//  TezActionSheetExample
//
//  Created by Taesun Park on 2015. 5. 28..
//  Copyright (c) 2015년 TezLab. All rights reserved.
//

#import "ViewController.h"
#import "TezActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIButton* tmoBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, 100, 250, 30)];
    [tmoBtn setTitle:@"Show action sheet" forState:UIControlStateNormal];
    [tmoBtn setBackgroundColor:[UIColor lightGrayColor]];
    [tmoBtn addTarget:self action:@selector(onClickShowActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tmoBtn];
}

- (void)onClickShowActionSheet {
    [[TezActionSheet sharedInstance] showActionSheetWithSelectButtonTitles:@[@"Button 1", @"Button 2", @"Button3"]
                                                         cancelButtonTitle:@"Cancel"
                                                               selectBlock:^(NSInteger index) {
                                                                   NSLog(@"selcted button index : %ld", (long)index);
                                                               } cancelBlock:^{
                                                                   NSLog(@"cancel");
                                                               }
                                                           enableAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
