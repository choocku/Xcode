//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "ViewController.h"
#import "LayoutViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UIStepper+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "FUISegmentedControl.h"
#import "UIPopoverController+FlatUI.h"

@interface LayoutViewController () {
    UIPopoverController *_popoverController;
}

@end

@implementation LayoutViewController
{
    UIView *layoutView;
    UIView *containerView;
    NSMutableArray *patch;
    NSMutableArray *patch1;
    NSMutableArray *patch2;
    NSMutableArray *patch3;
    NSMutableArray *patch4;
    NSMutableArray *patch5;
    NSMutableArray *patch6;
    NSMutableArray *buttonSelected;
    NSArray *array;
    NSArray *array2;
    int x_drawDevices;
    int y_drawDevices;
    int width_drawDevices;
    int height_drawDevices;
    int x_navbar;
    int y_navbar;
    int width_navbar;
    int height_navbar;
    int cornerRadius;
    int y_navbarLabel;
    int width_navbarLabel;
    int height_navbarLabel;
    
    int x_containerView;
    int y_containerView;
    int width_containerView;
    int height_containerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Ready");
    [self initVariables];
    [self initPatterns];
    [self dataFromPatching];
    [self initButtonFromPatching];
    [self controlButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initVariables {
    // parameter of navigation bar
    x_navbar = 10;
    y_navbar = 20;
    width_navbar = [UIScreen mainScreen].bounds.size.width-(10*2);
    height_navbar = 44;
    
    // parameter of drawDevices
    x_drawDevices = 500-25;
    y_drawDevices = 10;
    width_drawDevices = 30;
    height_drawDevices = 30;
    
    // parameter of navbarLabel
    y_navbarLabel = 0;
    width_navbarLabel = 150;
    height_navbarLabel = 44;
    
    cornerRadius = 5;       // layer.cornerRadius
}

-(void)initPatterns {
    // set background color
    [self.view setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]]; /*#bdc3c7*/
    
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(x_navbar, y_navbar, width_navbar, height_navbar)];
    navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    navbar.layer.cornerRadius = cornerRadius;
    navbar.layer.masksToBounds = YES;
    [self.view addSubview:navbar];
    
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake( navbar.center.x-60, y_navbarLabel, width_navbarLabel, height_navbarLabel)];
    navbarLabel.text = @" Layout";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    [navbar addSubview:navbarLabel];
    
    // init layout view
    layoutView = [[UIView alloc] initWithFrame:CGRectMake( 10, 74, self.view.bounds.size.width-20, 600)];
    layoutView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    layoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    layoutView.layer.cornerRadius = cornerRadius;
    layoutView.layer.masksToBounds = YES;
    [self.view addSubview:layoutView];
    
    // init container View
    containerView = [[UIView alloc] initWithFrame:CGRectMake( 10, 684, self.view.bounds.size.width-20, 75)];
    containerView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    containerView.layer.cornerRadius = cornerRadius;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
}

-(void)initButtonFromPatching {
    //[self createClearButton];
    for (int i=0; i<patch.count; i++) {
        NSString * get_id = [[patch objectAtIndex:i] objectAtIndex:0];
        int deviceID = [get_id intValue]+1;
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(x_drawDevices, y_drawDevices, width_drawDevices, height_drawDevices)];
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:[UIColor blackColor]];
        button.tag = deviceID;
        NSString * title = [NSString stringWithFormat:@"%d",deviceID];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[button layer] setBorderWidth:2.0f];
        [[button layer] setBorderColor:[UIColor blackColor].CGColor];
        [button addTarget:self action:@selector(button:)
         forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(wasDragged:withEvent:)
          forControlEvents:UIControlEventTouchDragInside];
        [layoutView addSubview:button];
    }
}

