//
//  ContainerController.m
//  TESTContrainer
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import "ContainerController.h"
#import "Page1.h"
#import "Page2.h"
#import "AppDelegate.h"

@interface ContainerController ()

@end

@implementation ContainerController {
    AppDelegate *ad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"%@",ad.Page);
    if ( [ad.Page isEqualToString:@"1"]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Page1 *news = [storyboard instantiateViewControllerWithIdentifier:@"Page1"];
        //    news.view.frame = self.newsSection.bounds;
        [self.view addSubview:news.view];
        [self addChildViewController:news];
        [news didMoveToParentViewController:self];
    }
    else if ([ad.Page isEqualToString:@"2"]) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Page2 *news = [storyboard instantiateViewControllerWithIdentifier:@"Page2"];
        //    news.view.frame = self.newsSection.bounds;
        [self.view addSubview:news.view];
        [self addChildViewController:news];
        [news didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
