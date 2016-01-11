//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "ControlBar.h"
#import "TBCircularSlider.h"
#import "AsyncUdpSocket.h"

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

@interface ControlBar () {
    UIPopoverController *_popoverController;
}

@end

long tag;
AsyncUdpSocket *udpSocket;
NSString *host = @"172.16.0.148";//@"127.0.0.1";
int port = 1024;

@implementation ControlBar
{
    // data from patching
    NSMutableArray *patch;
    NSMutableArray *patch0;
    NSMutableArray *patch1;
    NSMutableArray *patch2;
    NSMutableArray *patch3;
    NSMutableArray *patch4;
    NSMutableArray *patch5;
    NSMutableArray *patch6;
    NSMutableArray *device;
    NSMutableArray *value;
    NSMutableArray *temp;
    NSMutableArray *buttonSelected;
    NSString * message;
    
    // control bar
    UIView *containerView;
    float cornerRadius;
    
    // dimmer button
    TBCircularSlider *dimmer;
    
    // position button
    UIView * positionView;
    UIButton *panTiltButton;
    UIBezierPath *path;
    UIBezierPath *path2;
    UITextField * pan_text;
    UITextField * tilt_text;
    
    // focus button
    TBCircularSlider *focusSlider;
    TBCircularSlider *zoomSlider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    
    [udpSocket receiveWithTimeout:-1 tag:0];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Control Bar ready");
    cornerRadius = 9.0f;
    [self dataFromPatching];
    //NSLog(@"%@",device);
}

-(void)sendUDP:(NSString *)msg{
    if ([host length] == 0)
    {
        NSLog(@"Address required");
        return;
    }
    
    if (port <= 0 || port > 65535)
    {
        NSLog(@"Valid port required");
        return;
    }
    
    if ([msg length] == 0)
    {
        NSLog(@"Message required");
        return;
    }
    
    NSLog(@"message=%@",msg);
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    tag++;
}

-(void)initControlBar {
    // init container View
    containerView = [[UIView alloc] initWithFrame:CGRectMake( 10, 684, self.view.bounds.size.width-20, 75)];
    containerView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    containerView.layer.cornerRadius = cornerRadius;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    cornerRadius = 9.0f;
    [self controlButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)controlButton {
    int x_controlButton = 10;
    int y_controlButton = 10;
    int width_controlButton = 100;
    int height_controlButton = 55;
    
    [self createButton:containerView
                            title:@"Dimmer"
                             tag:1000
                               x:x_controlButton+((width_controlButton+x_controlButton)*0)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                           selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Position"
                             tag:1001
                               x:x_controlButton+((width_controlButton+x_controlButton)*1)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Gobo/Litho"
                             tag:1002
                               x:x_controlButton+((width_controlButton+x_controlButton)*2)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Color"
                             tag:1003
                               x:x_controlButton+((width_controlButton+x_controlButton)*3)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Beam"
                             tag:1004
                               x:x_controlButton+((width_controlButton+x_controlButton)*4)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Focus"
                             tag:1005
                               x:x_controlButton+((width_controlButton+x_controlButton)*5)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Effect Offset"
                             tag:1006
                               x:x_controlButton+((width_controlButton+x_controlButton)*6)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor peterRiverColor]
                     shadowColor:[UIColor belizeHoleColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(showPopover:))];
    [self createButton:containerView
                              title:@"Store"
                             tag:1007
                               x:x_controlButton+((width_controlButton+x_controlButton)*7)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor amethystColor]
                     shadowColor:[UIColor wisteriaColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                           selector:NSStringFromSelector(@selector(store:))];
    [self createButton:containerView
                              title:@"Clear"
                             tag:1008
                               x:x_controlButton+((width_controlButton+x_controlButton)*8)
                               y:y_controlButton
                               w:width_controlButton
                               h:height_controlButton
                     buttonColor:[UIColor emerlandColor]
                     shadowColor:[UIColor nephritisColor]
                    shadowHeight:3.0f
                      titleColor:[UIColor cloudsColor]
                        selector:NSStringFromSelector(@selector(clear:))];
}

