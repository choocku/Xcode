//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "CueListViewController.h"

@interface CueListViewController ()

@end

@implementation CueListViewController
{
    // stack View
    UIView * stackView;
    
    
    // table view
    UITableViewCell * cell;
    int cell_origin_x;
    int cell_origin_y;
    int cell_Width;
    int cell_Height;
    int deviceID_origin_x;
    int name_origin_x;
    int type_origin_x;
    int channel_origin_x;
    int description_origin_x;
    int column;
    
    NSString * name;
    int duration;
    
    NSMutableArray * stack;
    NSMutableArray * cueListInStack;
    NSMutableArray * element;
    NSMutableArray * temp;
    
    float cornerRadius;
    
    DataClass * cueListClass;
}

@synthesize cueListTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    cueListClass = [DataClass sharedGlobalData];
    [self initVariable];        // init variables
    [super initMenu];
    [self initPatterns];        // init BG color, table style, navbar, navbar label and add button
    [self createStacksButton];
    NSLog(@"Cue List Ready");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPatterns {
    // set background color
    [self.view setBackgroundColor:[UIColor colorWithRed:0.749 green:0.749 blue:0.749 alpha:1]]; // bfbfbf
    
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-(10*2), 44)];
    navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    navbar.layer.cornerRadius = cornerRadius;
    navbar.layer.masksToBounds = YES;
    
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(navbar.center.x-60, 0, 150, 44)];
    navbarLabel.text = @"Cue List";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont boldFlatFontOfSize:25];
    [navbar addSubview:navbarLabel];
    
    // set table style
    cueListTableView.backgroundColor = [UIColor clearColor];
    cueListTableView.separatorColor = [UIColor clearColor];
    cueListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cueListTableView.layer.cornerRadius = cornerRadius;
    cueListTableView.layer.masksToBounds = YES;
    
    // set stack View
    stackView = [[UIView alloc] initWithFrame:CGRectMake( 10, 684, self.view.bounds.size.width-20, 75)];
    stackView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    stackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    stackView.layer.cornerRadius = cornerRadius;
    stackView.layer.masksToBounds = YES;
    [self.view addSubview:stackView];
    
    // set add button
    UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(navbar.bounds.size.width-60, 7, 30, 30)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateNormal];
    addButton.tag = 1;
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:addButton];
    [self.view addSubview:navbar];
}

-(void)initVariable {
    // stack View
    
    // Table View
    cell_origin_x = 0;
    cell_origin_y = 0;
    cell_Width = [UIScreen mainScreen].bounds.size.width;
    cell_Height = 45;
    deviceID_origin_x = 0;
    name_origin_x = 250;
    type_origin_x = 250*2;
    channel_origin_x = 250*3;
    description_origin_x = 250*4;
    column = 5;
    cornerRadius = 9.0f;
    
    name = @"";
    duration = 0;
    
    stack = [[NSMutableArray alloc] init];
    cueListInStack = [[NSMutableArray alloc] init];
    element = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
}

-(void)createStacksButton {
    int xStackButton = 10;
    int yStackButton = 10;
    int widthStackButton = 100;
    int heightStackButton = 55;
    
    UILabel * stackLabel = [[UILabel alloc] initWithFrame:CGRectMake(xStackButton, yStackButton, widthStackButton, heightStackButton)];
    stackLabel.textColor = [UIColor midnightBlueColor];
    stackLabel.font = [UIFont boldFlatFontOfSize:20];
    stackLabel.textAlignment = NSTextAlignmentCenter;
    stackLabel.text = @"Stack";
    [stackView addSubview:stackLabel];
    
    [self createButton:stackView
                 title:@"1"
                   tag:1
                     x:xStackButton+((widthStackButton+xStackButton)*1)
                     y:yStackButton
                     w:widthStackButton
                     h:heightStackButton
           buttonColor:[UIColor peterRiverColor]
           shadowColor:[UIColor belizeHoleColor]
          shadowHeight:3.0f
            titleColor:[UIColor cloudsColor]
              selector:NSStringFromSelector(@selector(stack:))
                  font:[UIFont boldFlatFontOfSize:16]];
}

-(void)stack:(id)sender {
    NSLog(@"%ld",(long)((UIButton *)sender).tag);
    if ([stack count]!=0) {
        NSLog(@"stack%ld,%@", (long)((UIButton *)sender).tag-1, [stack objectAtIndex:((UIButton *)sender).tag-1]);
    }
    else {
        NSLog(@"stack is empty");
    }
}

