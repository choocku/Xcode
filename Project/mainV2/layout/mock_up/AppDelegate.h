//
//  AppDelegate.h
//  mock_up
//
//  Created by Peeranon Wattanapong on 11/1/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    long tag;
    AsyncUdpSocket *udpSocket;
}

@property (strong, nonatomic) UIWindow *window;
-(void)sendUDP:(NSString *)msg;

@end