- (void)showPopover:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor cloudsColor];
    vc.title = ((UIButton *)sender).titleLabel.text;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldFlatFontOfSize:18], NSForegroundColorAttributeName: [UIColor whiteColor]};
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:nc];
    [_popoverController configureFlatPopoverWithBackgroundColor:[UIColor peterRiverColor] cornerRadius:9.0];
    _popoverController.delegate = self;
    
    [_popoverController presentPopoverFromRect:button.frame inView:containerView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Dimmer"]) {
        vc.preferredContentSize = CGSizeMake(240, 200);     //fit for one TB
        [self initDimmer:vc];
    }
    else if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Position"]) {
        vc.preferredContentSize = CGSizeMake(400, 285);
        [self initPanTilt:vc];
    }
    else if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Gobo/Litho"]) {
        vc.preferredContentSize = CGSizeMake(320, 200);
        [self goboLitho:vc];
    }
    else if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Color"]) {
        vc.preferredContentSize = CGSizeMake(540, 80);
        [self initLightColor:vc];
    }
    else if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Beam"]) {
        vc.preferredContentSize = CGSizeMake(540, 60);
        [self initIris:vc];
        [self initShutter:vc];
    }
    else if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Focus"]) {
        vc.preferredContentSize = CGSizeMake(480, 200);
        [self initFocus:vc];
        [self initZoom:vc];
    }
    else if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Effect Offset"]) {
        vc.preferredContentSize = CGSizeMake(320, 200);
        [self effectOffset:vc];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// Dimmer //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)initDimmer:(UIViewController *)vc {
    //Create the Circular Slider
    dimmer = [[TBCircularSlider alloc]initWithFrame:CGRectMake(0, 0, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    
    //Define Target-Action behaviour
    [dimmer addTarget:self action:@selector(dimValue:) forControlEvents:UIControlEventValueChanged];
    [vc.view addSubview:dimmer];
    
    UILabel *onoff_label = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 80, 35)];
    onoff_label.text = @"Light";
    onoff_label.textColor = [UIColor midnightBlueColor];
    onoff_label.font = [UIFont boldFlatFontOfSize:18];
    onoff_label.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:onoff_label];
    
    FUISwitch *onoff = [[FUISwitch alloc] initWithFrame: CGRectMake(140, 200, 80, 35)];
    onoff.onColor = [UIColor peterRiverColor];
    onoff.offColor = [UIColor cloudsColor];
    onoff.onBackgroundColor = [UIColor midnightBlueColor];
    onoff.offBackgroundColor = [UIColor silverColor];
    onoff.offLabel.font = [UIFont boldFlatFontOfSize:14];
    onoff.onLabel.font = [UIFont boldFlatFontOfSize:14];
    [onoff addTarget: self action: @selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [vc.view addSubview:onoff];
}