-(void)add:(UIButton *)button {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Name"
                          message:@"Insert your cue name"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil];
    alert.tag = 100;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 100) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        name = textfield.text;    // row is amount of device
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Duration"
                              message:@"Insert duration"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK",nil];
        alert.tag = 101;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    else if (buttonIndex == 1 && alertView.tag == 101) {
        int m = 0;
        UITextField *textfield = [alertView textFieldAtIndex:0];
        duration = [textfield.text floatValue];      // set beginning channel
        
        // add data to array
        
        
        [element removeAllObjects];
        
        NSLog(@"patchingData=%@",patchingClass.patchingData);
        [cueListTableView reloadData];
        
        NSMutableArray * createData;
        for (int i=0; i<[patchingClass.patchingData count]; i++) {
            createData = [[NSMutableArray alloc] initWithObjects:@"id",@"name",@"type",@"start",@"amount",@"dimmer",@"pan",@"tilt",@"gobo",@"color",@"iris",@"shutter",@"focus",@"zoom", nil];
            [patchingClass.device addObject:createData];
        }
        //NSLog(@"patchingClass.device=%@",patchingClass.device);
        [patchingTableView reloadData];
        
        NSMutableDictionary * test;
        NSMutableArray *theArrayTest = [[NSMutableArray alloc] init];
        for (int i=0; i<[patchingClass.patchingData count]; i++) {
            test = [[NSMutableDictionary alloc] init];
            for (int j=0; j<5; j++) {
                [self setData:i ch:j obj:[NSString stringWithFormat:@"%@",[[patchingClass.patchingData objectAtIndex:i] objectAtIndex:j]]];
                [test setObject:[[patchingClass.patchingData objectAtIndex:i] objectAtIndex:j] forKey:[NSString stringWithFormat:@"%@",[patchingClass.nameCH objectAtIndex:j]]];
            }
            [theArrayTest addObject:[test mutableCopy]];
        }
        [self toString:[theArrayTest mutableCopy]];
        NSLog(@"setData=%@",patchingClass.device);
    }
}

-(void)setData:(int)index
            ch:(int)ch
           obj:(NSString *)obj{
    temp = [[patchingClass.device objectAtIndex:index] mutableCopy];
    [temp replaceObjectAtIndex:ch withObject:obj];
    [patchingClass.device replaceObjectAtIndex:index withObject:[temp mutableCopy]];
    [temp removeAllObjects];
}

-(void)toString:(NSMutableArray *)theArray {
    
    NSMutableDictionary *theBigDictionary = [[NSMutableDictionary alloc] init];
    theBigDictionary = [NSMutableDictionary dictionaryWithObject:theArray forKey:@"patching"];
    
    //NSLog(@"theBigDictionary=%@",theBigDictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theBigDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString=@"";
        NSString *jsonString2 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"jsonString=%@",jsonString);
        jsonString = [jsonString stringByAppendingFormat:@"+%@",jsonString2];
        [delegate sendUDP:jsonString];
    }
}

-(void)cueList:(int)indexPath_row {
    int numberOfData = [[stack objectAtIndex:indexPath_row-1] count];
    NSLog(@"cusList%d %@", indexPath_row-1, [stack objectAtIndex:indexPath_row-1]);
    for (int i=0; i<[stack count]; i++) {
        for (int j=0; j<numberOfData; j++) {
            if (j==0 || j==3) {
                [self createLabel:cell
                                x:j*name_origin_x
                                y:0
                         fontSize:[UIFont flatFontOfSize:16]
                        fontColor:[UIColor blackColor]
                             text:[NSString stringWithFormat:@"%@",[[stack objectAtIndex:indexPath_row-1] objectAtIndex:j]]];
            }
            else {
                UITextField * myTextField = [[UITextField alloc] initWithFrame:CGRectMake(j*name_origin_x-23, 0, name_origin_x, cell_Height)];
                myTextField.font = [UIFont flatFontOfSize:16];
                myTextField.textAlignment = NSTextAlignmentCenter;
                myTextField.placeholder = @"Name";
                [cell addSubview:myTextField];
            }
        }
        
    }
}

-(void)setHeader {
    [self createLabel:cell
                    x:deviceID_origin_x
                    y:cell_origin_y
             fontSize:[UIFont boldFlatFontOfSize:16]
            fontColor:[UIColor whiteColor]
                 text:@"Number"];
    [self createLabel:cell
                    x:name_origin_x
                    y:cell_origin_y
             fontSize:[UIFont boldFlatFontOfSize:16]
            fontColor:[UIColor whiteColor]
                 text:@"Name"];
    [self createLabel:cell
                    x:type_origin_x
                    y:cell_origin_y
             fontSize:[UIFont boldFlatFontOfSize:16]
            fontColor:[UIColor whiteColor]
                 text:@"Duration"];
    [self createLabel:cell
                    x:channel_origin_x
                    y:cell_origin_y
             fontSize:[UIFont boldFlatFontOfSize:16]
            fontColor:[UIColor whiteColor]
                 text:@"Default Duration"];
}

-(void)createLabel:(UITableViewCell *)toCell
                 x:(int)x
                 y:(int)y
          fontSize:(UIFont *)fontSize
         fontColor:(UIColor *)fontColor
              text:(NSString *)text {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cell_Width/column, cell_Height)];
    label.font = fontSize;
    label.textColor = fontColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [toCell addSubview:label];
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell_Height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stack count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return NO;
    else
        return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //remove the deleted object from your data source.
//        //If your data source is an NSMutableArray, do this
//        [patchingClass.patchingData removeObjectAtIndex:indexPath.row-1];
//        [self resetDeviceID];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView reloadData]; // tell table to refresh now
//        NSLog(@"device=%@",patchingClass.patchingData);
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *headerCellIdentifier = @"HeaderCell";
    NSString *cellIdentifier = @"Cell";
    if(indexPath.row==0){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.145 green:0.455 blue:0.663 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setHeader];
        return cell;
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor colorWithRed:0.894 green:0.945 blue:0.996 alpha:1];
        }
        // show patching data
        [self cueList:indexPath.row];
        return cell;
    }
}

@end
