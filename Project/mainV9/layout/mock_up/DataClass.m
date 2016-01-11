//
//  ViewController.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "DataClass.h"
#import "AppDelegate.h"

@implementation DataClass

@synthesize selected;
@synthesize nameCH;
@synthesize device;
@synthesize layout;
@synthesize saveGroupDevice;
@synthesize savedAllPreset;
@synthesize cueList;
@synthesize typeOfLight;
@synthesize numberChOfLight;
@synthesize rev_patching;
@synthesize rev_controlbar;
@synthesize rev_groupdevice;
@synthesize rev_allpreset;
@synthesize rev_cuelist;

@synthesize showStackID;

@synthesize storeState;
@synthesize patchingOnce;
@synthesize deviceOnce;
@synthesize allPresetOnce;
@synthesize cueListOnce;

static DataClass *sharedGlobalData = nil;

+ (DataClass*)sharedGlobalData {
    if (sharedGlobalData == nil) {
        sharedGlobalData = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        sharedGlobalData.selected = [[NSMutableArray alloc] init];
        sharedGlobalData.nameCH = [[NSMutableArray alloc] initWithObjects:@"id",@"name",@"type",@"start",@"amount",@"dimmer",@"pan",@"tilt",@"gobo",@"color",@"iris",@"shutter",@"focus",@"zoom", nil];
        sharedGlobalData.device = [[NSMutableArray alloc] init];
        sharedGlobalData.layout = [[NSMutableArray alloc] init];
        sharedGlobalData.saveGroupDevice = [[NSMutableArray alloc] init];
        sharedGlobalData.savedAllPreset = [[NSMutableArray alloc] init];
        sharedGlobalData.cueList = [[NSMutableArray alloc] init];
        
        NSMutableArray * cue = [[NSMutableArray alloc] init];
        for (int i=0; i<8; i++) {
            [sharedGlobalData.cueList addObject:[cue mutableCopy]];
        }
        
        sharedGlobalData.typeOfLight = [[NSArray alloc] initWithObjects:@"Studio250", @"Cyberlight", @"Xspot", nil];
        sharedGlobalData.numberChOfLight = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:18],[NSNumber numberWithInt:20],[NSNumber numberWithInt:38],nil];
        
        sharedGlobalData.showStackID = 1-1;     // default is stack 1
        
        sharedGlobalData.storeState = false;
        sharedGlobalData.patchingOnce = false;
        sharedGlobalData.deviceOnce = false;
        sharedGlobalData.allPresetOnce = false;
        sharedGlobalData.cueListOnce = false;
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

-(void)toString:(NSMutableArray *)theArray
       thatView:(NSString *)thatView
         action:(NSString *)action {
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *theBigDictionary = [[NSMutableDictionary alloc] init];
    theBigDictionary = [NSMutableDictionary dictionaryWithObject:theArray forKey:thatView];
    
    //NSLog(@"theBigDictionary=%@",theBigDictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theBigDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString=@"";
        NSString *jsonString2 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByAppendingFormat:@"%@%@",action,jsonString2];
        //NSLog(@"jsonString=%@",jsonString);
        [delegate sendUDP:jsonString];
    }
}

-(void)toStringDelete:(NSMutableDictionary *)stringToDel
       thatView:(NSString *)thatView
         action:(NSString *)action {
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *theBigDictionary = [[NSMutableDictionary alloc] init];
    theBigDictionary = [NSMutableDictionary dictionaryWithObject:stringToDel forKey:thatView];
    
    //NSLog(@"theBigDictionary=%@",theBigDictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theBigDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString=@"";
        NSString *jsonString2 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByAppendingFormat:@"%@%@",action,jsonString2];
        //NSLog(@"jsonString=%@",jsonString);
        [delegate sendUDP:jsonString];
    }
}


@end