/** This function is called when Circular slider value changes **/
-(void)dimValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    NSLog(@"Slider Value %d",255*slider.angle/360);
    
    NSString * val = [NSString stringWithFormat:@"%d",255*slider.angle/360];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:7
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:15
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:18
                      obj:val];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"]) {
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:7
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:17
                          obj:[NSString stringWithFormat:@"%d",20]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:38
                          obj:[NSString stringWithFormat:@"%d",255]];
            }
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"]) {
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:13
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:15
                          obj:[NSString stringWithFormat:@"%d",255]];
            }
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"]) {
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:17
                          obj:[NSString stringWithFormat:@"%d",255]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:18
                          obj:[NSString stringWithFormat:@"%d",255]];
            }
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"]) {
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:7
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:17
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:38
                          obj:[NSString stringWithFormat:@"%d",0]];
            }
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"]) {
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:13
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:15
                          obj:[NSString stringWithFormat:@"%d",0]];
            }
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"]) {
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:17
                          obj:[NSString stringWithFormat:@"%d",0]];
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:18
                          obj:[NSString stringWithFormat:@"%d",0]];
            }
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// Pan Tilt ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)initPanTilt:(UIViewController *)vc {
    positionView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 255, 255)];
    positionView.backgroundColor = [UIColor colorWithRed:0.498 green:0.549 blue:0.553 alpha:1];
    positionView.layer.borderWidth = 2.0f;
    positionView.layer.borderColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1].CGColor;
    [vc.view addSubview:positionView];
    
    UILabel *pan = [[UILabel alloc] initWithFrame:CGRectMake(300, 60, 80, 20)];
    pan.text = @"Pan";
    pan.textColor = [UIColor midnightBlueColor];
    pan.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    pan.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:pan];
    
    pan_text = [[UITextField alloc] initWithFrame:CGRectMake(300+15, 85, 50, 30)];
    pan_text.backgroundColor = [UIColor whiteColor];
    pan_text.layer.cornerRadius = cornerRadius;
    pan_text.placeholder = @"Pan";
    pan_text.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    pan_text.textAlignment = NSTextAlignmentCenter;
    [pan_text addTarget:self
                 action:@selector(panTextField)
       forControlEvents:UIControlEventEditingChanged];
    [vc.view addSubview:pan_text];
    
    
    UILabel *tilt = [[UILabel alloc] initWithFrame:CGRectMake(300, 120, 80, 20)];
    tilt.text = @"Tilt";
    tilt.textColor = [UIColor midnightBlueColor];
    tilt.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    tilt.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:tilt];
    
    tilt_text = [[UITextField alloc] initWithFrame:CGRectMake(300+15, 145, 50, 30)];
    tilt_text.backgroundColor = [UIColor whiteColor];
    tilt_text.placeholder = @"Tilt";
    tilt_text.layer.cornerRadius = cornerRadius;
    tilt_text.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    tilt_text.textAlignment = NSTextAlignmentCenter;
    [tilt_text addTarget:self
                  action:@selector(tiltTextField)
        forControlEvents:UIControlEventEditingChanged];
    [vc.view addSubview:tilt_text];
    
    [self createButton:vc.view
                 title:@"0,0"
                   tag:201
                     x:300
                     y:200
                     w:80
                     h:30
           buttonColor:[UIColor concreteColor]
           shadowColor:[UIColor asbestosColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setZero:))];
    
    [self createButton:vc.view
                 title:@"127,127"
                   tag:202
                     x:300
                     y:240
                     w:80
                     h:30
           buttonColor:[UIColor concreteColor]
           shadowColor:[UIColor asbestosColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setMid:))];
    
    [self createButton:vc.view
                 title:@"255,255"
                   tag:203
                     x:300
                     y:280
                     w:80
                     h:30
           buttonColor:[UIColor concreteColor]
           shadowColor:[UIColor asbestosColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setFull:))];
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(positionView.bounds.size.width/2, 0)];
    [path addLineToPoint:CGPointMake(positionView.bounds.size.width/2, positionView.bounds.size.height)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [positionView.layer addSublayer:shapeLayer];
    
    path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(0, positionView.bounds.size.height/2)];
    [path2 addLineToPoint:CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height/2)];
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.path = [path2 CGPath];
    shapeLayer2.strokeColor = [[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1] CGColor];
    shapeLayer2.lineWidth = 1.0;
    shapeLayer2.fillColor = [[UIColor clearColor] CGColor];
    
    [positionView.layer addSublayer:shapeLayer2];
    
    panTiltButton = [[UIButton alloc] initWithFrame:CGRectMake(127, 127, 20, 20)];
    panTiltButton.backgroundColor = [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:1];
    panTiltButton.layer.cornerRadius = 10.0f;
    [positionView addSubview:panTiltButton];
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [positionView addGestureRecognizer:panGestureRecognizer];
    [positionView addGestureRecognizer:tapGestureRecognizer];
}

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint touchLocation = [panGestureRecognizer locationInView:positionView];
    panTiltButton.center = touchLocation;
    [path addLineToPoint:CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height)];
    if (touchLocation.x<0 ) {
        panTiltButton.center = CGPointMake(0.0, touchLocation.y);
        if (touchLocation.y<0) {
            NSLog(@"move %f, %f",0.0, 0.0);
            panTiltButton.center = CGPointMake(0.0, 0.0);
        }
        else if (touchLocation.y>positionView.bounds.size.height) {
            NSLog(@"move %f, %f",0.0, positionView.bounds.size.height);
            panTiltButton.center = CGPointMake(0.0, positionView.bounds.size.height);
        }
    }
    else if (touchLocation.x>positionView.bounds.size.width) {
        panTiltButton.center = CGPointMake(positionView.bounds.size.width, touchLocation.y);
        if (touchLocation.y<0) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, 0.0);
            panTiltButton.center = CGPointMake(positionView.bounds.size.width, 0.0);
        }
        else if (touchLocation.y>positionView.bounds.size.height) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, positionView.bounds.size.height);
            panTiltButton.center = CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height);
        }
    }
    else if (touchLocation.y<0 ) {
        panTiltButton.center = CGPointMake(touchLocation.x, 0.0);
        if (touchLocation.x<0) {
            NSLog(@"move %f, %f",0.0, 0.0);
            panTiltButton.center = CGPointMake(0.0, 0.0);
        }
        else if (touchLocation.x>positionView.bounds.size.width) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, 0.0);
            panTiltButton.center = CGPointMake(positionView.bounds.size.width, 0.0);
        }
    }
    else if (touchLocation.y>positionView.bounds.size.height) {
        panTiltButton.center = CGPointMake(touchLocation.x, positionView.bounds.size.height);
        if (touchLocation.x<0) {
            NSLog(@"move %f, %f",0.0, positionView.bounds.size.height);
            panTiltButton.center = CGPointMake(0.0, positionView.bounds.size.height);
        }
        else if (touchLocation.x>positionView.bounds.size.width) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, positionView.bounds.size.height);
            panTiltButton.center = CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height);
        }
    }
    else {
        NSLog(@"move %f, %f",touchLocation.x,touchLocation.y);
        panTiltButton.center = CGPointMake(touchLocation.x, touchLocation.y);
    }
    pan_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.x];
    tilt_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.y];
    [self setPan];
    [self setTilt];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint touchLocation = [tapGestureRecognizer locationInView:positionView];
    NSLog(@"tapScreen %f, %f",touchLocation.x,touchLocation.y);
    panTiltButton.center = touchLocation;
    pan_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.x];
    tilt_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.y];
    [self setPan];
    [self setTilt];
}

