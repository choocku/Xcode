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
@synthesize patchingData;
@synthesize saveGroupDevice;
@synthesize storeState;
@synthesize nameCH;
@synthesize device;

static DataClass *sharedGlobalData = nil;

+ (DataClass*)sharedGlobalData {
    if (sharedGlobalData == nil) {
        sharedGlobalData = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        sharedGlobalData.selected = [[NSMutableArray alloc] init];
        sharedGlobalData.patchingData = [[NSMutableArray alloc] init];
        sharedGlobalData.saveGroupDevice = [[NSMutableArray alloc] init];
        sharedGlobalData.nameCH = [[NSMutableArray alloc] initWithObjects:@"id",@"name",@"type",@"start",@"amount",@"dimmer",@"pan",@"tilt",@"gobo",@"color",@"iris",@"shutter",@"focus",@"zoom", nil];
        sharedGlobalData.device = [[NSMutableArray alloc] init];
        sharedGlobalData.storeState = false;
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