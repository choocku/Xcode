//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "DeviceViewController.h"
#import "DataClass.h"
#import "AppDelegate.h"

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
    
    // for alert view
    NSString * saveNameGroup;
    
    AppDelegate * delegate;
    DataClass *deviceClass;
    NSMutableArray * element;
    NSMutableArray *temp;
}


- (void)viewDidLoad {
    delegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    [super initMenu];
    [super initControlBar];
    // Do any additional setup after loading the view, typically from a nib.
    [self initVariables];
    [self initPatterns];
    [self initGroupDevice];
    [self setGroupDeviceButton];
    NSLog(@"%d",(int)groupView.bounds.size.width);
    
    @try {
        if (!deviceClass.deviceOnce) {
            NSData* data = [deviceClass.rev_groupdevice dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            for (int i=0; i<[[json valueForKey:@"groupdevice"]count]; i++) {
                NSMutableDictionary *response = [[[json valueForKey:@"groupdevice"] objectAtIndex:i] mutableCopy];
                //        NSLog(response.description);
                //        NSLog(@"id = %@",[response valueForKey:@"group_id"]);
                [temp addObject:[[response valueForKey:@"group_id"] mutableCopy]];
                NSMutableArray * temp2 = [[NSMutableArray alloc] init];
                for (int i=0; i<[[response valueForKey:@"device"] count]; i++) {
                    NSMutableDictionary *device = [[[response valueForKey:@"device"] objectAtIndex:i] mutableCopy];
                    //NSLog(@"%@",device);
                    [temp2 addObject:device];
                }
                [temp addObject:temp2];
                [temp addObject:[[response valueForKey:@"name"] mutableCopy]];
                [deviceClass.saveGroupDevice addObject:[temp mutableCopy]];
                [temp removeAllObjects];
            }
            deviceClass.deviceOnce = true;
            NSLog(@"groupDeviceFromDB - %@",deviceClass.saveGroupDevice);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"device didn't receive data");
    }
    
    
    if (deviceClass.saveGroupDevice.count!=0) {
        NSLog(@"GroupDevice again");
        for (int i=0; i<[deviceClass.saveGroupDevice count]; i++) {
            int savedGroupDeviceTag = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
            //NSLog(@"savedGroup tag=%d",savedGroupDeviceTag);
            [self showGroupOfDevice:savedGroupDeviceTag];
            [self showNameOfGroupOfDevice:savedGroupDeviceTag];
            //[self setSelectedGroup:savedGroupDeviceTag];
            //NSLog(@"selected=%d",selectedButton);
        }
    }
    
    NSLog(@"Device Ready");
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
    
    deviceClass = [DataClass sharedGlobalData];
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
    navbarLabel.font = [UIFont boldFlatFontOfSize:22];
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
    int column = 4;
    int row = 8;
    int x_groupDeviceButton = 6;
    int y_groupDeviceButton = 6;
    int width_groupDeviceButton = 124-x_groupDeviceButton;
    int height_groupDeviceButton = 124-y_groupDeviceButton;
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
                           selector:NSStringFromSelector(@selector(showAlertView:))
                               font:[UIFont flatFontOfSize:16]];
        }
    }
}