- (void)button:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    if(((UIButton *)sender).selected) {
        [buttonSelected addObject:[NSNumber numberWithInt:(int)((UIButton *)sender).tag-1]];
        [[((UIButton *)sender) layer] setBorderColor:[UIColor greenColor].CGColor];
    }
    else {
        [buttonSelected removeObjectIdenticalTo:[NSNumber numberWithInt:(int)((UIButton *)sender).tag-1]];
        [[((UIButton *)sender) layer] setBorderColor:[UIColor blackColor].CGColor];
    }
    NSLog(@"%@",buttonSelected);
}

-(void)controlButton {
    int x_controlButton = 10;
    int y_controlButton = 10;
    int width_controlButton = 100;
    int height_controlButton = 55;
    [self createButtonControlTab:@"Dimmer"
                             tag:1000
                               x:x_controlButton+((width_controlButton+x_controlButton)*0)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Position"
                             tag:1001
                               x:x_controlButton+((width_controlButton+x_controlButton)*1)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Gobo/Litho"
                             tag:1002
                               x:x_controlButton+((width_controlButton+x_controlButton)*2)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Color"
                             tag:1003
                               x:x_controlButton+((width_controlButton+x_controlButton)*3)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Beam"
                             tag:1004
                               x:x_controlButton+((width_controlButton+x_controlButton)*4)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Focus"
                             tag:1005
                               x:x_controlButton+((width_controlButton+x_controlButton)*5)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Effect Offset"
                             tag:1006
                               x:x_controlButton+((width_controlButton+x_controlButton)*6)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor blackColor]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Store"
                             tag:1007
                               x:x_controlButton+((width_controlButton+x_controlButton)*7)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1]
                        selector:NSStringFromSelector(@selector(logTag:))];
    [self createButtonControlTab:@"Add To Cue"
                             tag:1008
                               x:x_controlButton+((width_controlButton+x_controlButton)*8)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                              bg:[UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1]
                        selector:NSStringFromSelector(@selector(logTag:))];
}

-(void)logTag:(id)sender {
    NSLog(@"%ld",(long)((UIButton *)sender).tag);
}

-(void)createButtonControlTab:(NSString *)title tag:(int)tag x:(int)x y:(int)y w:(int)w h:(int)h bg:(UIColor *)bg selector:(NSString *)selector {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = tag;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [button setBackgroundColor:bg];
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:button];
}

-(void)dataFromPatching{
    buttonSelected = [[NSMutableArray alloc] init];
    patch = [[NSMutableArray alloc] init];
    patch1 = [[NSMutableArray alloc] initWithObjects:@"0",@"a1",@"Xspot",@"1",@"38", nil];
    patch2 = [[NSMutableArray alloc] initWithObjects:@"1",@"a2",@"Xspot",@"39",@"38", nil];
    patch3 = [[NSMutableArray alloc] initWithObjects:@"2",@"c1",@"Studio250",@"77",@"18", nil];
    patch4 = [[NSMutableArray alloc] initWithObjects:@"3",@"c2",@"Studio250",@"95",@"18", nil];
    patch5 = [[NSMutableArray alloc] initWithObjects:@"4",@"d1",@"Cyberlight",@"96",@"20", nil];
    patch6 = [[NSMutableArray alloc] initWithObjects:@"5",@"d2",@"Cyberlight",@"107",@"20", nil];
    [patch addObject:patch1];
    [patch addObject:patch2];
    [patch addObject:patch3];
    [patch addObject:patch4];
    [patch addObject:patch5];
    [patch addObject:patch6];
    array = [[NSArray alloc] initWithObjects:@"Studio250", @"Cyberlight", @"Xspot", nil];
    array2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:18],[NSNumber numberWithInt:20],[NSNumber numberWithInt:38],nil];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    // get the touch
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    // move button
    if( button.center.x<0 || button.center.x>self.view.bounds.size.width ||
       button.center.y<0 || button.center.y>500 ) {
        button.center = CGPointMake(x_drawDevices+button.bounds.size.width/2,
                                    y_drawDevices+button.bounds.size.height/2);
    }
    else {
        button.center = CGPointMake(button.center.x + delta_x,
                                    button.center.y + delta_y);
    }
}

@end
