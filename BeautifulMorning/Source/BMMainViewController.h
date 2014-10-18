//
//  BMMainViewController.h
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORPlaySound.h"
#import "RORMultiPlaySound.h"
#import "BMUtil.h"
#import "NYSegmentedControl.h"

#define TIMESTYLE_TO 0
#define TIMESTYLE_PERIOD 1

@interface BMMainViewController : UIViewController{
    NSTimer *repeatTimer;
    int timerCount;
    int period;
    int timeStyle;
    BOOL isPM;
    
    int saveHour, saveMinute;
    
    NSDate *startTime, *wakeupTime;
    RORMultiPlaySound *song;
    double angle;
    
    AVAudioPlayer *audioPlayer;
}

@property (strong, nonatomic) IBOutlet UIView *readyView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *wakeUpAtLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;
@property (strong, nonatomic) IBOutlet UIView *sleepForLabel;
@property (strong, nonatomic) IBOutlet UILabel *updatingLabel;
@property (strong, nonatomic) NYSegmentedControl *foursquareSegmentedControl;

@property (strong, nonatomic) IBOutlet UIImageView *cdImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cdShadowImageView;

@end
