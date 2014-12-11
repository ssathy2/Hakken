//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewController.h"
#import "TopStoryStoryboardIdentifiers.h"
#import "DDDTopStoriesViewModel.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDHackerNewsItemCollectionViewCell.h"
#import "DDDExpandTransition.h"
#import "DetailStoryboardIdentifiers.h"
#import "DDDTransitionAttributes.h"
#import "DDDStoryDetailTransitionModel.h"

@interface DDDTopStoriesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>
@end

@implementation DDDTopStoriesViewController

+ (NSString *)storyboardName
{
    return DDDTopStoriesStoryboardName;
}

+ (NSString *)storyboardIdentifier
{
    return DDDTopStoriesViewControllerIdentifier;
}

+ (Class)viewModelClass
{
    return [DDDTopStoriesViewModel class];
}

- (DDDTopStoriesViewModel *)topStoriesViewModel
{
    return (DDDTopStoriesViewModel *)self.viewModel;
}

#pragma mark - UIViewController Lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupListenersToViewModel];
    [self setupCollectionView];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.delegate == self)
        self.navigationController.delegate = nil;
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    // Check if we're transitioning from this view controller to a DDDViewController
    if (fromVC == self && [toVC isKindOfClass:[DDDViewController class]])
        return [DDDExpandTransition new];
    else
        return nil;
}

- (void)setupCollectionView
{
    self.collectionView.delegate     = self;
    self.collectionView.dataSource   = self;
//
    [self.collectionView registerNib:[UINib nibWithNibName:@"DDDHackerNewsItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.estimatedItemSize = CGSizeMake(flowLayout.itemSize.width, flowLayout.itemSize.height);
}

- (void)setupListenersToViewModel
{
    [RACObserve([self topStoriesViewModel], latestTopStoriesUpdate)
     subscribeNext:^(DDDArrayInsertionDeletion *latestInsertionDeletion) {
         DDLogInfo(@"latestInsertionDeletion: %@", latestInsertionDeletion);
         [self updateWithInsertionDeletion:latestInsertionDeletion];
     } error:^(NSError *error) {
         DDLogError(@"%@", error);
     } completed:^{
         DDLogInfo(@"Complete!");
     }];
}

- (void)updateWithInsertionDeletion:(DDDArrayInsertionDeletion *)insertionDeletion
{
    [self.collectionView performBatchUpdates:^{
        if (insertionDeletion.indexesInserted)
            [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
        if (insertionDeletion.indexesDeleted)
            [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
    } completion:nil];
}

- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)set
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSUInteger currentIndex = [set firstIndex];
    while (currentIndex != NSNotFound) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
        currentIndex = [set indexGreaterThanIndex:currentIndex];
    }
    return indexPaths;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[[self topStoriesViewModel] latestTopStoriesUpdate] array] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDHackerNewsItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell prepareWithModel:[[[self topStoriesViewModel] latestTopStoriesUpdate] array][indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (UIView *)getViewSnapshotAboveCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellRect = [[self.collectionView cellForItemAtIndexPath:indexPath] frame];
    CGRect snapShotRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.collectionView.frame.size.width, cellRect.origin.y-self.view.frame.origin.y);
    
    UIView *snapShot = [self.view resizableSnapshotViewFromRect:snapShotRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    return snapShot;
}

- (UIView *)getViewSnapshotBelowCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellRect = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
    
    CGPoint cellOrigin = [self.view convertPoint:[self.collectionView cellForItemAtIndexPath:indexPath].frame.origin toView:self.view];
    CGRect snapShotRect = CGRectMake(self.view.frame.origin.x, cellOrigin.y+cellRect.size.height, self.view.frame.size.width, CGRectGetMaxY(self.view.frame) - cellOrigin.y);
    
    UIView *snapShot = [self.view resizableSnapshotViewFromRect:snapShotRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    return snapShot;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *topHalf = [self getViewSnapshotAboveCellAtIndexPath:indexPath];
    UIView *bottomHalf = [self getViewSnapshotBelowCellAtIndexPath:indexPath];

    DDDStoryDetailTransitionModel *transitionModel = [DDDStoryDetailTransitionModel new];
    transitionModel.topPeekView = topHalf;
    transitionModel.bottomPeekView = bottomHalf;
    transitionModel.story = [[[self topStoriesViewModel] latestTopStoriesUpdate].array objectAtIndex:indexPath.row];
    
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.model = transitionModel;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // push webview/comments controller here...
    [self.navigationRouter transitionToScreen:DDDStoryDetailViewControllerIdentifier withAttributes:attrs animated:YES];
}

@end
