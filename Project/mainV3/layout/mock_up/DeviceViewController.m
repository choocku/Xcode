//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "DeviceViewController.h"
#import "DataClass.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController {
    float cornerRadius;
    
    // nav bar
    int x_navbar;
    int y_navbar;
    int width_navbar;
    int height_navbar;
    
    // nav bar label
    int y_navbarLabel;
    int width_navbarLabel;
    int height_navbarLabel;
    
    // group device
    UIView *groupView;
    UIScrollView *myScroll;
    int x_groupView;
    int y_groupView;
    int width_groupView;
    int height_groupView;
    
    DataClass *DeviceClass;
    NSMutableArray * element;
    NSMutableArray *temp;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [super initMenu];
    [super initControlBar];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Device Ready");
    [self initVariables];
    [self initPatterns];
    [self initGroupDevice];
    [self setGroupDeviceButton];
    NSLog(@"%d",(int)groupView.bounds.size.width);
    
    if (DeviceClass.saveGroupDevice.count!=0) {
        NSLog(@"GroupDevice again");
        for (int i=0; i<[DeviceClass.saveGroupDevice count]; i++) {
            int savedGroupDevice = [[[DeviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
            NSLog(@"savedGroup tag=%d",savedGroupDevice);
            [self showGroupOfDevice:savedGroupDevice];
            //NSLog(@"selected=%d",selectedButton);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initVariables {
    cornerRadius = 9.0f;       // layer.cornerRadius
    
    // parameter of navigation bar
    x_navbar = 10;
    y_navbar = 20;
    width_navbar = [UIScreen mainScreen].bounds.size.width-(10*2);
    height_navbar = 44;
    
    // parameter of navbarLabel
    y_navbarLabel = 0;
    width_navbarLabel = 150;
    height_navbarLabel = 44;
    
    x_groupView = 10;
    y_groupView = 74;
    width_groupView = (self.view.bounds.size.width-20)/2;
    height_groupView = 600;
    
    DeviceClass = [DataClass sharedGlobalData];
    element = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
}

-(void)initPatterns {
    self.view.backgroundColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1];
    
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(x_navbar, y_navbar, width_navbar, height_navbar)];
    navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    navbar.layer.cornerRadius = cornerRadius;
    navbar.layer.masksToBounds = YES;
    [self.view addSubview:navbar];
    
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake( navbar.center.x-60, y_navbarLabel, width_navbarLabel, height_navbarLabel)];
    navbarLabel.text = @"  Device";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont boldFlatFontOfSize:25];
    [navbar addSubview:navbarLabel];
    
    // init layout view
    groupView = [[UIView alloc] initWithFrame:CGRectMake( x_groupView, y_groupView,width_groupView, height_groupView)];
    groupView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    groupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    groupView.layer.cornerRadius = cornerRadius;
    groupView.layer.masksToBounds = YES;
    [self.view addSubview:groupView];
}

-(void)initGroupDevice {
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, groupView.bounds.size.width, height_navbar-10)];
    //navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    [navbar configureFlatNavigationBarWithColor:[UIColor sunflowerColor]];
    navbar.layer.cornerRadius = cornerRadius;
    navbar.layer.masksToBounds = YES;
    [groupView addSubview:navbar];
    
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, y_navbarLabel-4, width_navbarLabel, height_navbarLabel-5)];
    navbarLabel.text = @"Group Device";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont boldFlatFontOfSize:20];
    [navbar addSubview:navbarLabel];
    
    
    myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 34, groupView.bounds.size.width, groupView.bounds.size.height)];
    myScroll.contentSize = CGSizeMake(groupView.bounds.size.width, 1100);   //scroll view size
    myScroll.backgroundColor = [UIColor clearColor];
    myScroll.showsVerticalScrollIndicator = NO;    // to hide scroll indicators!
    myScroll.showsHorizontalScrollIndicator = YES; //by default, it shows!
    myScroll.scrollEnabled = YES;                 //say "NO" to disable scroll
    [groupView addSubview:myScroll];               //adding to parent view!
}

-(void)setGroupDeviceButton {
    int column = 5;
    int row = 10;
    int x_groupDeviceButton = 6;
    int y_groupDeviceButton = 6;
    int width_groupDeviceButton = 99-x_groupDeviceButton;
    int height_groupDeviceButton = 99-y_groupDeviceButton;
    for (int i=0; i<row; i++) {
        for (int j=0; j<column; j++) {
            [self createGroupButton:myScroll
                              title:@""
                                tag:(i*column)+j+1
                                  x:x_groupDeviceButton+((width_groupDeviceButton+x_groupDeviceButton)*j)
                                  y:y_groupDeviceButton+((height_groupDeviceButton+y_groupDeviceButton)*i)
                                  w:width_groupDeviceButton
                                  h:height_groupDeviceButton
                        buttonColor:[UIColor turquoiseColor]
                        shadowColor:[UIColor greenSeaColor]
                       shadowHeight:3.0f
                         titleColor:[UIColor cloudsColor]
                           selector:NSStringFromSelector(@selector(test:))
                               font:[UIFont flatFontOfSize:16]];
        }
    }
}

