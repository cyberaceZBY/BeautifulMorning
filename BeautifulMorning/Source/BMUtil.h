//
//  BMUtil.h
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORMultiPlaySound.h"

@interface BMUtil : NSObject{
}

+(RORMultiPlaySound *)getSong;

+(void)setStarted:(BOOL)s;

+(BOOL)isStarted;

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;

+(NSString *)getSoundFiles:(int)number;

+(NSString *)getFileNameFrom:(NSURL *)URL;

+(NSString *)getCurrentTime;

+(void)setTime2Go:(int)t2g;

+(int)getTime2Go;

+(NSString *)getFormatTime:(int)seconds;

+ (NSMutableDictionary *)getConfigInfoPList;

+ (void)writeToConfigInfoPList:(NSDictionary *) userDict;

+(void)initMedia;

+(void)checkMedia;


@end
