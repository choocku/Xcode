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
    NSMutableArray *nameCH;
    NSMutableArray *device;
    NSMutableArray *saveGroupDevice;
    NSMutableArray *savedAllPreset;
    NSMutableArray *cueList;
    NSArray *typeOfLight;
    NSArray *numberChOfLight;
    NSString *rev_patching;
    NSString *rev_controlbar;
    NSString *rev_groupdevice;
    NSString *rev_allpreset;
    NSString *rev_cuelist;
    
    int showStackID;

    bool storeState;
    bool patchingOnce;
    bool deviceOnce;
    bool allPresetOnce;
    bool cueListOnce;
}

@property (nonatomic, retain) NSMutableArray *selected;
@property (nonatomic, retain) NSMutableArray *nameCH;
@property (nonatomic, retain) NSMutableArray *device;
@property (nonatomic, retain) NSMutableArray *saveGroupDevice;
@property (nonatomic, retain) NSMutableArray *savedAllPreset;
@property (nonatomic, retain) NSMutableArray *cueList;
@property (nonatomic, retain) NSArray *typeOfLight;
@property (nonatomic, retain) NSArray *numberChOfLight;
@property (nonatomic, retain) NSString *rev_patching;
@property (nonatomic, retain) NSString *rev_controlbar;
@property (nonatomic, retain) NSString *rev_groupdevice;
@property (nonatomic, retain) NSString *rev_allpreset;
@property (nonatomic, retain) NSString *rev_cuelist;
@property (nonatomic) int showStackID;
@property (nonatomic) bool storeState;
@property (nonatomic) bool patchingOnce;
@property (nonatomic) bool deviceOnce;
@property (nonatomic) bool allPresetOnce;
@property (nonatomic) bool cueListOnce;

+ (DataClass*)sharedGlobalData;

// global function
- (void) myFunc;

-(void)toString:(NSMutableArray *)theArray
       thatView:(NSString *)thatView
         action:(NSString *)action;
-(void)toStringDelete:(NSMutableArray *)theArray
       thatView:(NSString *)thatView
         action:(NSString *)action;


@end