-(void)test:(id)sender {
    long tag = (long)((UIButton *)sender).tag;
    bool same = false;
    int sameIndex = 0;
    if (DeviceClass.storeState && DeviceClass.selected.count!=0) {
        [element addObject:[NSString stringWithFormat:@"%ld",tag]];
        [element addObject:[DeviceClass.selected mutableCopy]];
        [element addObject:[NSString stringWithFormat:@"%@",((UIButton *)sender).titleLabel.text]];
        if ([DeviceClass.saveGroupDevice count]!=0) {
            for (int i=0; i<[DeviceClass.saveGroupDevice count]; i++) {
                int numberOfGroupDevice = [[[DeviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
                if (tag==numberOfGroupDevice) {
                    //NSLog(@"tag=%ld,already have=%d", tag,numberOfGroupDevice);
                    same = true;
                    sameIndex = i;
                }
            }
            if (!same) {
                [DeviceClass.saveGroupDevice addObject:[element mutableCopy]];
                NSLog(@"ADD save group done %@",DeviceClass.saveGroupDevice);
                same = false;
            }
            else {
                [DeviceClass.saveGroupDevice replaceObjectAtIndex:sameIndex withObject:[element mutableCopy]];
                NSLog(@"REPLACE save group done %@",DeviceClass.saveGroupDevice);
            }
        }
        else {
            [DeviceClass.saveGroupDevice addObject:[element mutableCopy]];
            NSLog(@"EMPTY_ADD save group done %@",DeviceClass.saveGroupDevice);
        }
        [element removeAllObjects];
        DeviceClass.storeState = false;
        NSLog(@"state = false");
    }
    else if (!DeviceClass.storeState){
        if ([DeviceClass.saveGroupDevice count]!=0) {
            for (int i=0; i<[DeviceClass.saveGroupDevice count]; i++) {
                int numberOfGroupDevice = [[[DeviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
                if (tag==numberOfGroupDevice) {
                    NSLog(@"group=%ld - data%@", tag, [DeviceClass.saveGroupDevice objectAtIndex:i]);
                }
            }
        }
        else {
            NSLog(@"don't have any information");
        }
    }
    [self showGroupOfDevice:tag];
    //[self setSelectedGroup:tag];
    //[self setSelectedGroup];
}
/*
-(void)setSelectedGroup {
    bool colorState = false;
    NSMutableSet *common = [NSMutableSet setWithArray:DeviceClass.selected];
    for (int i=0; i<[DeviceClass.saveGroupDevice count]; i++) {
        [common intersectSet:[NSSet setWithArray:[[DeviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:1]]];
        NSLog(@"common intersect(%d)=%i", i, common.count);
    }
}
*/
/*
-(void)setSelectedGroup:(long)tag {
    FUIButton *groupNumber_hasselect = (FUIButton *)[groupView viewWithTag:tag];
    UILabel *number_hasselect = (UILabel *)(FUIButton *)[groupView viewWithTag:1000+tag];
    UILabel *name_hasselect = (UILabel *)(FUIButton *)[groupView viewWithTag:10000+tag];
    UILabel *group_hasselect = (UILabel *)(FUIButton *)[groupView viewWithTag:100000+tag];
    NSLog(@"number=%@, name=%@, group=%@", number_hasselect.text, name_hasselect.text, group_hasselect.text);
    [groupNumber_hasselect setSelected:YES];
    if(groupNumber_hasselect.selected) {
        //NSLog(@"setColor %d",hasSelected.tag);
        number_hasselect.textColor = [UIColor redColor];
        name_hasselect.textColor = [UIColor redColor];
        group_hasselect.textColor = [UIColor redColor];
    }
}
*/
-(void)showGroupOfDevice:(long)tag {
    //NSLog(@"showGroupOfDevice tag%ld - DeviceClass.saveGroupDevice %@", tag, DeviceClass.saveGroupDevice);
    UILabel *c = (UILabel *)(FUIButton *)[groupView viewWithTag:100000+tag];
    NSString *t = @"";
    for (int i=0; i<[DeviceClass.saveGroupDevice count]; i++) {
        int numberOfGroupDevice = [[[DeviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
        if (tag==numberOfGroupDevice) {
            temp = [[[DeviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:1] mutableCopy];
            //NSLog(@"temp=%@",temp);
            for (int j=0; j<[temp count]; j++) {
                if(j==[temp count]-1)
                    t= [t stringByAppendingString:[NSString stringWithFormat:@"%@",[temp objectAtIndex:j]]];
                else
                    t= [t stringByAppendingString:[NSString stringWithFormat:@"%@,",[temp objectAtIndex:j]]];
            }
            c.text = t;
            //NSLog(@"%@,10000=%@,t=%@",c.text,temp,t);
            t=@"";
        }
    }
    NSLog(@"show group!");
}

-(void)createGroupButton:(UIView *)view
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
           selector:(NSString *)selector
               font:(UIFont *)font {
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    button.buttonColor = buttonColor;
    button.shadowColor = shadowColor;
    button.shadowHeight = shadowHeight;
    button.cornerRadius = 9.0f;
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(w-30, 5, 25, 15)];
    number.text = [NSString stringWithFormat:@"%d",tag];
    number.font = [UIFont flatFontOfSize:14];
    number.textColor = [UIColor cloudsColor];
    number.tag = 1000+tag;
    number.textAlignment = NSTextAlignmentRight;
    [button addSubview:number];
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(5, h/2-(15/2), w-5, 15)];
    name.text = @"";
    name.font = [UIFont flatFontOfSize:14];
    name.textColor = [UIColor cloudsColor];
    name.tag = 10000+tag;
    name.textAlignment = NSTextAlignmentCenter;
    [button addSubview:name];
    
    UILabel * group = [[UILabel alloc] initWithFrame:CGRectMake(5, h-20, w-5, 15)];
    group.text = @"";
    group.font = [UIFont flatFontOfSize:14];
    group.textColor = [UIColor cloudsColor];
    group.tag = 100000+tag;
    group.textAlignment = NSTextAlignmentCenter;
    [button addSubview:group];
}

@end
