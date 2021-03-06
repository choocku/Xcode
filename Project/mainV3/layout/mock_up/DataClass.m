//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass

@synthesize selected;
@synthesize saveGroupDevice;
@synthesize storeState;
@synthesize nameCH;
@synthesize device;
@synthesize cueList;
@synthesize typeOfLight;
@synthesize numberChOfLight;
@synthesize rev_patching;
@synthesize rev_controlbar;
@synthesize rev_groupdevice;
@synthesize rev_allpreset;
@synthesize rev_cuelist;
@synthesize patchingOnce;

static DataClass *sharedGlobalData = nil;

+ (DataClass*)sharedGlobalData {
    if (sharedGlobalData == nil) {
        sharedGlobalData = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        sharedGlobalData.selected = [[NSMutableArray alloc] init];
        sharedGlobalData.saveGroupDevice = [[NSMutableArray alloc] init];
        sharedGlobalData.nameCH = [[NSMutableArray alloc] initWithObjects:@"id",@"name",@"type",@"start",@"amount",@"dimmer",@"pan",@"tilt",@"gobo",@"color",@"iris",@"shutter",@"focus",@"zoom", nil];
        sharedGlobalData.device = [[NSMutableArray alloc] init];
        sharedGlobalData.cueList = [[NSMutableArray alloc] init];
        sharedGlobalData.typeOfLight = [[NSArray alloc] initWithObjects:@"Studio250", @"Cyberlight", @"Xspot", nil];
        sharedGlobalData.numberChOfLight = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:18],[NSNumber numberWithInt:20],[NSNumber numberWithInt:38],nil];
        sharedGlobalData.storeState = false;
        sharedGlobalData.patchingOnce = false;
    }
    return sharedGlobalData;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self)
    {
        if (sharedGlobalData == nil)
        {
            sharedGlobalData = [super allocWithZone:zone];
            return sharedGlobalData;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// this is my global function
- (void)myFunc {
    
}



@end