//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "AllPresetViewController.h"
#import "DataClass.h"

@interface AllPresetViewController () 

@end

@implementation AllPresetViewController {
    float cornerRadius;
    
    // nav bar
    int xNavbar;
    int yNavbar;
    int widthNavbar;
    int heightNavbar;
    
    // nav bar label
    int yNavbarLabel;
    int widthNavbarLabel;
    int heightNavbarLabel;
    
    // all preset view
    UIView *allPresetView;
    UIScrollView *myScroll;
    int xAllPresetView;
    int yAllPresetView;
    int widthAllPresetView;
    int heightAllPresetView;
    
    DataClass *allPresetClass;
    NSMutableArray * element;
    NSMutableArray *temp;
    
    NSString * savedAllPresetName;
    AppDelegate * delegate;
}


- (void)viewDidLoad {
    delegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    [super initMenu];
    [super initControlBar];
    // Do any additional setup after loading the view, typically from a nib.
    [self initVariables];
    [self initPatterns];
    [self initAllPreset];
    [self setAllPresetButton];
    NSLog(@"%d",(int)allPresetView.bounds.size.width);
    
    @try {
        if (!allPresetClass.allPresetOnce) {
            NSData* data = [allPresetClass.rev_allpreset dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            for (int i=0; i<[[json valueForKey:@"allpreset"]count]; i++) {
                NSMutableDictionary *response = [[[json valueForKey:@"allpreset"] objectAtIndex:i] mutableCopy];
                
                [temp addObject:[[response valueForKey:@"preset_id"] mutableCopy]];
                [temp addObject:[[response valueForKey:@"name"] mutableCopy]];
                
                for (int i=5; i<[allPresetClass.nameCH count]; i++) {
                    NSString * nameChannelAtIndex = [NSString stringWithFormat:@"%@",[allPresetClass.nameCH objectAtIndex:i]];
                    NSMutableDictionary *device = [[response valueForKey:nameChannelAtIndex] mutableCopy];
                    NSLog(@"name channel =%@, value = %@",nameChannelAtIndex,device);
                    [temp addObject:device];
                }
                
                [allPresetClass.savedAllPreset addObject:[temp mutableCopy]];
                [temp removeAllObjects];
            }
            allPresetClass.allPresetOnce = true;
            NSLog(@"allPresetFromDB - %@",allPresetClass.savedAllPreset);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"All Preset didn't receive data");
    }
    
    
    if (allPresetClass.savedAllPreset.count!=0) {
        NSLog(@"All Preset again");
        for (int i=0; i<[allPresetClass.savedAllPreset count]; i++) {
            int savedAllPresetTag =[[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:0] intValue];
            NSLog(@"savedAllPreset tag=%d",savedAllPresetTag);
            [self showNameOfAllPreset:savedAllPresetTag];
            //[self setSelectedGroup:savedAllPresetTag];
            //NSLog(@"selected=%d",selectedButton);
        }
    }
    NSLog(@"All Preset Ready");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initVariables {
    cornerRadius = 9.0f;       // layer.cornerRadius
    
    // parameter of navigation bar
    xNavbar = 10;
    yNavbar = 20;
    widthNavbar = [UIScreen mainScreen].bounds.size.width-(10*2);
    heightNavbar = 44;
    
    // parameter of navbarLabel
    yNavbarLabel = 0;
    widthNavbarLabel = 150;
    heightNavbarLabel = 44;
    
    xAllPresetView = 10;
    yAllPresetView = 74;
    widthAllPresetView = self.view.bounds.size.width-20;
    heightAllPresetView = 600;
    
    allPresetClass = [DataClass sharedGlobalData];
    element = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
}

-(void)initPatterns {
    self.view.backgroundColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1];
    
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(xNavbar, yNavbar, widthNavbar, heightNavbar)];
    navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    navbar.layer.cornerRadius = cornerRadius;
    navbar.layer.masksToBounds = YES;
    [self.view addSubview:navbar];
    
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake( navbar.center.x-65, yNavbarLabel, widthNavbarLabel, heightNavbarLabel)];
    navbarLabel.text = @"All Preset";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont boldFlatFontOfSize:25];
    [navbar addSubview:navbarLabel];
    
    // init layout view
    allPresetView = [[UIView alloc] initWithFrame:CGRectMake( xAllPresetView, yAllPresetView,widthAllPresetView, heightAllPresetView)];
    allPresetView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    allPresetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    allPresetView.layer.cornerRadius = cornerRadius;
    allPresetView.layer.masksToBounds = YES;
    [self.view addSubview:allPresetView];
}

