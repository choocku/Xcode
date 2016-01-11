//
//  AppDelegate.m
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "AppDelegate.h"
#import "DataClass.h"
@interface AppDelegate ()

@end

@implementation AppDelegate {
    //NSString *host;
    //int port;
}
NSString * host = @"192.168.1.104";
int port = 1024;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    UITextField *lagFreeField = [[UITextField alloc] init];
//    [self.window addSubview:lagFreeField];
//    [lagFreeField becomeFirstResponder];
//    [lagFreeField resignFirstResponder];
//    [lagFreeField removeFromSuperview];
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    if (![udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        //return;
    }
    [udpSocket receiveWithTimeout:3 tag:0];
    [self sendUDP:@"?patching"];
    [self sendUDP:@"?groupdevice"];
    [self sendUDP:@"?controlbar"];
    [self sendUDP:@"?allpreset"];
    [self sendUDP:@"?cuelist"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)sendUDP:(NSString *)msg{
    if ([host length] == 0)
    {
        NSLog(@"Address required");
        return;
    }
    
    if (port <= 0 || port > 65535)
    {
        NSLog(@"Valid port required");
        return;
    }
    
    if ([msg length] == 0)
    {
        NSLog(@"Message required");
        return;
    }
      NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    tag++;
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock
     didReceiveData:(NSData *)data
            withTag:(long)tag
           fromHost:(NSString *)host
               port:(UInt16)port
{
    DataClass *delegateClass;
    delegateClass = [DataClass sharedGlobalData];
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
         NSLog(@"RECV: %@", msg);
        if ([msg containsString:@"patching"]) {
            delegateClass.rev_patching = msg;
        } else if ([msg containsString:@"controlbar"]) {
            delegateClass.rev_controlbar = msg;
        } else if ([msg containsString:@"groupdevice"]) {
            delegateClass.rev_groupdevice = msg;
        } else if ([msg containsString:@"allpreset"]) {
            delegateClass.rev_allpreset = msg;
        } else if ([msg containsString:@"cuelist"]) {
            delegateClass.rev_cuelist = msg;
        }
        
        //        NSLog(@"message : %@",delegateClass.message);
        //        NSLog(@"receive message from server");
    }
    else
    {
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
    
    [udpSocket receiveWithTimeout:-1 tag:0];
    return YES;
}

@end
