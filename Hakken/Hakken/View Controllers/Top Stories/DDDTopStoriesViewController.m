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
#import "DDDRightNavigationView.h"

@interface DDDTopStoriesViewController()
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) DDDRightNavigationView *rightNavView;
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
    [self setupRefreshControl];
    [self setupNavigationButton];
    [self setupReactions];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateNavViewAnimated:NO];
}

- (void)setupNavigationButton
{
    self.rightNavView = [DDDRightNavigationView instance];
    [self.rightNavView setBackgroundColor:[UIColor clearColor]];
    CGRect navFrame      = self.rightNavView.frame;
    navFrame.size.height = 35.f;
    navFrame.size.width  = 40.f;
    navFrame.origin.x    = 0.f;
    self.rightNavView.frame = navFrame;
    [self.rightNavView addTarget:self action:@selector(readLaterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.rightNavView]];
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

- (void)updateNavViewAnimated:(BOOL)animated
{
    __block NSInteger savedStoriesCount = 0;
    [[[self topstoriesViewModel] fetchAllSavedStories] subscribeNext:^(NSArray *savedStories) {
        savedStoriesCount = savedStories.count;
    } error:^(NSError *error) {
        
    } completed:^{
        [self updateNavViewWithCount:savedStoriesCount animated:animated];
    }];
}

- (void)updateNavViewWithCount:(NSInteger)count animated:(BOOL)animated
{
    if (count == 0)
        [self.rightNavView setNumberViewHidden:YES animated:animated];
    else
    {
        [self.rightNavView setNumberViewHidden:NO animated:animated];
        [self.rightNavView setNumber:count animated:animated withCustomAnimations:nil];
    }
}

- (void)handleErrorState
{
    [self.refreshControl endRefreshing];
}

- (void)readLaterButtonTapped:(id)sender
{
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.presentModally = YES;
    [self.navigationController transitionToScreen:DDDSavedStoriesViewControllerIdentifier withAttributes:attrs animated:YES];
}

- (void)setupRefreshControl
{
    self.refreshControl = [UIRefreshControl new];
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

#pragma mark - DDDHackerNewsItemCollectionViewCellDelegate
- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectAddToReadLater:(DDDHackerNewsItem *)story withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error
{
    [super cell:cell didSelectAddToReadLater:story withCompletion:completion withError:error];
    [self updateNavViewAnimated:YES];
}

- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectRemoveFromReadLater:(DDDHackerNewsItem *)story withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error
{
    [super cell:cell didSelectRemoveFromReadLater:story withCompletion:completion withError:error];
    [self updateNavViewAnimated:YES];
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