-(void)initAllPreset {
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, allPresetView.bounds.size.width, heightNavbar-10)];
    //navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    [navbar configureFlatNavigationBarWithColor:[UIColor sunflowerColor]];
    navbar.layer.cornerRadius = cornerRadius;
    navbar.layer.masksToBounds = YES;
    [allPresetView addSubview:navbar];
    
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, yNavbarLabel-4, widthNavbarLabel, heightNavbarLabel-5)];
    navbarLabel.text = @"All Preset";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont boldFlatFontOfSize:22];
    [navbar addSubview:navbarLabel];
    
    myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 34, allPresetView.bounds.size.width, allPresetView.bounds.size.height)];
    myScroll.contentSize = CGSizeMake(allPresetView.bounds.size.width, 800);   //scroll view size
    myScroll.backgroundColor = [UIColor clearColor];
    myScroll.showsVerticalScrollIndicator = NO;    // to hide scroll indicators!
    myScroll.showsHorizontalScrollIndicator = YES; //by default, it shows!
    myScroll.scrollEnabled = YES;                 //say "NO" to disable scroll
    [allPresetView addSubview:myScroll];               //adding to parent view!
}

-(void)setAllPresetButton {
    int column = 8;
    int row = 6;
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
    if (allPresetClass.storeState && allPresetClass.selected.count!=0) {
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
    else if (!allPresetClass.storeState){
        @try {
            if ([[allPresetClass.savedAllPreset objectAtIndex:tag-1] count]!=0) {
                for (int i=0; i<[allPresetClass.selected count]; i++) {
                    int deviceIndex = [[allPresetClass.selected objectAtIndex:i] intValue]-1;
                    int patchIndex = [[[allPresetClass.device objectAtIndex:deviceIndex] objectAtIndex:0] intValue]-1;
                    if( deviceIndex==patchIndex ) {
                        for (int j=0; j<[allPresetClass.savedAllPreset count]; j++) {
                            int numberOfAllPreset = [[[allPresetClass.savedAllPreset objectAtIndex:j] objectAtIndex:0] intValue];
                            if (tag==numberOfAllPreset) {
                                NSLog(@"i=%d,allPresetTag=%ld - data%@", j, (long)tag, [allPresetClass.savedAllPreset objectAtIndex:j]);
                                //NSLog(@"old device%@",[allPresetClass.device objectAtIndex:deviceIndex]);
                                for (int k=5 ; k<[[allPresetClass.device objectAtIndex:deviceIndex] count]; k++) {
                                    [ self setData:deviceIndex ch:k obj:[NSString stringWithFormat:@"%@",[[allPresetClass.savedAllPreset objectAtIndex:j] objectAtIndex:k-3]] ];
                                }
                                NSLog(@"new device%@",[allPresetClass.device objectAtIndex:deviceIndex]);
                                /* create JSON form */
                                NSMutableDictionary * test = [[NSMutableDictionary alloc] init];
                                NSMutableArray *theArrayTest = [[NSMutableArray alloc] init];
                                [test setObject:[[allPresetClass.device objectAtIndex:deviceIndex] objectAtIndex:0] forKey:@"id"];
                                for (int a=5; a<[[allPresetClass.device objectAtIndex:deviceIndex] count]; a++) {
                                    [test setObject:[[allPresetClass.device objectAtIndex:deviceIndex] objectAtIndex:a]
                                             forKey:[allPresetClass.nameCH objectAtIndex:a] ];
                                }
                                [theArrayTest addObject:[test mutableCopy]];
                                [allPresetClass toString:[theArrayTest mutableCopy] thatView:@"allpreset" action:@"add_preset/"]; /* send JSON form */
                            }
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"don't have any information");
        }
    }
    [self showNameOfAllPreset:tag];
    //[self setSelectedGroup:tag];
    //[self showAllPreset:tag];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        savedAllPresetName = textfield.text;      // name of group device
        NSLog(@"group name=%@",savedAllPresetName);
        bool same = false;
        int sameIndex = 0;
        [element addObject:[NSString stringWithFormat:@"%ld",(long)alertView.tag]];
        [element addObject:savedAllPresetName];
        for (int i=0; i<[allPresetClass.selected count]; i++) {
            int deviceIndex = [[allPresetClass.selected objectAtIndex:i] intValue]-1;
            int patchIndex = [[[allPresetClass.device objectAtIndex:deviceIndex] objectAtIndex:0] intValue]-1;
            if( deviceIndex==patchIndex ) {
                for (int i=5; i<[[allPresetClass.device objectAtIndex:deviceIndex] count]; i++) {
                    [element addObject:[[[allPresetClass.device objectAtIndex:deviceIndex] objectAtIndex:i] mutableCopy]];
                }
            }
        }
        
        
        if ([allPresetClass.savedAllPreset count]!=0) {
            for (int i=0; i<[allPresetClass.savedAllPreset count]; i++) {
                int numberOfGroupDevice = [[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:0] intValue];
                if (alertView.tag==numberOfGroupDevice) {
                    //NSLog(@"tag=%ld,already have=%d", tag,numberOfGroupDevice);
                    same = true;
                    sameIndex = i;
                }
            }
            if (!same) {
                [allPresetClass.savedAllPreset addObject:[element mutableCopy]];
                NSLog(@"ADD save group done %@",allPresetClass.savedAllPreset);
                same = false;
            }
            else {
                [allPresetClass.savedAllPreset replaceObjectAtIndex:sameIndex withObject:[element mutableCopy]];
                NSLog(@"REPLACE save group done %@",allPresetClass.savedAllPreset);
            }
        }
        else {
            [allPresetClass.savedAllPreset addObject:[element mutableCopy]];
            NSLog(@"EMPTY_ADD save group done %@",allPresetClass.savedAllPreset);
        }
        
        /* create JSON form */
        NSMutableDictionary * test = [[NSMutableDictionary alloc] init];
        NSMutableArray *theArrayTest = [[NSMutableArray alloc] init];
        NSLog(@"element.count=%d , nameCH.count=%d",[element count],[allPresetClass.nameCH count]);
        [test setObject:[element objectAtIndex:0] forKey:@"id"];
        [test setObject:[element objectAtIndex:1] forKey:@"name"];
        [test setObject:[element objectAtIndex:2] forKey:@"dimmer"];
        [test setObject:[element objectAtIndex:3] forKey:@"pan"];
        [test setObject:[element objectAtIndex:4] forKey:@"tilt"];
        [test setObject:[element objectAtIndex:5] forKey:@"gobo"];
        [test setObject:[element objectAtIndex:6] forKey:@"color"];
        [test setObject:[element objectAtIndex:7] forKey:@"iris"];
        [test setObject:[element objectAtIndex:8] forKey:@"shutter"];
        [test setObject:[element objectAtIndex:9] forKey:@"focus"];
        [test setObject:[element objectAtIndex:10] forKey:@"zoom"];
        [theArrayTest addObject:[test mutableCopy]];
        [allPresetClass toString:[theArrayTest mutableCopy] thatView:@"allpreset" action:@"add_preset/"]; /* send JSON form */
        
        [element removeAllObjects];
        allPresetClass.storeState = false;
        NSLog(@"state = false");
    }
    [self showNameOfAllPreset:alertView.tag];
    //[self setSelectedGroup:alertView.tag];
    //[self showAllPreset:alertView.tag];
}

-(void)setSelectedGroup:(long)tag {
    //bool colorState = false;
    NSMutableSet *common = [NSMutableSet setWithArray:allPresetClass.selected];
    for (int i=0; i<[allPresetClass.savedAllPreset count]; i++) {
        [common intersectSet:[NSSet setWithArray:[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:1]]];
        NSLog(@"common intersect(%d)=%i", i, common.count);
        int amountOfSelectedArray = [[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:1] count];
        if (common.count==amountOfSelectedArray) {
            FUIButton *allPresetNumber_hasselect = (FUIButton *)[allPresetView viewWithTag:tag];
            UILabel *c1 = (UILabel *)(FUIButton *)[allPresetView viewWithTag:1000+tag];
            UILabel *c2 = (UILabel *)(FUIButton *)[allPresetView viewWithTag:10000+tag];
            //UILabel *c3 = (UILabel *)(FUIButton *)[allPresetView viewWithTag:100000+tag];
            [allPresetNumber_hasselect setSelected:YES];
            if(allPresetNumber_hasselect.selected) {
                c1.textColor = [UIColor redColor];
                c2.textColor = [UIColor yellowColor];
                //c3.textColor = [UIColor greenColor];
            }
        }
    }
}

-(void) showNameOfAllPreset:(long)tag {
    UILabel *c = (UILabel *)(FUIButton *)[allPresetView viewWithTag:10000+tag];
    NSString *t = @"";
    for (int i=0; i<[allPresetClass.savedAllPreset count]; i++) {
        int numberOfGroupDevice = [[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:0] intValue];
        if (tag==numberOfGroupDevice) {
            t = [[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:1] mutableCopy];
            c.text = t;
            //NSLog(@"10000=%@,t=%@,saveGroupDevice=%@",c.text,t,[deviceClass.saveGroupDevice objectAtIndex:i]);
            t=@"";
        }
    }
    NSLog(@"tag %ld show name!",(long)tag);
}

/*
-(void)showAllPreset:(long)tag {
    //NSLog(@"showGroupOfDevice tag%ld - deviceClass.savedAllPreset %@", tag, deviceClass.savedAllPreset);
    UILabel *c = (UILabel *)(FUIButton *)[allPresetView viewWithTag:100000+tag];
    NSString *t = @"";
    for (int i=0; i<[allPresetClass.savedAllPreset count]; i++) {
        int numberOfGroupDevice = [[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:0] intValue];
        if (tag==numberOfGroupDevice) {
            temp = [[[allPresetClass.savedAllPreset objectAtIndex:i] objectAtIndex:1] mutableCopy];
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
    NSLog(@"tag %ld show all preset!",(long)tag);
}
*/

-(void)setData:(int)index
            ch:(int)ch
           obj:(NSString *)obj{
    temp = [[allPresetClass.device objectAtIndex:index] mutableCopy];
    [temp replaceObjectAtIndex:ch withObject:obj];
    [allPresetClass.device replaceObjectAtIndex:index withObject:[temp mutableCopy]];
    [temp removeAllObjects];
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
    
//    UILabel * group = [[UILabel alloc] initWithFrame:CGRectMake(5, h-20, w-5, 20)];
//    group.text = @"";
//    group.font = [UIFont flatFontOfSize:16];
//    group.textColor = [UIColor cloudsColor];
//    group.tag = 100000+tag;
//    group.textAlignment = NSTextAlignmentCenter;
//    [button addSubview:group];
}

@end
