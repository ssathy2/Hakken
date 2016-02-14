//
//  DDDRootViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDMainViewController.h"
#import "MainStoryboardIdentifiers.h"
#import "TopStoryStoryboardIdentifiers.h"
#import "DetailStoryboardIdentifiers.h"
#import "CommentsStoryboardIdentifiers.h"

#import "DDDTopStoriesViewController.h"
#import "DDDStoryDetailViewController.h"
#import "DDDCommentsViewController.h"
#import "DDDReadLaterViewController.h"
#import "UINavigationBar+Styling.h"

@interface DDDMainViewController ()
@property (weak, nonatomic) UISplitViewController *splitViewController;
@end

@implementation DDDMainViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:DDDEmbedSpltViewController])
        self.splitViewController = segue.destinationViewController;
}

// Accessor
- (DDDViewControllerRouter *)vcRouter
{
    return [DDDViewControllerRouter sharedInstance];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupNavigationRouter];
}

- (void)setupNavigationRouter
{
    [UINavigationBar applyGlobalNavigationBarStyles];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.vcRouter setupWithSplitViewController:self.splitViewController];
    [self.vcRouter updateScreenMapping:@{
                                         DDDTopStoriesViewControllerIdentifier : @{ @"viewClass" : [DDDTopStoriesViewController class], @"isRootView" : @(YES) },
                                         DDDStoryDetailViewControllerIdentifier : @{ @"viewClass" : [DDDStoryDetailViewController class], @"isRootView" : @(NO) },
                                         DDDCommentsViewControllerIdentifier : @{ @"viewClass" : [DDDCommentsViewController class], @"isRootView" : @(NO) },
                                         DDDSavedStoriesViewControllerIdentifier : @{ @"viewClass" : [DDDReadLaterViewController class], @"isRootView" : @(NO) }
                                         }];

    [self.vcRouter showScreenInMaster:DDDTopStoriesViewControllerIdentifier withAttributes:nil animated:YES];
}
@end
