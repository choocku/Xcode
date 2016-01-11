//
//  ViewController.h
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataClass : NSObject {
    NSMutableArray *selected;   // global variable
    NSMutableArray *patchingData;
    NSMutableArray *saveGroupDevice;
    NSMutableArray *nameCH;
    NSMutableArray *device;
    bool storeState;
}

@property (nonatomic, retain) NSMutableArray *selected;
@property (nonatomic, retain) NSMutableArray *patchingData;
@property (nonatomic, retain) NSMutableArray *saveGroupDevice;
@property (nonatomic, retain) NSMutableArray *nameCH;
@property (nonatomic, retain) NSMutableArray *device;
@property (nonatomic) bool storeState;

+ (DataClass*)sharedGlobalData;

// global function
- (void) myFunc;

@end

