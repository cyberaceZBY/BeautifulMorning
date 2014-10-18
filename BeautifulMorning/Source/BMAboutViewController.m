//
//  BMAboutViewController.m
//  BeautifulMorning
//
//  Created by Bjorn on 14-10-13.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "BMAboutViewController.h"

@interface BMAboutViewController ()

@end

@implementation BMAboutViewController

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

    [BMUtil setFontFamily:@"NeoTech" forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redirect2Weibo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/mornmelody"]];

}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

@end