-(void)setMid:(id)sender {
    panTiltButton.center = CGPointMake(positionView.bounds.size.width/2, positionView.bounds.size.height/2);
    NSLog(@"setCenter %f,%f",panTiltButton.center.x,panTiltButton.center.y);
    pan_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.x];
    tilt_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.y];
    [self setPan];
    [self setTilt];
}

-(void)setFull:(id)sender {
    panTiltButton.center = CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height);
    NSLog(@"setFull %f,%f",panTiltButton.center.x,panTiltButton.center.y);
    pan_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.x];
    tilt_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.y];
    [self setPan];
    [self setTilt];
}

-(void)setZero:(id)sender {
    panTiltButton.center = CGPointMake(0, 0);
    NSLog(@"setZero %f,%f",panTiltButton.center.x,panTiltButton.center.y);
    pan_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.x];
    tilt_text.text = [NSString stringWithFormat:@"%d",(int)panTiltButton.center.y];
    [self setPan];
    [self setTilt];
}

-(void) panTextField {
    int newX = [pan_text.text intValue];
    panTiltButton.center = CGPointMake(newX, panTiltButton.center.y);
    NSLog(@"panTextField %f,%f",panTiltButton.center.x,panTiltButton.center.y);
    [self setPan];
    [self setTilt];
}

-(void) tiltTextField {
    int newY = [tilt_text.text intValue];
    panTiltButton.center = CGPointMake(panTiltButton.center.x, newY);
    NSLog(@"tiltTextField %f,%f",panTiltButton.center.x,panTiltButton.center.y);
    [self setPan];
    [self setTilt];
}

- (void)setPan {
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:pan_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:pan_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:pan_text.text];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

- (void)setTilt {
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:tilt_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:tilt_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:tilt_text.text];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Gobo/Litho /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)goboLitho:(UIViewController *)vc {
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// Light Color //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)initLightColor:(UIViewController *)vc {
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 60, 20)];
    colorLabel.text = @"Color";
    colorLabel.textColor = [UIColor midnightBlueColor];
    colorLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    colorLabel.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:colorLabel];
    
