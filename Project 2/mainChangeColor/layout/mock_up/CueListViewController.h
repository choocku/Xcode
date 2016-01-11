//
//  ViewController.h
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "slideMenu.h"
#import "DataClass.h"
#import "FlatUIKit.h"

@interface CueListViewController : slideMenu <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cueListTableView;

@end

