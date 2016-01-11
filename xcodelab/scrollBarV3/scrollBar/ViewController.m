//
//  ViewController.m
//  scrollBar
//
//  Created by Kittisak Chiewchoengchon on 10/23/14.
//  Copyright (c) 2014 extalion. All rights reserved.
//

#import "ViewController.h"
#import "TBCircularSlider.h"
#import "AsyncUdpSocket.h"

@interface ViewController ()

@end

long tag;
AsyncUdpSocket *udpSocket;
NSString *host = @"172.16.0.148";//@"127.0.0.1";
int port = 1024;

@implementation ViewController
{
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
    
    UIView * positionView;
    UIButton *b;
    UIBezierPath *path;
    UIBezierPath *path2;
    float cornerRadius;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    
    [udpSocket receiveWithTimeout:-1 tag:0];
    
    NSLog(@"Ready");
    
    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(2230, 300)];

    cornerRadius = 9.0f;
    self.view.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1]; /*#ecf0f1*/
    
    
    [self dataFromPatching];
    
    [self initPanTilt];
    
    UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectMake(370, 70, 0, 0)];
    [onoff addTarget: self action: @selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [_scroll addSubview:onoff];
    
    [self initLightColor];
    
    [self initTBCircularSlider];
    
    [self.pan_text addTarget:self
                      action:@selector(panTextField)
            forControlEvents:UIControlEventEditingChanged];
    [self.tilt_text addTarget:self
                       action:@selector(tiltTextField)
             forControlEvents:UIControlEventEditingChanged];
    
    [self initButtonInLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initButtonInLayout {
    for (int i=0; i<[patch count]; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i*60+10, 30, 50, 50)];
        button.tag = i+1;
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)button.tag] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1];
        button.layer.borderColor = [[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] CGColor];
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        button.layer.borderWidth = 3.0f;
        button.layer.cornerRadius = 9.0f;
        [self.view addSubview:button];
    }
}

