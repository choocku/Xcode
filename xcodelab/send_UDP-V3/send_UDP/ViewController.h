//
//  ViewController.h
//  send_UDP
//
//  Created by Kittisak Chiewchoengchon on 10/10/14.
//  Copyright (c) 2014 extalion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *input;
- (IBAction)send:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *dim_text;
@property (strong, nonatomic) IBOutlet UITextField *pan_text;
@property (strong, nonatomic) IBOutlet UITextField *tilt_text;
@property (strong, nonatomic) IBOutlet UITextField *color_text;
@property (strong, nonatomic) IBOutlet UISlider *dim_slider;
@property (strong, nonatomic) IBOutlet UISlider *pan_slider;
@property (strong, nonatomic) IBOutlet UISlider *tilt_slider;
@property (strong, nonatomic) IBOutlet UISlider *color_slider;
@property (strong, nonatomic) IBOutlet UIButton *device1;
@property (strong, nonatomic) IBOutlet UIButton *device2;
@property (strong, nonatomic) IBOutlet UIButton *device3;
@property (strong, nonatomic) IBOutlet UIButton *device4;


- (IBAction)dimSlider:(id)sender;
- (IBAction)panSlider:(id)sender;
- (IBAction)tiltSlider:(id)sender;
- (IBAction)colorSlider:(id)sender;

- (IBAction)button1:(id)sender;
//- (IBAction)button2:(id)sender;
//- (IBAction)button3:(id)sender;
//- (IBAction)button4:(id)sender;



@end

