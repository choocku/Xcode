//
//  UITableView+PatchingViewController.h
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "slideMenu.h"

@interface PatchingViewController : slideMenu <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *patchingTableView;

@end