-(void)dataFromPatching {
    message = @"";
    device = [[NSMutableArray alloc] init];
    value = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
    buttonSelected = [[NSMutableArray alloc] init];
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

-(void)initPanTilt {
    positionView = [[UIView alloc] initWithFrame:CGRectMake(25, 130, 255, 255)];
    positionView.backgroundColor = [UIColor colorWithRed:0.498 green:0.549 blue:0.553 alpha:1];
    positionView.layer.borderWidth = 2.0f;
    positionView.layer.borderColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1].CGColor;
    [_scroll addSubview:positionView];
    
    UIButton * zeros_b = [[UIButton alloc] initWithFrame:CGRectMake(300, 180, 80, 30)];
    zeros_b.backgroundColor = [UIColor colorWithRed:0.584 green:0.647 blue:0.651 alpha:1];
    zeros_b.layer.cornerRadius = cornerRadius;
    [zeros_b setTitle:@"0,0" forState:UIControlStateNormal];
    [zeros_b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zeros_b addTarget:self action:@selector(setZero:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:zeros_b];
    
    UIButton * center_b = [[UIButton alloc] initWithFrame:CGRectMake(300, 250, 80, 30)];
    center_b.backgroundColor = [UIColor colorWithRed:0.584 green:0.647 blue:0.651 alpha:1];
    center_b.layer.cornerRadius = cornerRadius;
    [center_b setTitle:@"127,127" forState:UIControlStateNormal];
    [center_b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [center_b addTarget:self action:@selector(setMid:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:center_b];
    
    UIButton * full_b = [[UIButton alloc] initWithFrame:CGRectMake(300, 320, 80, 30)];
    full_b.backgroundColor = [UIColor colorWithRed:0.584 green:0.647 blue:0.651 alpha:1];
    full_b.layer.cornerRadius = cornerRadius;
    [full_b setTitle:@"255,255" forState:UIControlStateNormal];
    [full_b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [full_b addTarget:self action:@selector(setFull:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:full_b];
    
    
    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    b.backgroundColor = [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:1];
    b.layer.cornerRadius = 10.0f;
    [positionView addSubview:b];
    
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
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [positionView addGestureRecognizer:panGestureRecognizer];
    [positionView addGestureRecognizer:tapGestureRecognizer];
}

-(void)initLightColor {
    UIButton * white_button = [[UIButton alloc] initWithFrame:CGRectMake(797, 121, 54, 45)];
    [white_button setBackgroundColor:[UIColor whiteColor]];
    white_button.tag = 100;
    white_button.layer.borderWidth = 3.0f;
    white_button.layer.borderColor = [[UIColor whiteColor] CGColor];
    white_button.layer.cornerRadius = cornerRadius;
    [white_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:white_button];
    
    UIButton * red_button = [[UIButton alloc] initWithFrame:CGRectMake(886, 121, 54, 45)];
    [red_button setBackgroundColor:[UIColor redColor]];
    red_button.tag = 101;
    red_button.layer.borderWidth = 3.0f;
    red_button.layer.borderColor = [[UIColor redColor] CGColor];
    red_button.layer.cornerRadius = cornerRadius;
    [red_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:red_button];
    
    UIButton * orange_button = [[UIButton alloc] initWithFrame:CGRectMake(797, 191, 54, 45)];
    [orange_button setBackgroundColor:[UIColor orangeColor]];
    orange_button.tag = 102;
    orange_button.layer.borderWidth = 3.0f;
    orange_button.layer.borderColor = [[UIColor orangeColor] CGColor];
    orange_button.layer.cornerRadius = cornerRadius;
    [orange_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:orange_button];
    
    UIButton * yellow_button = [[UIButton alloc] initWithFrame:CGRectMake(886, 191, 54, 45)];
    [yellow_button setBackgroundColor:[UIColor yellowColor]];
    yellow_button.tag = 103;
    yellow_button.layer.borderWidth = 3.0f;
    yellow_button.layer.borderColor = [[UIColor yellowColor] CGColor];
    yellow_button.layer.cornerRadius = cornerRadius;
    [yellow_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:yellow_button];
    
    UIButton * green_button = [[UIButton alloc] initWithFrame:CGRectMake(797, 261, 54, 45)];
    [green_button setBackgroundColor:[UIColor greenColor]];
    green_button.tag = 104;
    green_button.layer.borderWidth = 3.0f;
    green_button.layer.borderColor = [[UIColor greenColor] CGColor];
    green_button.layer.cornerRadius = cornerRadius;
    [green_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:green_button];
    
    UIButton * blue_button = [[UIButton alloc] initWithFrame:CGRectMake(886, 261, 54, 45)];
    [blue_button setBackgroundColor:[UIColor blueColor]];
    blue_button.tag = 105;
    blue_button.layer.borderWidth = 3.0f;
    blue_button.layer.borderColor = [[UIColor blueColor] CGColor];
    blue_button.layer.cornerRadius = cornerRadius;
    [blue_button addTarget:self action:@selector(setLightColor:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:blue_button];
}

-(void)initTBCircularSlider {
    //Create the Circular Slider
    TBCircularSlider *dimer = [[TBCircularSlider alloc]initWithFrame:CGRectMake(400, 100, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    //Define Target-Action behaviour
    [dimer addTarget:self action:@selector(dimValue:) forControlEvents:UIControlEventValueChanged];
    
    TBCircularSlider *iris = [[TBCircularSlider alloc]initWithFrame:CGRectMake(1000, 100, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    //Define Target-Action behaviour
    [iris addTarget:self action:@selector(irisValue:) forControlEvents:UIControlEventValueChanged];
    
    TBCircularSlider *focus = [[TBCircularSlider alloc]initWithFrame:CGRectMake(1300, 100, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    //Define Target-Action behaviour
    [focus addTarget:self action:@selector(focusValue:) forControlEvents:UIControlEventValueChanged];
    
    TBCircularSlider *shutter = [[TBCircularSlider alloc]initWithFrame:CGRectMake(1600, 100, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    //Define Target-Action behaviour
    [shutter addTarget:self action:@selector(shutterValue:) forControlEvents:UIControlEventValueChanged];
    
    TBCircularSlider *effect = [[TBCircularSlider alloc]initWithFrame:CGRectMake(1900, 100, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    //Define Target-Action behaviour
    [effect addTarget:self action:@selector(effectValue:) forControlEvents:UIControlEventValueChanged];
    
    [_scroll addSubview:dimer];
    [_scroll addSubview:iris];
    [_scroll addSubview:focus];
    [_scroll addSubview:shutter];
    [_scroll addSubview:effect];
}

-(void) panTextField {
    int newX = [self.pan_text.text intValue];
    b.center = CGPointMake(newX, b.center.y);
    NSLog(@"panTextField %f,%f",b.center.x,b.center.y);
    [self setPan];
    [self setTilt];
}

-(void) tiltTextField {
    int newY = [self.tilt_text.text intValue];
    b.center = CGPointMake(b.center.x, newY);
    NSLog(@"tiltTextField %f,%f",b.center.x,b.center.y);
    [self setPan];
    [self setTilt];
}

- (void)setPan {
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:self.pan_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:self.pan_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:self.pan_text.text];
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
                      obj:self.tilt_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:self.tilt_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:self.tilt_text.text];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

/** This function is called when Circular slider value changes **/
-(void)dimValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    //NSLog(@"Slider Value %d",255*slider.angle/360);
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

-(void)setLightColor:(id)sender {
    NSLog(@"%ld",(long)((UIButton *)sender).tag);
    if (((UIButton *)sender).tag==100) {
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
    else if (((UIButton *)sender).tag==101) {
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
    else if (((UIButton *)sender).tag==102) {
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
    else if (((UIButton *)sender).tag==103) {
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
    else if (((UIButton *)sender).tag==104) {
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
    else if (((UIButton *)sender).tag==105) {
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

/** This function is called when Circular slider value changes **/
-(void)irisValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    //NSLog(@"Slider Value %d",255*slider.angle/360);
    NSString * val = [NSString stringWithFormat:@"%d",255*slider.angle/360];
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

/** This function is called when Circular slider value changes **/
-(void)focusValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    //NSLog(@"Slider Value %d",255*slider.angle/360);
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

/** This function is called when Circular slider value changes **/
-(void)shutterValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    //NSLog(@"Slider Value %d",255*slider.angle/360);
    NSString * val = [NSString stringWithFormat:@"%d",255*slider.angle/360];
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

/** This function is called when Circular slider value changes **/
-(void)effectValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
    //NSLog(@"Slider Value %d",255*slider.angle/360);
    NSString * val = [NSString stringWithFormat:@"%d",255*slider.angle/360];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:29
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:10
                      obj:val];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:15
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

- (void)button:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    if(((UIButton *)sender).selected) {
        [buttonSelected addObject:[NSNumber numberWithInt:(int)((UIButton *)sender).tag-1]];
        ((UIButton *)sender).layer.borderColor = [[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1] CGColor]; /*#2ecc71*/
    }
    else {
        [buttonSelected removeObjectIdenticalTo:[NSNumber numberWithInt:(int)((UIButton *)sender).tag-1]];
        ((UIButton *)sender).layer.borderColor = [[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] CGColor]; /*#2ecc71*/
    }
    NSLog(@"%@",buttonSelected);
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
    button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
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

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint touchLocation = [panGestureRecognizer locationInView:positionView];
    b.center = touchLocation;
    [path addLineToPoint:CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height)];
    if (touchLocation.x<0 ) {
        b.center = CGPointMake(0.0, touchLocation.y);
        if (touchLocation.y<0) {
            NSLog(@"move %f, %f",0.0, 0.0);
            b.center = CGPointMake(0.0, 0.0);
        }
        else if (touchLocation.y>positionView.bounds.size.height) {
            NSLog(@"move %f, %f",0.0, positionView.bounds.size.height);
            b.center = CGPointMake(0.0, positionView.bounds.size.height);
        }
    }
    else if (touchLocation.x>positionView.bounds.size.width) {
        b.center = CGPointMake(positionView.bounds.size.width, touchLocation.y);
        if (touchLocation.y<0) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, 0.0);
            b.center = CGPointMake(positionView.bounds.size.width, 0.0);
        }
        else if (touchLocation.y>positionView.bounds.size.height) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, positionView.bounds.size.height);
            b.center = CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height);
        }
    }
    else if (touchLocation.y<0 ) {
        b.center = CGPointMake(touchLocation.x, 0.0);
        if (touchLocation.x<0) {
            NSLog(@"move %f, %f",0.0, 0.0);
            b.center = CGPointMake(0.0, 0.0);
        }
        else if (touchLocation.x>positionView.bounds.size.width) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, 0.0);
            b.center = CGPointMake(positionView.bounds.size.width, 0.0);
        }
    }
    else if (touchLocation.y>positionView.bounds.size.height) {
        b.center = CGPointMake(touchLocation.x, positionView.bounds.size.height);
        if (touchLocation.x<0) {
            NSLog(@"move %f, %f",0.0, positionView.bounds.size.height);
            b.center = CGPointMake(0.0, positionView.bounds.size.height);
        }
        else if (touchLocation.x>positionView.bounds.size.width) {
            NSLog(@"move %f, %f",positionView.bounds.size.width, positionView.bounds.size.height);
            b.center = CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height);
        }
    }
    else {
        NSLog(@"move %f, %f",touchLocation.x,touchLocation.y);
        b.center = CGPointMake(touchLocation.x, touchLocation.y);
    }
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)b.center.x];
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)b.center.y];
    [self setPan];
    [self setTilt];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint touchLocation = [tapGestureRecognizer locationInView:positionView];
    NSLog(@"tapScreen %f, %f",touchLocation.x,touchLocation.y);
    b.center = touchLocation;
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)b.center.x];
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)b.center.y];
    [self setPan];
    [self setTilt];
}

-(void)setMid:(id)sender {
    b.center = CGPointMake(positionView.bounds.size.width/2, positionView.bounds.size.height/2);
    NSLog(@"setCenter %f,%f",b.center.x,b.center.y);
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)b.center.x];
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)b.center.y];
    [self setPan];
    [self setTilt];
}

-(void)setFull:(id)sender {
    b.center = CGPointMake(positionView.bounds.size.width, positionView.bounds.size.height);
    NSLog(@"setFull %f,%f",b.center.x,b.center.y);
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)b.center.x];
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)b.center.y];
    [self setPan];
    [self setTilt];
}

-(void)setZero:(id)sender {
    b.center = CGPointMake(0, 0);
    NSLog(@"setZero %f,%f",b.center.x,b.center.y);
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)b.center.x];
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)b.center.y];
    [self setPan];
    [self setTilt];
}

@end
