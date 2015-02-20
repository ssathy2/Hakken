//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/9/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewController.h"
#import "DDDTopStoriesViewModel.h"
#import "DDDTransitionAttributes.h"
#import "TopStoryStoryboardIdentifiers.h"
#import "DDDArrayInsertionDeletion.h"

@interface DDDTopStoriesViewController()
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation DDDTopStoriesViewController

+ (Class)viewModelClass
{
    return [DDDTopStoriesViewModel class];
}

+ (NSString *)storyboardIdentifier
{
    return DDDTopStoriesViewControllerIdentifier;
}

- (DDDTopStoriesViewModel *)topstoriesViewModel
{
    return (DDDTopStoriesViewModel *)self.viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupReactions];
    [self setupRefreshControl];
}

- (void)setupReactions
{
    [RACObserve(self.viewModel, viewModelError)
    subscribeNext:^(id x) {
        DDLogError(@"%@", x);
    } error:^(NSError *error) {
        DDLogError(@"%@", error);
    } completed:^{
        [self handleErrorState];
    }];
}

- (void)handleErrorState
{
    [self.refreshControl endRefreshing];
}

- (IBAction)readLaterButtonTapped:(id)sender
{
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.presentModally = YES;
    [self.navigationController transitionToScreen:DDDSavedStoriesViewControllerIdentifier withAttributes:attrs animated:YES];
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)refreshControlValueChanged
{
    [[self topstoriesViewModel] refreshCurrentBatchOfStories];
}

- (void)updateWithInsertionDeletion:(DDDArrayInsertionDeletion *)insertionDeletion
{
    [super updateWithInsertionDeletion:insertionDeletion];
    [self.refreshControl endRefreshing];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        // then we are at the top
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        // then we are at the end
        [[self topstoriesViewModel] fetchNextBatchOfStories];
    }
}

@end
