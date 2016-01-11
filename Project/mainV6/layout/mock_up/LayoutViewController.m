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
#import "DataClass.h"

@interface LayoutViewController () 

@end

@implementation LayoutViewController
{
    UIView *layoutView;
    int x_drawDevices;
    int y_drawDevices;
    int width_drawDevices;
    int height_drawDevices;
    int x_navbar;
    int y_navbar;
    int width_navbar;
    int height_navbar;
    int y_navbarLabel;
    int width_navbarLabel;
    int height_navbarLabel;
    int x_containerView;
    int y_containerView;
    int width_containerView;
    int height_containerView;
    float cornerRadius;
    
    DataClass *layoutClass;
    
    NSMutableArray * temp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super initMenu];
    [super initControlBar];
    // Do any additional setup after loading the view, typically from a nib.
    layoutClass = [DataClass sharedGlobalData];
    
    [self initVariables];
    [self initPatterns];
    [self initButtonFromPatching];
    
    if (layoutClass.selected.count!=0) {
        NSLog(@"layout again");
        for (int i=0; i<layoutClass.selected.count; i++) {
            int selectedButtonTag = [[layoutClass.selected objectAtIndex:i] intValue];
            NSLog(@"selectButtonTAG=%d",selectedButtonTag);
            [self setHasSelectedButton:selectedButtonTag];
            //NSLog(@"selected=%d",selectedButton);
        }
    }
    
    NSLog(@"Layout Ready");
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
    width_drawDevices = 44;
    height_drawDevices = 44;
    
    // parameter of navbarLabel
    y_navbarLabel = 0;
    width_navbarLabel = 150;
    height_navbarLabel = 44;
    
    cornerRadius = 9.0f;       // layer.cornerRadius
    
    temp = [[NSMutableArray alloc] init];
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
    navbarLabel.font = [UIFont boldFlatFontOfSize:25];
    [navbar addSubview:navbarLabel];
    
    // init layout view
    layoutView = [[UIView alloc] initWithFrame:CGRectMake( 10, 74, self.view.bounds.size.width-20, 600)];
    layoutView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    layoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    layoutView.layer.cornerRadius = cornerRadius;
    layoutView.layer.masksToBounds = YES;
    [self.view addSubview:layoutView];
}

- (void)button:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    if(((UIButton *)sender).selected) {
        //NSLog(@"save %d",((UIButton *)sender).tag);
        [layoutClass.selected addObject:[NSNumber numberWithInt:(int)((UIButton *)sender).tag]];
        [[((UIButton *)sender) layer] setBorderColor:[UIColor greenColor].CGColor];
    }
    else {
        //NSLog(@"remove %d",((UIButton *)sender).tag);
        [layoutClass.selected removeObjectIdenticalTo:[NSNumber numberWithInt:(int)((UIButton *)sender).tag]];
        [[((UIButton *)sender) layer] setBorderColor:[UIColor blackColor].CGColor];
    }
}

-(void)setHasSelectedButton:(int)tag {
    UIButton * hasSelected = (UIButton *)[layoutView viewWithTag:tag];
    NSLog(@"tag=%ld,name=%@", (long)hasSelected.tag, hasSelected.titleLabel.text);
    [hasSelected setSelected:YES];
    if(hasSelected.selected) {
        //NSLog(@"setColor %d",hasSelected.tag);
        [[hasSelected layer] setBorderColor:[UIColor greenColor].CGColor];
    }
}

-(void)setPosition:(int)tag {
    
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
//    [temp addObject:[NSNumber numberWithInt:button.tag]];
//    [temp addObject:[NSNumber numberWithFloat:button.center.x]];
//    [temp addObject:[NSNumber numberWithFloat:button.center.y]];
//    [layoutClass.layout replaceObjectAtIndex:button.tag-1 withObject:[temp mutableCopy]];
//    [temp removeAllObjects];
//    [self setPosition:button.tag];
}

-(void)initButtonFromPatching {
    //[self createClearButton];
    for (int i=0; i<layoutClass.device.count; i++) {
        NSLog(@"initButtonFromPatching=%d",i);
        NSString * get_id = [[layoutClass.device objectAtIndex:i] objectAtIndex:0];
        int deviceID = [get_id intValue];
        UIButton * button = [[UIButton alloc] init];
        CGRect frame;
        NSString * get_type = [[layoutClass.device objectAtIndex:i] objectAtIndex:2];
        if ([get_type isEqual:[layoutClass.typeOfLight objectAtIndex:0]]) {
            frame = CGRectMake(x_drawDevices-300, y_drawDevices, width_drawDevices, height_drawDevices);
            [button setBackgroundColor:[UIColor blackColor]];
        }
        else if ([get_type isEqual:[layoutClass.typeOfLight objectAtIndex:1]]) {
            frame = CGRectMake(x_drawDevices, y_drawDevices, width_drawDevices, height_drawDevices);
            [button setBackgroundColor:[UIColor redColor]];
        }
        else if ([get_type isEqual:[layoutClass.typeOfLight objectAtIndex:2]]) {
            frame = CGRectMake(x_drawDevices+300, y_drawDevices, width_drawDevices, height_drawDevices);
            [button setBackgroundColor:[UIColor blueColor]];
        }
        button.frame = frame;
        
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
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

@end
