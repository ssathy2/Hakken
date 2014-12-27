//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewController.h"

#import "DDDTopStoriesViewModel.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDHackerNewsItemCollectionViewCell.h"

#import "TopStoryStoryboardIdentifiers.h"
#import "DetailStoryboardIdentifiers.h"
#import "CommentsStoryboardIdentifiers.h"

#import "DDDTransitionAttributes.h"
#import "DDDStoryTransitionModel.h"
#import "DDDTopStoriesPushAnimator.h"

@interface DDDTopStoriesViewController ()<DDDHackerNewsItemCollectionViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);
{
    // Check if we're transitioning from this view controller to a DDDViewController
    if (fromVC == self && [toVC isKindOfClass:[DDDViewController class]])
        return [DDDTopStoriesPushAnimator new];
    else
        return nil;
}

- (void)setupCollectionView
{
    self.collectionView.delegate     = self;
    self.collectionView.dataSource   = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DDDHackerNewsItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
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
        [self.collectionView.collectionViewLayout invalidateLayout];
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
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [DDDHackerNewsItemCollectionViewCell adjustedCellSizeWithModel:[[[self topStoriesViewModel] latestTopStoriesUpdate] array][indexPath.row]];
}

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

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.8f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.transform = CGAffineTransformMakeScale(0.95f, 0.95);
                        } completion:^(BOOL finished) {
                        }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        } completion:^(BOOL finished) {
                        }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *topHalf = [self getViewSnapshotAboveCellAtIndexPath:indexPath];
    UIView *bottomHalf = [self getViewSnapshotBelowCellAtIndexPath:indexPath];

    DDDStoryTransitionModel *transitionModel = [DDDStoryTransitionModel new];
    transitionModel.topPeekView = topHalf;
    transitionModel.bottomPeekView = bottomHalf;
    transitionModel.story = [[[self topStoriesViewModel] latestTopStoriesUpdate].array objectAtIndex:indexPath.row];
    
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.model = transitionModel;
    
    // push webview/comments controller here...
    [self.navigationRouter transitionToScreen:DDDStoryDetailViewControllerIdentifier withAttributes:attrs animated:YES];
}

#pragma mark - DDDHackerNewsItemCollectionViewCellDelegate
- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectCommentsButton:(DDDHackerNewsItem *)story
{
    DDDStoryTransitionModel *transitionModel = [DDDStoryTransitionModel new];
    transitionModel.story = story;
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.model = transitionModel;
    
    // push webview/comments controller here...
    [self.navigationRouter transitionToScreen:DDDCommentsViewControllerIdentifier withAttributes:attrs animated:YES];
}


@end
