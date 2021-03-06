//
//  AppDelegate.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "AppDelegate.h"
#import "MediaController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookHandler.h"
#import "FeedTableViewController.h"

@implementation AppDelegate
@synthesize viewControllerForRefresh = _viewControllerForRefresh;

// custom Facebook shit
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Enable background tasks
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [[FacebookHandler sharedInstance] loginIfNeeded];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[MediaController sharedInstance] saveFeeds];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[MediaController sharedInstance] fetchChannelsWithCompletionHandler:^(BOOL didReceiveNewFeeds){
        if(didReceiveNewFeeds)
        {
            completionHandler(UIBackgroundFetchResultNewData);
        }
        else
        {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