//    UIButton * white_button = [[UIButton alloc] initWithFrame:CGRectMake(100, 60, 50, 45)];
//    [white_button setBackgroundColor:[UIColor whiteColor]];
//    white_button.tag = 100;
//    white_button.layer.borderWidth = 3.0f;
//    white_button.layer.borderColor = [[UIColor whiteColor] CGColor];
//    white_button.layer.cornerRadius = cornerRadius;
//    [white_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
//    [vc.view addSubview:white_button];
    
    [self createButton:vc.view
                 title:@""
                   tag:401
                     x:100
                     y:60
                     w:50
                     h:45
           buttonColor:[UIColor whiteColor]
           shadowColor:[UIColor silverColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setLightColor:))];    // white
    
    [self createButton:vc.view
                 title:@""
                   tag:402
                     x:170
                     y:60
                     w:50
                     h:45
           buttonColor:[UIColor colorWithRed:0.812 green:0 blue:0.059 alpha:1]
           shadowColor:[UIColor colorWithRed:0.588 green:0.157 blue:0.106 alpha:1]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setLightColor:))];    // red
    
    [self createButton:vc.view
                 title:@""
                   tag:403
                     x:240
                     y:60
                     w:50
                     h:45
           buttonColor:[UIColor orangeColor]
           shadowColor:[UIColor pumpkinColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setLightColor:))];    // orange
    
    [self createButton:vc.view
                 title:@""
                   tag:404
                     x:310
                     y:60
                     w:50
                     h:45
           buttonColor:[UIColor yellowColor]
           shadowColor:[UIColor sunflowerColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setLightColor:))];    // yellow
    
    [self createButton:vc.view
                 title:@""
                   tag:405
                     x:380
                     y:60
                     w:50
                     h:45
           buttonColor:[UIColor greenColor]
           shadowColor:[UIColor nephritisColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setLightColor:))];    // green
    
    [self createButton:vc.view
                 title:@""
                   tag:406
                     x:450
                     y:60
                     w:50
                     h:45
           buttonColor:[UIColor colorWithRed:0.294 green:0.467 blue:0.745 alpha:1]
           shadowColor:[UIColor wetAsphaltColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(setLightColor:))];    // blue
}

-(void)setLightColor:(id)sender {
    NSLog(@"%ld",(long)((UIButton *)sender).tag);
    if (((UIButton *)sender).tag==401) {
        NSString * val = [NSString stringWithFormat:@"%d",0];
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:16
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:val];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if (((UIButton *)sender).tag==402) {
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:16
                          obj:[NSString stringWithFormat:@"%d",200]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",83]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",0]];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if (((UIButton *)sender).tag==403) {
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:16
                          obj:[NSString stringWithFormat:@"%d",90]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",100]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",0]];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if (((UIButton *)sender).tag==404) {
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:16
                          obj:[NSString stringWithFormat:@"%d",160]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",69]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",0]];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if (((UIButton *)sender).tag==405) {
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:16
                          obj:[NSString stringWithFormat:@"%d",120]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",50]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",0]];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if (((UIButton *)sender).tag==406) {
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:16
                          obj:[NSString stringWithFormat:@"%d",52]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:[NSString stringWithFormat:@"%d",108]];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:5
                          obj:[NSString stringWithFormat:@"%d",0]];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////




/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// Iris and Shutter //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)initIris:(UIViewController *)vc {
    UILabel *irisLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 20)];
    irisLabel.text = @"Iris";
    irisLabel.textColor = [UIColor midnightBlueColor];
    irisLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    irisLabel.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:irisLabel];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Open", @"Close", nil];
    FUISegmentedControl *irisSegmentedControl = [[FUISegmentedControl alloc] initWithItems:itemArray];
    irisSegmentedControl.frame = CGRectMake(100, 60, 130, 30);
    irisSegmentedControl.selectedFont = [UIFont boldFlatFontOfSize:16];
    irisSegmentedControl.selectedFontColor = [UIColor cloudsColor];
    irisSegmentedControl.deselectedFont = [UIFont flatFontOfSize:16];
    irisSegmentedControl.deselectedFontColor = [UIColor cloudsColor];
    irisSegmentedControl.selectedColor = [UIColor pumpkinColor];
    irisSegmentedControl.deselectedColor = [UIColor silverColor];
    irisSegmentedControl.disabledColor = [UIColor silverColor];
    irisSegmentedControl.dividerColor = [UIColor silverColor];
    [irisSegmentedControl addTarget:self action:@selector(irisSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    irisSegmentedControl.selectedSegmentIndex = 1;
    [vc.view addSubview:irisSegmentedControl];
}

- (void)irisSegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        NSLog(@"iris open");
        NSString * val = [NSString stringWithFormat:@"%d",255];
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:38
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:13
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:val];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        NSLog(@"iris close");
        NSString * val = [NSString stringWithFormat:@"%d",0];
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:38
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:13
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:val];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
}

