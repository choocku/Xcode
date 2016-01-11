//
//  slideMenu.m
//  mock_up
//
//  Created by Kittisak Chiewchoengchon on 11/2/14.
//  Copyright (c) 2014 Choock. All rights reserved.
//

#import "slideMenu.h"
#import "ViewController.h"
#import "PatchingViewController.h"
#import "LayoutViewController.h"

@interface slideMenu ()

@end
@implementation slideMenu : ControlBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (void)initMenu
{
    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"], [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(30, 22)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - CDSideBarController delegate

- (void)menuButtonClicked:(int)index
{
    // Execute what ever you want
    NSLog(@"index = %d",index);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(index == 0){
        PatchingViewController *viewController = (PatchingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PatchingViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else if(index == 1){
        LayoutViewController *viewController = (LayoutViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LayoutViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
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
