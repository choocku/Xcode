//
//  ViewController.m
//  TESTContrainer
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import "ViewController.h"
#import "Page1.h"
#import "Page2.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController {
    AppDelegate *ad;
    ContainerController *con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"%@",[self childViewControllers]);
    
    con = [[self childViewControllers]objectAtIndex:0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Page1:(id)sender {
    
    ad.Page = @"1";
    [con viewDidLoad];
}

- (IBAction)Page2:(id)sender {
    ad.Page = @"2";
    [con viewDidLoad];
}
@end
