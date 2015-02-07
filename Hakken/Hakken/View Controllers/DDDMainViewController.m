//
//  DDDRootViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDMainViewController.h"
#import "DDDContentViewController.h"
#import "MainStoryboardIdentifiers.h"
#import "TopStoryStoryboardIdentifiers.h"
#import "DetailStoryboardIdentifiers.h"
#import "CommentsStoryboardIdentifiers.h"

#import "DDDTopStoriesViewController.h"
#import "DDDStoryDetailViewController.h"
#import "DDDCommentsViewController.h"
#import "DDDReadLaterViewController.h"

@interface DDDMainViewController ()
@property (weak, nonatomic) DDDContentViewController *contentViewController;
@end

@implementation DDDMainViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupNavigationRouter];
}

- (void)setupNavigationRouter
{
    self.navigationRouter = [[DDDViewControllerRouter alloc] initWithNavigationController:self.navigationController];
    [self.navigationRouter updateScreenMapping:@{
                                                 DDDTopStoriesViewControllerIdentifier : @{ @"viewClass" : [DDDTopStoriesViewController class], @"isRootView" : @(YES) },
                                                 DDDStoryDetailViewControllerIdentifier : @{ @"viewClass" : [DDDStoryDetailViewController class], @"isRootView" : @(NO) },
                                                 DDDCommentsViewControllerIdentifier : @{ @"viewClass" : [DDDCommentsViewController class], @"isRootView" : @(NO) },
                                                 DDDSavedStoriesViewControllerIdentifier : @{ @"viewClass" : [DDDReadLaterViewController class], @"isRootView" : @(NO) }
                                                 }];
}

- (NSDictionary *)segueIdentifierToContainerViewControllerMapping
{
    return @{
             DDDEmbedContentViewIdentifier : @keypath(self.contentViewController)
             };
}

@end
