//
//  BMAppDelegate.h
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORPlaySound.h"
#import "Source/RORMultiPlaySound.h"
#import "BMUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "MobClick.h"

@interface BMAppDelegate : UIResponder <UIApplicationDelegate>{
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int period;

@end
