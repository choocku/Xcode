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
NSString *host = @"192.168.106.120";//@"127.0.0.1";
int port = 1024;

@implementation ViewController
{
    NSMutableArray *patch;
    NSMutableArray *patch1;
    NSMutableArray *patch2;
    NSMutableArray *patch3;
    NSMutableArray *patch4;
    NSMutableArray *device;
    NSMutableArray *value;
    NSMutableArray *temp;
    NSMutableArray *buttonSelected;
    NSString * message;
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
    [_scroll setContentSize:CGSizeMake(2800, 300)];
    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    //self.slider1.transform = trans;
    self.tiltSlider.transform = trans;

    
    //self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    
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
    
    
    
    [self.pan_text addTarget:self
                      action:@selector(panTextField)
            forControlEvents:UIControlEventEditingChanged];
    [self.tilt_text addTarget:self
                       action:@selector(tiltTextField)
             forControlEvents:UIControlEventEditingChanged];
    [self.device1 addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.device2 addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.device3 addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.device4 addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    message = @"";
    device = [[NSMutableArray alloc] init];
    value = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
    buttonSelected = [[NSMutableArray alloc] init];
    patch = [[NSMutableArray alloc] init];
    patch1 = [[NSMutableArray alloc] initWithObjects:@"0",@"a0",@"Xspot",@"1",@"38", nil];
    patch2 = [[NSMutableArray alloc] initWithObjects:@"1",@"a1",@"Xspot",@"39",@"38", nil];
    patch3 = [[NSMutableArray alloc] initWithObjects:@"2",@"c0",@"Studio250",@"77",@"18", nil];
    patch4 = [[NSMutableArray alloc] initWithObjects:@"3",@"c1",@"Studio250",@"95",@"18", nil];
    [patch addObject:patch1];
    [patch addObject:patch2];
    [patch addObject:patch3];
    [patch addObject:patch4];
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
    
    [_scroll addSubview:dimer];
    [_scroll addSubview:iris];
    [_scroll addSubview:focus];
    [_scroll addSubview:shutter];
    [_scroll addSubview:effect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)panSlider:(id)sender {
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)self.panSlider.value];
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

- (void)panTextField {
    self.panSlider.value = [self.pan_text.text intValue];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:[NSString stringWithFormat:@"%d",(int)self.panSlider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:[NSString stringWithFormat:@"%d",(int)self.panSlider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:[NSString stringWithFormat:@"%d",(int)self.panSlider.value]];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

- (IBAction)tiltSlider:(id)sender {
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)self.tiltSlider.value];
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

- (void)tiltTextField {
    self.tiltSlider.value = [self.tilt_text.text intValue];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:[NSString stringWithFormat:@"%d",(int)self.tiltSlider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:[NSString stringWithFormat:@"%d",(int)self.tiltSlider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:[NSString stringWithFormat:@"%d",(int)self.tiltSlider.value]];
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

-(IBAction)indexChanged:(UISegmentedControl *)sender
{
    switch (self.light.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"ON");
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
            break;
        case 1:
            NSLog(@"OFF");
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
            break;
        default: 
            break; 
    } 
}

- (IBAction)button:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    if(((UIButton *)sender).selected)
        [buttonSelected addObject:[NSNumber numberWithInt:(int)((UIButton *)sender).tag-1]];
    else {
        [buttonSelected removeObjectIdenticalTo:[NSNumber numberWithInt:(int)((UIButton *)sender).tag-1]];
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

@end
