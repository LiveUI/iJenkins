//
//  FTAppDelegate.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import <LUIFramework/LUIFramework.h>
#import "FTAccountsViewController.h"
#import "Flurry.h"


@implementation FTAppDelegate


#pragma mark Application delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Crash reporting
    [Crashlytics startWithAPIKey:@"645cad88976887e985fc9e2d08345ca9cc583918"];
    
    // Flurry analytics
    [Flurry startSession:@"JZK5H9MRXHYP86K7DJX8"];
    
    // Remote localization from http://www.liveui.io
    [[LUIURLs sharedInstance] setCustomApiUrlString:@"http://localhost/api.liveui.io/"];
    [[LUIURLs sharedInstance] setCustomImagesUrlString:@"http://localhost/images.liveui.io/"];
    [[LUIMain sharedInstance] setDebugMode:YES];
    [[LUIMain sharedInstance] setApiKey:@"919EA7C3-D530-48F2-B07C-7DC82680874A"];
    
    _viewController = [[FTAccountsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_viewController];
    [_window setRootViewController:nc];
    [_window makeKeyAndVisible];
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


@end
