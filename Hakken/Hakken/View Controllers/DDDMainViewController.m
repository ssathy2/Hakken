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

#import "DDDStoryPreviewViewController.h"
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
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    [self.vcRouter updateScreenMapping:@{
                                         DDDStoryPreviewViewControllerIdentifier : @{ @"viewClass" : [DDDStoryPreviewViewController class] },
                                         DDDTopStoriesViewControllerIdentifier : @{ @"viewClass" : [DDDTopStoriesViewController class] },
                                         DDDStoryDetailViewControllerIdentifier : @{ @"viewClass" : [DDDStoryDetailViewController class] },
                                         DDDCommentsViewControllerIdentifier : @{ @"viewClass" : [DDDCommentsViewController class] },
                                         DDDSavedStoriesViewControllerIdentifier : @{ @"viewClass" : [DDDReadLaterViewController class] }
                                         }];

    [self.vcRouter showScreen:DDDTopStoriesViewControllerIdentifier usingNavigationController:self.splitViewController.viewControllers[0] withAttributes:nil animated:YES];
}
@end
