//
//  BMDataViewController.m
//  BeautifulMorning
//
//  Created by Bjorn on 14-7-18.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "BMDataViewController.h"

@interface BMDataViewController ()

@end

@implementation BMDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