-(void)showAlertView:(id)sender {
    long tag = (long)((UIButton *)sender).tag;
    if (deviceClass.storeState && deviceClass.selected.count!=0) {
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Name"
                                                              message:@"Insert group name"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = FUIAlertViewStylePlainTextInput;
        [@[[alertView textFieldAtIndex:0]] enumerateObjectsUsingBlock:^(FUITextField *textField, NSUInteger idx, BOOL *stop) {
            [textField setTextFieldColor:[UIColor cloudsColor]];
            [textField setBorderColor:[UIColor asbestosColor]];
            [textField setCornerRadius:4];
            [textField setFont:[UIFont flatFontOfSize:14]];
            [textField setTextColor:[UIColor midnightBlueColor]];
        }];
        [[alertView textFieldAtIndex:0] setPlaceholder:@"Text here!"];
        
        alertView.delegate = self;
        alertView.tag = tag;
        alertView.titleLabel.textColor = [UIColor cloudsColor];
        alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        alertView.messageLabel.textColor = [UIColor cloudsColor];
        alertView.messageLabel.font = [UIFont flatFontOfSize:14];
        alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        alertView.alertContainer.layer.cornerRadius = cornerRadius;
        alertView.defaultButtonColor = [UIColor cloudsColor];
        alertView.defaultButtonShadowColor = [UIColor asbestosColor];
        alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        alertView.defaultButtonTitleColor = [UIColor asbestosColor];
        [alertView show];
    }
    else if (!deviceClass.storeState){
        @try {
            if ([[deviceClass.saveGroupDevice objectAtIndex:tag-1] count]!=0) {
                NSLog(@"in");
                for (int i=0; i<[deviceClass.saveGroupDevice count]; i++) {
                    int numberOfGroupDevice = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
                    if (tag==numberOfGroupDevice) {
                        NSLog(@"i=%d,groupDeviceTag=%ld - data%@", i, (long)tag, [deviceClass.saveGroupDevice objectAtIndex:i]);
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"don't have any information");
        }
    }
    [self showGroupOfDevice:tag];
    [self showNameOfGroupOfDevice:tag];
    //[self setSelectedGroup:tag];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        saveNameGroup = textfield.text;      // name of group device
        NSLog(@"group name=%@",saveNameGroup);
        bool same = false;
        int sameIndex = 0;
        [element addObject:[NSString stringWithFormat:@"%ld",(long)alertView.tag]];
        [element addObject:[deviceClass.selected mutableCopy]];
        [element addObject:saveNameGroup];
        if ([deviceClass.saveGroupDevice count]!=0) {
            for (int i=0; i<[deviceClass.saveGroupDevice count]; i++) {
                int numberOfGroupDevice = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
                if (alertView.tag==numberOfGroupDevice) {
                    //NSLog(@"tag=%ld,already have=%d", tag,numberOfGroupDevice);
                    same = true;
                    sameIndex = i;
                }
            }
            if (!same) {
                [deviceClass.saveGroupDevice addObject:[element mutableCopy]];
                NSLog(@"ADD save group done %@",deviceClass.saveGroupDevice);
                same = false;
            }
            else {
                [deviceClass.saveGroupDevice replaceObjectAtIndex:sameIndex withObject:[element mutableCopy]];
                NSLog(@"REPLACE save group done %@",deviceClass.saveGroupDevice);
            }
        }
        else {
            [deviceClass.saveGroupDevice addObject:[element mutableCopy]];
            NSLog(@"EMPTY_ADD save group done %@",deviceClass.saveGroupDevice);
        }
        /* create JSON form */
        NSMutableDictionary * test = [[NSMutableDictionary alloc] init];
        NSMutableArray *theArrayTest = [[NSMutableArray alloc] init];
        NSString * deviceString = @"";
        [test setObject:[element objectAtIndex:0] forKey:@"group_id"];
        for (int i=0; i<[[element objectAtIndex:1] count]; i++) {
            NSString * tempString = @"";
            if (i==[[element objectAtIndex:1]  count]-1) {
                tempString = [NSString stringWithFormat:@"%@",[[element objectAtIndex:1] objectAtIndex:i]];
                deviceString = [deviceString stringByAppendingString:tempString];
            }
            else {
                tempString = [NSString stringWithFormat:@"%@,",[[element objectAtIndex:1] objectAtIndex:i]];
                deviceString = [deviceString stringByAppendingString:tempString];
            }
        }
        [test setObject:[deviceString mutableCopy] forKey:@"device"];
        [test setObject:[element objectAtIndex:2] forKey:@"name"];
        [theArrayTest addObject:[test mutableCopy]];
        
        /* send JSON form */
        [deviceClass toString:[theArrayTest mutableCopy] thatView:@"groupdevice" action:@"add_groupdevice/"];
        
        [element removeAllObjects];
        deviceClass.storeState = false;
        NSLog(@"state = false");
    }
    [self showGroupOfDevice:alertView.tag];
    [self showNameOfGroupOfDevice:alertView.tag];
    //[self setSelectedGroup:alertView.tag];
}


-(void)setSelectedGroup:(long)tag {
    //bool colorState = false;
    NSMutableSet *common = [NSMutableSet setWithArray:deviceClass.selected];
    for (int i=0; i<[deviceClass.saveGroupDevice count]; i++) {
        NSMutableArray * tempGroupSelected = [[NSMutableArray alloc] init];
        int numberOfGroupDevice = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
        if (tag==numberOfGroupDevice) {
            tempGroupSelected = [[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:1];
            [common intersectSet:[NSSet setWithArray:tempGroupSelected]];
            NSLog(@"commonCOUNT=%i",common.count);
            //NSLog(@"tag=%ld,numberOfGroupDevice=%d,tempGroupSelected.count=%d,common=%@",tag,numberOfGroupDevice,tempGroupSelected.count,common);
            if (common.count == tempGroupSelected.count) {
                NSLog(@"tag%ld redColor",tag);
            }
        }
    }
    
}

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

-(void) showNameOfGroupOfDevice:(long)tag {
    UILabel *c = (UILabel *)(FUIButton *)[groupView viewWithTag:10000+tag];
    NSString *t = @"";
    for (int i=0; i<[deviceClass.saveGroupDevice count]; i++) {
        int numberOfGroupDevice = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
        if (tag==numberOfGroupDevice) {
            t = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:2] mutableCopy];
            c.text = t;
            //NSLog(@"10000=%@,t=%@,saveGroupDevice=%@",c.text,t,[deviceClass.saveGroupDevice objectAtIndex:i]);
            t=@"";
        }
    }
    NSLog(@"tag %ld show name!",(long)tag);
}

