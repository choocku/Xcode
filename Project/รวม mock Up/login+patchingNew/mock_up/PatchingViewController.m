//
//  UITableView+PatchingViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "PatchingViewController.h"

@interface PatchingViewController ()

@end

@implementation PatchingViewController : UIViewController
{
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
    
    int row;
    NSString * name;
    NSString * type;
    NSArray *array;
    NSArray *array2;
    NSMutableArray * temp;
    NSMutableArray * device;
    NSMutableArray * element;
    int start_channel;
}

@synthesize patchingTableView;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initVariable {
    cell_origin_x = 0;
    cell_origin_y = 0;
    cell_Width = [UIScreen mainScreen].bounds.size.width;
    cell_Height = 45;
    deviceID_origin_x = 0;
    name_origin_x = 200;
    type_origin_x = 400;
    channel_origin_x = 600;
    description_origin_x = 800;
    column = 5;
    
    row = 0;
    name = @"";
    type = @"";
    array = [[NSArray alloc] initWithObjects:@"Studio250", @"Cyberlight", @"Xspot", nil];
    array2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:24],[NSNumber numberWithInt:20],[NSNumber numberWithInt:38],nil];
    device = [[NSMutableArray alloc] init];
    element = [[NSMutableArray alloc] init];
    temp = [[NSMutableArray alloc] init];
    start_channel = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.671 green:0.718 blue:0.718 alpha:1]];
    patchingTableView.backgroundColor = [UIColor clearColor];
    patchingTableView.separatorColor = [UIColor clearColor];
    patchingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    patchingTableView.layer.cornerRadius = 5;
    patchingTableView.layer.masksToBounds = YES;
    // init variables
    [self initVariable];
    // init navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-(10*2), 44)];
    navbar.barTintColor = [UIColor colorWithRed:0.122 green:0.227 blue:0.576 alpha:1];
    navbar.layer.cornerRadius = 5;
    navbar.layer.masksToBounds = YES;
    // set navbar label
    UILabel * navbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(navbar.center.x-60, 0, 150, 44)];
    navbarLabel.text = @"Patching";
    navbarLabel.textColor = [UIColor whiteColor];
    navbarLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    [navbar addSubview:navbarLabel];
    // set add button
    UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(navbar.bounds.size.width-60, 7, 30, 30)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateNormal];
    addButton.tag = 1;
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:addButton];
    [self.view addSubview:navbar];
}

-(void)add:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Amount"
                          message:@"Insert amount of device"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil];
    alert.tag = 5000;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 5000) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        row = [textfield.text intValue];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Name"
                              message:@"Insert device name"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK",nil];
        alert.tag = 5001;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    else if (buttonIndex == 1 && alertView.tag == 5001) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        name = textfield.text;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Type"
                              message:@"Select device type"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:nil];
        alert.tag = 5002;
        [alert addButtonWithTitle:array[0]];
        [alert addButtonWithTitle:array[1]];
        [alert addButtonWithTitle:array[2]];
        alert.cancelButtonIndex = [alert addButtonWithTitle:@"Cancel"];
        [alert show];
    }
    else if (alertView.tag == 5002) {
        if (buttonIndex==0)
            type = array[0];
        else if (buttonIndex==1)
            type = array[1];
        else if (buttonIndex==2)
            type = array[2];
        UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Channel"
                                message:@"Insert beginning channel"
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"OK",nil];
        alert.tag = 5003;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField* tf = [alert textFieldAtIndex:0];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
    }
    else if (buttonIndex == 1 && alertView.tag == 5003) {
        int m = 0;
        UITextField *textfield = [alertView textFieldAtIndex:0];
        start_channel = [textfield.text intValue];
        for (int i=0; i<row; i++) {
            [element addObject:[NSNumber numberWithInt:device.count+1]];                           // device id
            [element addObject:[name stringByAppendingString:[NSString stringWithFormat:@"%d",i+1]]]; // name
            [element addObject:type];                                                                 // type
            // channel
            for(int k=0; k<array.count; k++) {
                if (array[k] == type) {
                    int amount_channel = [array2[k] intValue];
                    m = start_channel+amount_channel-1;
                    [element addObject:[NSString stringWithFormat:@"%d",start_channel]];
                    [element addObject:[NSString stringWithFormat:@"%d",amount_channel]];
                    start_channel += amount_channel;
                }
            }
            //[element addObject:[NSString stringWithFormat:@""]];
            temp = [element mutableCopy];
            [device addObject:temp];
            [element removeAllObjects];
        }
        NSLog(@"device=%@",device);
        [patchingTableView reloadData];
    }
}

-(void)patching:(int)indexPath_row {
    int numberOfData = [[device objectAtIndex:indexPath_row-1] count];
    for (int j=0; j<numberOfData; j++) {
        if(j==numberOfData-1)
            continue;
        else
            [self createLabel:cell
                            x:j*name_origin_x
                            y:0
                     fontSize:[UIFont systemFontOfSize:14.0f]
                    fontColor:[UIColor blackColor]
                         text:[NSString stringWithFormat:@"%@",[[device objectAtIndex:indexPath_row-1] objectAtIndex:j]]];
    }
}

-(void)resetDeviceID {
    int newRow = [device count];
    for (int i=0; i<newRow; i++) {
        [[device objectAtIndex:i] replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:i+1]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell_Height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [device count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [device removeObjectAtIndex:indexPath.row-1];
        [self resetDeviceID];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData]; // tell table to refresh now
        NSLog(@"device=%@",device);
    }
}

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
        // set description textfield
        UITextField * descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(4*name_origin_x, 0, cell_Width/column, cell_Height)];
        descriptionTextField.tag = indexPath.row;
        descriptionTextField.placeholder = @"\tAdd Description";
        descriptionTextField.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:descriptionTextField];
        // show patching data
        [self patching:indexPath.row];
        return cell;
    }
}

-(void)setHeader {
    [self createLabel:cell
                  x:deviceID_origin_x
                  y:cell_origin_y
           fontSize:[UIFont fontWithName:@"Helvetica-Bold" size:16]
          fontColor:[UIColor whiteColor]
               text:@"DeviceID"];
    [self createLabel:cell
                  x:name_origin_x
                  y:cell_origin_y
           fontSize:[UIFont fontWithName:@"Helvetica-Bold" size:16]
          fontColor:[UIColor whiteColor]
               text:@"Name"];
    [self createLabel:cell
                  x:type_origin_x
                  y:cell_origin_y
           fontSize:[UIFont fontWithName:@"Helvetica-Bold" size:16]
          fontColor:[UIColor whiteColor]
               text:@"Type"];
    [self createLabel:cell
                  x:channel_origin_x
                  y:cell_origin_y
           fontSize:[UIFont fontWithName:@"Helvetica-Bold" size:16]
          fontColor:[UIColor whiteColor]
               text:@"Channel"];
    [self createLabel:cell
                  x:description_origin_x
                  y:cell_origin_y
           fontSize:[UIFont fontWithName:@"Helvetica-Bold" size:16]
          fontColor:[UIColor whiteColor]
               text:@"Description"];
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

@end
