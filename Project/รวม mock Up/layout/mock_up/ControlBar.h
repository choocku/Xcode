//
//  ViewController.h
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIAlertView.h"


@interface ControlBar : UIViewController <UIPopoverControllerDelegate, UIActionSheetDelegate, FUIAlertViewDelegate>

-(void)initControlBar;
@end

