//
//  DDDContentViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDContentViewController.h"
#import "TopStoryStoryboardIdentifiers.h"

@interface DDDContentViewController ()

@end

@implementation DDDContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController transitionToScreen:DDDTopStoriesViewControllerIdentifier withAttributes:nil animated:YES];
}

@end
