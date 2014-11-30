//
//  DDDStoryDetailViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDetailViewController.h"
#import "DetailStoryboardIdentifiers.h"
#import "DDDStoryDetailViewModel.h"

@interface DDDStoryDetailViewController ()

@end

@implementation DDDStoryDetailViewController

+ (NSString *)storyboardIdentifier
{
    return DDDStoryDetailViewControllerIdentifier;
}

+ (NSString *)storyboardName
{
    return DetailStoryboardName;
}

+ (Class)viewModelClass
{
    return [DDDStoryDetailViewModel class];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
