//
//  BMUtil.m
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "BMUtil.h"

@implementation BMUtil

static int time2Go;
static BOOL isUpdating;
static BOOL started;
static RORMultiPlaySound *song;

+(RORMultiPlaySound *)getSong{
    return song;
}

+(void)setStarted:(BOOL)s{
    started = s;
}

+(BOOL)isStarted{
    return started;
}

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [btn.titleLabel setFont:[UIFont fontWithName:fontFamily size:[[btn.titleLabel font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

+(NSString *)getSoundFiles:(int)number{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *playPath = [NSString stringWithFormat:@"%@/play-%d.mp3",docDir, number];
    NSString *backupPathString = [NSString stringWithFormat:@"%@/backup-%d.mp3",docDir, number];
    NSData *backupData = [[NSData alloc] initWithContentsOfFile:backupPathString];
    NSData *playData = [[NSData alloc] initWithContentsOfFile:playPath];
    //如果昨天的播放区有内容，刚将其写入备份区
    if (playData)
        return playPath;
    if (backupData)
        return backupPathString;
    return nil;
}

+(NSString *)syncSoundFiles:(int)number{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *soundUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beautiful-morning.qiniudn.com/%@-%d.mp3", [self getDateString:[NSDate date]],number]];
    NSString *playPath = [NSString stringWithFormat:@"%@/play-%d.mp3",docDir, number];
    NSString *backupPathString = [NSString stringWithFormat:@"%@/backup-%d.mp3",docDir, number];
    NSData *backupData = [[NSData alloc] initWithContentsOfFile:backupPathString];
    NSData *webData = [NSData dataWithContentsOfURL:soundUrl];
    NSData *playData = [[NSData alloc] initWithContentsOfFile:playPath];
    //如果昨天的播放区有内容，刚将其写入备份区
    if (playData) {
        [playData writeToFile:backupPathString atomically:YES];
    }
    //如果远端有新的内容，将其写入播放区
    if (webData) {
        [webData writeToFile:playPath atomically:YES];
        return playPath;
    }
    
    if (backupData)
        return backupPathString;
    
    return nil;
}

+(NSString *)getFileNameFrom:(NSURL *)URL{
    NSMutableString *strURL = [NSMutableString stringWithFormat:@"%@",URL];
    NSArray *comps = [strURL componentsSeparatedByString:@"/"];
    return [comps objectAtIndex:comps.count-1];
}

+(NSString *)getCurrentTime{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:[NSDate date]];
    return formatDateString;
}

+(NSString *)getDateString:(NSDate *)mDate{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *formatDateString = [formate stringFromDate:mDate];
    return formatDateString;
}

+(NSString *)getFormatTime:(int)seconds{
    if (seconds>=0)
        return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",seconds/3600, (seconds%3600)/60, seconds%60];
    return @"00:00:00";
}


+(void)setTime2Go:(int)t2g{
    time2Go = t2g;
}

+(int)getTime2Go{
    return time2Go;
}

+ (NSMutableDictionary *)getConfigInfoPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"configInfo.plist"];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (userDict == nil)
        userDict = [[NSMutableDictionary alloc] init];
    
    return userDict;
}

+ (void)writeToConfigInfoPList:(NSDictionary *) userDict{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"configInfo.plist"];
    NSMutableDictionary *pInfo = [self getConfigInfoPList];
    [pInfo addEntriesFromDictionary:userDict];
    [pInfo writeToFile:path atomically:YES];
}

+(void)initMedia{
    song = [[RORMultiPlaySound alloc] init];
    for (int i=0; i<3; i++){
        NSString *soundFilePath = [BMUtil getSoundFiles:i];
        if (soundFilePath)
            [song addFileNametoQueue:soundFilePath];
        else
            [song addFileNametoQueue:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"mp3"]];
    }
}

+(void)updateMedia{
//    song = [[RORMultiPlaySound alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isUpdating = true;
        for (int i=0; i<3; i++){
           [BMUtil syncSoundFiles:i];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           isUpdating = false;
            for (int i=0; i<3; i++){
                song = [[RORMultiPlaySound alloc] init];
                for (int i=0; i<3; i++){
                    NSString *soundFilePath = [BMUtil getSoundFiles:i];
                    if (soundFilePath)
                        [song addFileNametoQueue:soundFilePath];
                    else
                        [song addFileNametoQueue:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"mp3"]];
                }
            }
        });
    });
}

+(void)checkMedia{
    NSMutableDictionary *config = [self getConfigInfoPList];
    NSString *lastUpdateString = [config objectForKey:@"lastUpdate"];
    NSString *todayString =[self getDateString:[NSDate date]];
    if (![todayString isEqual:lastUpdateString]){
        [config setObject:todayString forKey:@"lastUpdate"];
        [self writeToConfigInfoPList:config];
        [self updateMedia];
    };
}


@end
