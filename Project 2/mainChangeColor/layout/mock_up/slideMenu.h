//
//  slideMenu.h
//  mock_up
//
//  Created by Kittisak Chiewchoengchon on 11/2/14.
//  Copyright (c) 2014 Choock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDSideBarController.h"
#import "ControlBar.h"
@interface slideMenu : ControlBar <CDSideBarControllerDelegate>
{
    CDSideBarController *sideBar;
}
- (void) initMenu;
- (void) viewDidAppear:(BOOL)animeted;
- (void) menuButtonClicked:(int) index;
@end
