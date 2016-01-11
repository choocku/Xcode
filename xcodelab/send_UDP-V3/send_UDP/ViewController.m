//
//  ViewController.m
//  send_UDP
//
//  Created by Kittisak Chiewchoengchon on 10/10/14.
//  Copyright (c) 2014 extalion. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

long tag;
AsyncUdpSocket *udpSocket;
NSString *host = @"192.168.106.108";//@"127.0.0.1";
int port = 1024;

@implementation ViewController
{
    NSMutableArray *patch;
    NSMutableArray *patch1;
    NSMutableArray *patch2;
    NSMutableArray *patch3;
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
    
    [self.dim_text addTarget:self
                      action:@selector(dimTextField)
            forControlEvents:UIControlEventEditingChanged];
    [self.pan_text addTarget:self
                      action:@selector(panTextField)
            forControlEvents:UIControlEventEditingChanged];
    [self.tilt_text addTarget:self
                      action:@selector(tiltTextField)
            forControlEvents:UIControlEventEditingChanged];
    [self.color_text addTarget:self
                      action:@selector(colorTextField)
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
    patch2 = [[NSMutableArray alloc] initWithObjects:@"1",@"b0",@"Studio250",@"39",@"18", nil];
    patch3 = [[NSMutableArray alloc] initWithObjects:@"2",@"c0",@"CyberLight",@"57",@"20", nil];
    [patch addObject:patch1];
    [patch addObject:patch2];
    [patch addObject:patch3];
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
            [temp addObject:[NSString stringWithFormat:@"0"]];
        }
        value = [temp mutableCopy];
        [device addObject:value];
        [temp removeAllObjects];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    
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

////////////////////////////////////////////////// dim //////////////////////////////////////////////////

- (IBAction)dimSlider:(id)sender {
    //NSLog(@"%@",buttonSelected);
    self.dim_text.text = [NSString stringWithFormat:@"%d",(int)((UISlider *)sender).value];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:self.dim_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:self.dim_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:self.dim_text.text];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue] ];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
        //NSLog(@"startAt=%d",[[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:3 ] intValue]);
        //NSLog(@"type=%@",[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ]);
        //NSLog(@"buttonTag=%d",[[buttonSelected objectAtIndex:i] intValue]);
        //NSLog(@"deviceID=%d",[[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:0 ]intValue]-1);
    }
}

- (void)dimTextField {
    self.dim_slider.value = [self.dim_text.text intValue];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:[NSString stringWithFormat:@"%d",(int)self.dim_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:[NSString stringWithFormat:@"%d",(int)self.dim_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:1
                      obj:[NSString stringWithFormat:@"%d",(int)self.dim_slider.value]];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

////////////////////////////////////////////////// pan //////////////////////////////////////////////////

- (IBAction)panSlider:(id)sender {
    self.pan_text.text = [NSString stringWithFormat:@"%d",(int)((UISlider *)sender).value];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:2
                      obj:self.pan_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:2
                      obj:self.pan_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:2
                      obj:self.pan_text.text];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

- (void)panTextField {
    self.pan_slider.value = [self.pan_text.text intValue];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:2
                      obj:[NSString stringWithFormat:@"%d",(int)self.pan_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:2
                      obj:[NSString stringWithFormat:@"%d",(int)self.pan_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:2
                      obj:[NSString stringWithFormat:@"%d",(int)self.pan_slider.value]];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

////////////////////////////////////////////////// tilt //////////////////////////////////////////////////

- (IBAction)tiltSlider:(id)sender {
    self.tilt_text.text = [NSString stringWithFormat:@"%d",(int)((UISlider *)sender).value];
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
    self.tilt_slider.value = [self.tilt_text.text intValue];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:[NSString stringWithFormat:@"%d",(int)self.tilt_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:[NSString stringWithFormat:@"%d",(int)self.tilt_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:3
                      obj:[NSString stringWithFormat:@"%d",(int)self.tilt_slider.value]];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

////////////////////////////////////////////////// color //////////////////////////////////////////////////

- (IBAction)colorSlider:(id)sender {
    self.color_text.text = [NSString stringWithFormat:@"%i",(int)((UISlider *)sender).value];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:4
                      obj:self.color_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:4
                      obj:self.color_text.text];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:4
                      obj:self.color_text.text];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
        //NSLog(@"startAt=%d",[[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:3 ] intValue]);
        //NSLog(@"type=%@",[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ]);
        //NSLog(@"buttonTag=%d",[[buttonSelected objectAtIndex:i] intValue]);
        //NSLog(@"deviceID=%d",[[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:0 ]intValue]-1);
    }
}

- (void)colorTextField {
    self.color_slider.value = [self.color_text.text intValue];
    for (int i=0; i<buttonSelected.count; i++) {
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Xspot"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:4
                      obj:[NSString stringWithFormat:@"%d",(int)self.color_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"Studio250"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:4
                      obj:[NSString stringWithFormat:@"%d",(int)self.color_slider.value]];
        if([[ [ patch objectAtIndex:[[buttonSelected objectAtIndex:i] intValue] ] objectAtIndex:2 ] isEqual:@"CyberLight"])
            [self setData:buttonSelected.count
                    index:[[buttonSelected objectAtIndex:i] intValue]
                       ch:4
                      obj:[NSString stringWithFormat:@"%d",(int)self.color_slider.value]];
        [self toString:device index:[[buttonSelected objectAtIndex:i] intValue]];
        //NSLog(@"message%d=%@",i,message);
        [self sendUDP:message];
        message = @"";
    }
}

- (IBAction)button1:(id)sender {
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

@end
