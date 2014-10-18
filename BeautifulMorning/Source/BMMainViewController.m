//
//  BMMainViewController.m
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "BMMainViewController.h"
#import "Animations.h"
#import "FTAnimation+UIView.h"

@interface BMMainViewController ()

@end

@implementation BMMainViewController
@synthesize leftTimeLabel, timePicker, startButton, foursquareSegmentedControl;

int aniDuration = 0.5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [BMUtil initMedia];
    [BMUtil checkMedia];

    timeStyle = TIMESTYLE_TO;
    
    self.sleepForLabel.alpha = 0;
    self.endButton.alpha = 0;
    self.startButton.alpha = 1;
    
    [self loadConfig];
    
    foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Wake up at", @"Sleep for"]];
    [foursquareSegmentedControl addTarget:self action:@selector(timerStyleChanged:) forControlEvents:UIControlEventValueChanged];
    foursquareSegmentedControl.titleTextColor = [UIColor colorWithRed:0.8f green:0.4f blue:0.2f alpha:0.6f];
    foursquareSegmentedControl.titleFont = [UIFont fontWithName:@"NeoTech" size:13.0f];
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.selectedTitleFont = [UIFont fontWithName:@"NeoTech" size:13.0f];
    foursquareSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.8f green:0.4f blue:0.2f alpha:1.0f];
    foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    foursquareSegmentedControl.borderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorInset = 1.0f;
    foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [foursquareSegmentedControl sizeToFit];
    foursquareSegmentedControl.cornerRadius = CGRectGetHeight(foursquareSegmentedControl.frame) / 2.0f;
    foursquareSegmentedControl.center = CGPointMake(self.view.center.x, self.view.frame.size.height*0.25);
    [self.view addSubview:foursquareSegmentedControl];
    
    [self hideCD];
    
    [BMUtil setFontFamily:@"NeoTech" forView:self.view andSubViews:YES];
    
    [BMUtil setStarted:NO];

}

- (void)startFakeSound{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSError *audioSessionError = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
            NSLog(@"Successfully set the audio session.");
        } else {
            NSLog(@"Could not set the audio session");
        }
        
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"mysong" ofType:@"mp3"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        
        if (audioPlayer != nil){
            audioPlayer.delegate = self;
            audioPlayer.volume = 0;
            [audioPlayer setNumberOfLoops:-1];
            if ([audioPlayer prepareToPlay] && [audioPlayer play]){
                NSLog(@"Successfully started playing...");
            } else {
                NSLog(@"Failed to play.");
            }
        } else {
            
        }
    });
}

-(void)viewDidAppear:(BOOL)animated{
    [self initPicker];
//    [Animations rotate:self.cdImageView andAnimationDuration:1 andWait:NO andAngle:360];
    angle = 0;
    [self startAnimation];
}

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.cdImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    angle += 10;
    [self startAnimation];
}

-(void)showCD{
    self.cdImageView.alpha = 1;
    [self.cdImageView fallIn:0.5 delegate:self];
    self.cdShadowImageView.alpha = 1;
    [self.cdShadowImageView fallIn:0.5 delegate:self];
}

-(void)hideCD{
    self.cdImageView.alpha = 0;
    [self.cdImageView flyOut:0.5 delegate:self];
    [self.cdShadowImageView flyOut:0.5 delegate:self];
    self.cdShadowImageView.alpha = 0;
}

