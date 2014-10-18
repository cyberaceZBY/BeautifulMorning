//
//  BMAppDelegate.m
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "BMAppDelegate.h"


@implementation BMAppDelegate
@synthesize period;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    
    [MobClick startWithAppkey:@"543e35b9fd98c5c13b0008c8" reportPolicy:BATCH   channelId:@"Fir"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        // ...
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    if (bgTask == UIBackgroundTaskInvalid) {
        NSLog(@"failed to start background task!");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"123123123131231231++++++++++++");
    
    //    sure=NO;
    //    UIApplicationState state = application.applicationState;
    //
    //    if (state == UIApplicationStateActive)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提醒"
    //                                                        message:notification.alertBody
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"确定"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //        [alert release];
    //    }
    
    //    RORMultiPlaySound *song = [[RORMultiPlaySound alloc] init];
    //    for (int i=0; i<3; i++)
    //        [song addFileNametoQueue:[BMUtil getSoundFiles:i]];
    //    [song play];
    
}

@end