-(void)initShutter:(UIViewController *)vc {
    UILabel *shutterLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 50, 60, 20)];
    shutterLabel.text = @"Shutter";
    shutterLabel.textColor = [UIColor midnightBlueColor];
    shutterLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    shutterLabel.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:shutterLabel];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Open", @"Close", nil];
    FUISegmentedControl *shutterSegmentedControl = [[FUISegmentedControl alloc] initWithItems:itemArray];
    shutterSegmentedControl.frame = CGRectMake(360, 60, 130, 30);
    shutterSegmentedControl.selectedFont = [UIFont boldFlatFontOfSize:16];
    shutterSegmentedControl.selectedFontColor = [UIColor cloudsColor];
    shutterSegmentedControl.deselectedFont = [UIFont flatFontOfSize:16];
    shutterSegmentedControl.deselectedFontColor = [UIColor cloudsColor];
    shutterSegmentedControl.selectedColor = [UIColor pumpkinColor];
    shutterSegmentedControl.deselectedColor = [UIColor silverColor];
    shutterSegmentedControl.disabledColor = [UIColor silverColor];
    shutterSegmentedControl.dividerColor = [UIColor silverColor];
    [shutterSegmentedControl addTarget:self action:@selector(shutterSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    shutterSegmentedControl.selectedSegmentIndex = 1;
    [vc.view addSubview:shutterSegmentedControl];
}

- (void)shutterSegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        NSLog(@"shutter open");
        NSString * val = [NSString stringWithFormat:@"%d",255];
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:17
                          obj:val];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        NSLog(@"shutter close");
        NSString * val = [NSString stringWithFormat:@"%d",0];
        for (int i=0; i<buttonSelected.count; i++) {
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:6
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:14
                          obj:val];
            if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
                [self setData:buttonSelected.count
                        index:[[buttonSelected objectAtIndex:i] intValue]
                           ch:17
                          obj:val];
            [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
            //NSLog(@"message%d=%@",i,message);
            [self sendUDP:message];
            message = @"";
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// Focus & Zoom /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)initFocus:(UIViewController *)vc {
    UILabel *shutterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 20)];
    shutterLabel.text = @"Focus";
    shutterLabel.textColor = [UIColor midnightBlueColor];
    shutterLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    shutterLabel.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:shutterLabel];
    
    //Create the Circular Slider
    focusSlider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(0, 30, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    
    //Define Target-Action behaviour
    [focusSlider addTarget:self action:@selector(focusValue:) forControlEvents:UIControlEventValueChanged];
    [vc.view addSubview:focusSlider];
}

-(void)focusValue:(TBCircularSlider *)slider {
    NSLog(@"Slider Value %d",255*slider.angle/360);
    
    NSString * val = [NSString stringWithFormat:@"%d",255*slider.angle/360];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:10
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:12
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:13
                      obj:val];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

-(void)initZoom:(UIViewController *)vc {
    UILabel *shutterLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 50, 60, 20)];
    shutterLabel.text = @"Zoom";
    shutterLabel.textColor = [UIColor midnightBlueColor];
    shutterLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    shutterLabel.textAlignment = NSTextAlignmentCenter;
    [vc.view addSubview:shutterLabel];
    
    //Create the Circular Slider
    zoomSlider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(250, 30, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    
    //Define Target-Action behaviour
    [zoomSlider addTarget:self action:@selector(zoomValue:) forControlEvents:UIControlEventValueChanged];
    [vc.view addSubview:zoomSlider];
}

-(void)zoomValue:(TBCircularSlider *)slider {
    NSLog(@"Slider Value %d",255*slider.angle/360);
    
    NSString * val = [NSString stringWithFormat:@"%d",255*slider.angle/360];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:11
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            continue;
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:12
                      obj:val];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)effectOffset:(UIViewController *)vc {
    
}

-(void)store:(id)sender {
    NSLog(@"store %ld",(long)((UIButton *)sender).tag);
}

