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
    NSMutableArray *saveGroupDevice;
    NSMutableArray *nameCH;
    NSMutableArray *device;
    NSMutableArray *cueList;
    NSArray *typeOfLight;
    NSArray *numberChOfLight;
    NSString *rev_patching;
    NSString *rev_controlbar;
    NSString *rev_groupdevice;
    NSString *rev_allpreset;
    NSString *rev_cuelist;

    bool storeState;
    bool patchingOnce;
}

@property (nonatomic, retain) NSMutableArray *selected;
@property (nonatomic, retain) NSMutableArray *saveGroupDevice;
@property (nonatomic, retain) NSMutableArray *nameCH;
@property (nonatomic, retain) NSMutableArray *device;
@property (nonatomic, retain) NSMutableArray *cueList;
@property (nonatomic, retain) NSArray *typeOfLight;
@property (nonatomic, retain) NSArray *numberChOfLight;
@property (nonatomic, retain) NSString *rev_patching;
@property (nonatomic, retain) NSString *rev_controlbar;
@property (nonatomic, retain) NSString *rev_groupdevice;
@property (nonatomic, retain) NSString *rev_allpreset;
@property (nonatomic, retain) NSString *rev_cuelist;
@property (nonatomic) bool storeState;
@property (nonatomic) bool patchingOnce;

+ (DataClass*)sharedGlobalData;

// global function
- (void) myFunc;

@end