-(void)loadConfig{
    NSDictionary *config = [BMUtil getConfigInfoPList];
    if ([config objectForKey:@"hour"])
        saveHour = ((NSNumber *)[config objectForKey:@"hour"]).intValue;
    else
        saveHour = 0;
    if ([config objectForKey:@"minute"])
        saveMinute = ((NSNumber *)[config objectForKey:@"minute"]).intValue;
    else
        saveMinute = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)StartAction:(id)sender {
    timerCount = 0;
    period = [self getTimeFromPicker];
    startTime = [NSDate date];
    wakeupTime = [NSDate dateWithTimeInterval:period sinceDate:startTime];
    leftTimeLabel.text = [NSString stringWithFormat:@"%d", period];
    
    [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
    [self displayLeftTime:[wakeupTime timeIntervalSinceDate:[NSDate date]]];
    
    leftTimeLabel.alpha = 1;
//    self.readyView.alpha = 0;
    [self.readyView backOutTo:kFTAnimationLeft withFade:YES duration:aniDuration delegate:self];
    [self.foursquareSegmentedControl backOutTo:kFTAnimationRight withFade:YES duration:aniDuration delegate:self];
    [self.leftTimeLabel fadeIn:1.5 delegate:self];
    [Animations zoomIn:self.leftTimeLabel andAnimationDuration:0.5 andWait:NO];
    [self.startButton slideOutTo:kFTAnimationBottom duration:1 delegate:self startSelector:nil stopSelector:@selector(showEndButtonAnimation)];

//    for (int i=0; i<3; i++){
//        NSString *soundFilePath = [BMUtil getSoundFiles:i];
//        if (soundFilePath)
//            [song addFileNametoQueue:soundFilePath];
//        else
//            [song addFileNametoQueue:[NSString stringWithFormat:@"%d.mp3", i]];
//    }
    
    [BMUtil setStarted:YES];
    
//    [self startFakeSound];
}

-(void)showEndButtonAnimation{
    self.startButton.alpha = 0;
    self.endButton.alpha = 1;
    [self.endButton slideInFrom:kFTAnimationBottom duration:.75f delegate:self];
}

-(void)showStartButtonAnimation{
    self.endButton.alpha = 0;
    self.startButton.alpha = 1;
    [self.startButton slideInFrom:kFTAnimationBottom duration:.75f delegate:self];
}


-(void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
    repeatTimer = timer;
    [[NSRunLoop currentRunLoop] run];
}

-(void)stopTimer{
    if (repeatTimer)
        [repeatTimer invalidate];
    repeatTimer = nil;
    
    [BMUtil setStarted:NO];
    
    [audioPlayer stop];
}

- (void)timerDot{
    timerCount++;
    [self performSelectorOnMainThread:@selector(timerDotDisplay) withObject:nil waitUntilDone:YES];
}

-(void)timerDotDisplay{
    int time2Go = [wakeupTime timeIntervalSinceDate:[NSDate date]];
    [self displayLeftTime:time2Go];
    [BMUtil setTime2Go:time2Go];
    NSLog(@"%d", time2Go);
    if (time2Go<0){
        [self playSound];
        [self stopTimer];
        [self showCD];
        [self.leftTimeLabel fadeOut:0.5 delegate:self];
        self.leftTimeLabel.alpha = 0;
    } else if (time2Go>600){
        [BMUtil checkMedia];
        
        int timeout = 600;
        if (time2Go<1200)
            timeout = time2Go;
        [[UIApplication sharedApplication] setKeepAliveTimeout:timeout handler: ^
         {
             NSLog(@"%d seconds to go", time2Go);
         }
         ];
    }
}

-(void)displayLeftTime:(int)leftSeconds{
    leftTimeLabel.text = [BMUtil getFormatTime:leftSeconds];
}

-(void)playSound{
    [[BMUtil getSong] play];
}


- (IBAction)StopAction:(id)sender {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self stopTimer];
    [[BMUtil getSong] stop];
    leftTimeLabel.alpha = 0;
    [self.endButton slideOutTo:kFTAnimationBottom duration:.75f delegate:self startSelector:nil stopSelector:@selector(showStartButtonAnimation)];
    [self.leftTimeLabel fadeOut:0.2 delegate:self];
    [Animations zoomOut:self.leftTimeLabel andAnimationDuration:0.2 andWait:NO];
    [self.readyView backInFrom:kFTAnimationLeft withFade:YES duration:aniDuration delegate:self];
    [self.foursquareSegmentedControl backInFrom:kFTAnimationRight withFade:YES duration:aniDuration delegate:self];
    [self hideCD];
}


- (IBAction)timerStyleChanged:(id)sender {
    timeStyle = foursquareSegmentedControl.selectedSegmentIndex;
    
    self.sleepForLabel.alpha = foursquareSegmentedControl.selectedSegmentIndex;
    self.wakeUpAtLabel.alpha = 1-foursquareSegmentedControl.selectedSegmentIndex;
    if (foursquareSegmentedControl.selectedSegmentIndex==0){
        [self.sleepForLabel fadeOut:aniDuration delegate:self];
        [self.wakeUpAtLabel fadeIn:aniDuration delegate:self];
    } else {
        [self.sleepForLabel fadeIn:aniDuration delegate:self];
        [self.wakeUpAtLabel fadeOut:aniDuration delegate:self];
    }
    [timePicker reloadAllComponents];
    [self initPicker];
}