-(void)clear:(id)sender {
    NSLog(@"clear %ld",(long)((UIButton *)sender).tag);
}

-(void)createButton:(UIView *)view
                           title:(NSString *)title
                          tag:(int)tag
                            x:(int)x
                            y:(int)y
                            w:(int)w
                            h:(int)h
                  buttonColor:(UIColor *)buttonColor
                  shadowColor:(UIColor *)shadowColor
                 shadowHeight:(float)shadowHeight
                   titleColor:(UIColor *)titleColor
                     selector:(NSString *)selector {
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    button.buttonColor = buttonColor;
    button.shadowColor = shadowColor;
    button.shadowHeight = shadowHeight;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

-(void)setData:(int)amount
         index:(int)index
            ch:(int)ch
           obj:(NSString *)obj{
    temp = [[device objectAtIndex:index] mutableCopy];
    [temp replaceObjectAtIndex:ch-1 withObject:obj];
    value = [temp mutableCopy];
    [device replaceObjectAtIndex:index withObject:value];
    [temp removeAllObjects];
    //NSLog(@"%@",device);
}

-(void)toString:(NSMutableArray *)deviceToString index:(int)index{
    for (int j=0; j<[[deviceToString objectAtIndex:index] count]; j++) {
        if (j==0)
            message = [message stringByAppendingString:[NSString stringWithFormat:@"*%d/%@,",index,[[device objectAtIndex:index] objectAtIndex:j]]];
        else if(j==[[device objectAtIndex:index] count]-1)
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@",[[device objectAtIndex:index] objectAtIndex:j]]];
        else
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@,",[[device objectAtIndex:index] objectAtIndex:j]]];
    }
}

-(void)dataFromPatching {
    message = @"";
    device = [[NSMutableArray alloc] init];
    value = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
    buttonSelected = [[NSMutableArray alloc] initWithObjects:@"0",@"2", nil];
    patch = [[NSMutableArray alloc] init];
    patch0 = [[NSMutableArray alloc] initWithObjects:@"0",@"a0",@"Xspot",@"1",@"38", nil];
    patch1 = [[NSMutableArray alloc] initWithObjects:@"1",@"a1",@"Xspot",@"39",@"38", nil];
    patch2 = [[NSMutableArray alloc] initWithObjects:@"2",@"c0",@"Studio250",@"77",@"18", nil];
    patch3 = [[NSMutableArray alloc] initWithObjects:@"3",@"c1",@"Studio250",@"95",@"18", nil];
    patch4 = [[NSMutableArray alloc] initWithObjects:@"4",@"c1",@"Studio250",@"113",@"18", nil];
    patch5 = [[NSMutableArray alloc] initWithObjects:@"5",@"c1",@"Studio250",@"131",@"18", nil];
    //patch6 = [[NSMutableArray alloc] initWithObjects:@"6",@"c1",@"Studio250",@"95",@"18", nil];
    [patch addObject:patch0];
    [patch addObject:patch1];
    [patch addObject:patch2];
    [patch addObject:patch3];
    [patch addObject:patch4];
    [patch addObject:patch5];
    //[patch addObject:patch6];
    for (int i=0; i<patch.count; i++) {
        for (int j=0; j<[[patch objectAtIndex:i] count]; j++) {
            if (j==0)
                message = [message stringByAppendingString:[NSString stringWithFormat:@"+%@,",[[patch objectAtIndex:i] objectAtIndex:j]]];
            else if(j==[[patch objectAtIndex:i] count]-2)
                continue;
            else if(j==[[patch objectAtIndex:i] count]-1)
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@",[[patch objectAtIndex:i] objectAtIndex:j]]];
            else
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@,",[[patch objectAtIndex:i] objectAtIndex:j]]];
        }
        [self sendUDP:message];
        message = @"";
    }
    
    for (int i=0; i<patch.count; i++) {
        for (int j=0; j<[[[patch objectAtIndex:i] objectAtIndex:4] intValue]; j++) {
            if (j==0 && j==2)
                [temp addObject:[NSString stringWithFormat:@"127"]];
            else
                [temp addObject:[NSString stringWithFormat:@"0"]];
        }
        value = [temp mutableCopy];
        [device addObject:value];
        [temp removeAllObjects];
    }
}

@end
