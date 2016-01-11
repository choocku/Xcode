//
//  ViewController.h
//  scrollBar
//
//  Created by Kittisak Chiewchoengchon on 10/23/14.
//  Copyright (c) 2014 extalion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *pan_text;
@property (weak, nonatomic) IBOutlet UITextField *tilt_text;
@property (weak, nonatomic) IBOutlet UISlider *panSlider;
@property (weak, nonatomic) IBOutlet UISlider *tiltSlider;
@property (weak, nonatomic) IBOutlet UIButton *device1;
@property (weak, nonatomic) IBOutlet UIButton *device2;
@property (weak, nonatomic) IBOutlet UIButton *device3;

@property (weak, nonatomic) IBOutlet UIButton *device4;


@property (weak, nonatomic) IBOutlet UISegmentedControl *light;

- (IBAction)panSlider:(id)sender;
- (IBAction)tiltSlider:(id)sender;
- (IBAction)button:(id)sender;
-(IBAction)indexChanged:(UISegmentedControl *)sender;

@end

