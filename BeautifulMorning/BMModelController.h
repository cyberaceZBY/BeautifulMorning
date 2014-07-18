//
//  BMModelController.h
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMDataViewController;

@interface BMModelController : NSObject <UIPageViewControllerDataSource>

- (BMDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(BMDataViewController *)viewController;

@end