-(void)showGroupOfDevice:(long)tag {
    //NSLog(@"showGroupOfDevice tag%ld - DeviceClass.saveGroupDevice %@", tag, DeviceClass.saveGroupDevice);
    UILabel *c = (UILabel *)(FUIButton *)[groupView viewWithTag:100000+tag];
    NSString *t = @"";
    for (int i=0; i<[deviceClass.saveGroupDevice count]; i++) {
        int numberOfGroupDevice = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:0] intValue];
        if (tag==numberOfGroupDevice) {
            temp = [[[deviceClass.saveGroupDevice objectAtIndex:i] objectAtIndex:1] mutableCopy];
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
    NSLog(@"tag %ld show group!",(long)tag);
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
    
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(w-35, 5, 30, 20)];
    number.text = [NSString stringWithFormat:@"%d",tag];
    number.font = [UIFont flatFontOfSize:18];
    number.textColor = [UIColor cloudsColor];
    number.tag = 1000+tag;
    number.textAlignment = NSTextAlignmentRight;
    [button addSubview:number];
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(5, h/2-(25/2), w-5, 20)];
    name.text = @"";
    name.font = [UIFont flatFontOfSize:16];
    name.textColor = [UIColor cloudsColor];
    name.tag = 10000+tag;
    name.textAlignment = NSTextAlignmentCenter;
    [button addSubview:name];
    
    UILabel * group = [[UILabel alloc] initWithFrame:CGRectMake(5, h-25, w-5, 20)];
    group.text = @"";
    group.font = [UIFont flatFontOfSize:16];
    group.textColor = [UIColor cloudsColor];
    group.tag = 100000+tag;
    group.textAlignment = NSTextAlignmentCenter;
    [button addSubview:group];
}

@end