-(void)initPicker{
    if (timeStyle == TIMESTYLE_TO){
        if (saveHour-12>=0){
            isPM = YES;
            [timePicker selectRow:1 inComponent:0 animated:YES];
            [timePicker selectRow:saveHour-12 inComponent:1 animated:YES];
            [timePicker reloadComponent:1];
        } else {
            isPM = NO;
            [timePicker selectRow:0 inComponent:0 animated:YES];
            [timePicker selectRow:saveHour inComponent:1 animated:YES];
            [timePicker reloadComponent:1];
        }
        [timePicker selectRow:saveMinute/5 inComponent:2 animated:YES];
    } else if (timeStyle == TIMESTYLE_PERIOD){
        [timePicker selectRow:0 inComponent:0 animated:YES];
        [timePicker selectRow:0 inComponent:1 animated:YES];
    }
}

- (int)getTimeFromPicker{
    if (timeStyle == TIMESTYLE_PERIOD){
        return [timePicker selectedRowInComponent:0]*3600 +
            [timePicker selectedRowInComponent:1]*300; //check
    }
    if (timeStyle == TIMESTYLE_TO){
        int mHour = [timePicker selectedRowInComponent:0]*12 + [timePicker selectedRowInComponent:1];
        int mMinute = [timePicker selectedRowInComponent:2]*5;
        
        NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mHour], @"hour",[NSNumber numberWithInt:mMinute], @"minute", nil];
        [BMUtil writeToConfigInfoPList:config];
        saveHour = mHour;
        saveMinute = mMinute;
        
        NSDate *rightnow = [NSDate date];
        //想要设置自己想要的格式，可以用nsdateformatter这个类，这里是初始化
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
        [dm setDateFormat:@"yyyy-MM-dd"];
        NSString *ymdString = [dm stringFromDate:rightnow];
        
        NSString *timeString = [NSString stringWithFormat:@"%2d:%2d:00", mHour, mMinute];
        
        NSDateFormatter *allDF = [[NSDateFormatter alloc]init];
        [allDF setDateFormat:@"HH:mm:ss yyyy-MM-dd"];
        NSDate *targetDate0 = [allDF dateFromString:[NSString stringWithFormat:@"%@ %@", timeString,ymdString]];
        int timeInterval = [targetDate0 timeIntervalSinceDate:rightnow];
        if (timeInterval<0)
            timeInterval += 86400;
        return timeInterval;
    }
    return 0;
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    if (timeStyle==TIMESTYLE_PERIOD){
        return 2;
    }
    if (timeStyle==TIMESTYLE_TO){
        return 3;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (timeStyle==TIMESTYLE_PERIOD){
        switch (component) {
            case 0:
                return 12;
            case 1:
                return 12;
            default:
                break;
        }
    }
    if (timeStyle==TIMESTYLE_TO){
        switch (component) {
            case 0:
                return 2;
            case 1:
                return 12;
            case 2:
                return 12;
            default:
                break;
        }
    }
    return 0;
}

#pragma mark Picker Delegate Methods
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (timeStyle==TIMESTYLE_PERIOD && component == 1){
        return [NSString stringWithFormat:@"%.2d",row*5];
    }
    if (timeStyle==TIMESTYLE_TO){
        if (component == 2)
            return [NSString stringWithFormat:@"%.2d",row*5];
        if (component == 0){
            switch (row) {
                case 0:
                    return @"AM";
                case 1:
                    return @"PM";
                default:
                    break;
            }
        }
        if (component == 1 && row == 0){
            return isPM?@"12":@"00";
        }
    }
    return [NSString stringWithFormat:@"%.2d",row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    
    [label setText:[self titleForRow:row forComponent:component]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [BMUtil setFontFamily:@"NeoTech" forView:label andSubViews:NO];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (timeStyle == TIMESTYLE_TO && component==0){
        isPM = (row==1);
        [pickerView reloadComponent:1];
    }
}



#pragma mark Status Bar Style

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}


@end
