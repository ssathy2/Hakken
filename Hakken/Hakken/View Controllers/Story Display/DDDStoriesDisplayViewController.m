//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoriesDisplayViewController.h"

#import "DDDTopStoriesViewModel.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDHackerNewsItemCollectionViewCell.h"

#import "TopStoryStoryboardIdentifiers.h"
#import "DetailStoryboardIdentifiers.h"
#import "CommentsStoryboardIdentifiers.h"

#import "DDDTransitionAttributes.h"
#import "DDDStoryTransitionModel.h"

#import "DDDHackerNewsItem.h"
#import "DDDCollectionViewCellSizingHelper.h"

@interface DDDStoriesDisplayViewController ()<
DDDHackerNewsItemCollectionViewCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UINavigationControllerDelegate>
@end

@implementation DDDStoriesDisplayViewController

+ (NSString *)storyboardName
{
    return DDDTopStoriesStoryboardName;
}

+ (NSString *)storyboardIdentifier
{
    return DDDTopStoriesViewControllerIdentifier;
}

#pragma mark - Helpers
- (DDDStoryDisplayViewModel *)storyDisplayViewModel
{
    return (DDDStoryDisplayViewModel *)self.viewModel;
}

#pragma mark - UIViewController Lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupListenersToViewModel];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    self.collectionView.delegate     = self;
    self.collectionView.dataSource   = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DDDHackerNewsItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
}

- (void)setupListenersToViewModel
{
    [RACObserve([self storyDisplayViewModel], latestStoriesUpdate)
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
    [self.collectionView reloadData];
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
    return [[[[self storyDisplayViewModel] latestStoriesUpdate] array] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDHackerNewsItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell prepareWithModel:[[[self storyDisplayViewModel] latestStoriesUpdate] array][indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDHackerNewsItem *item = [[[self storyDisplayViewModel] latestStoriesUpdate] array][indexPath.row];
    CGSize size = [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDHackerNewsItemCollectionViewCell class] withCellModel:item withModelIdentifier:item.identifier];
    return size;
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
    DDDStoryTransitionModel *transitionModel = [DDDStoryTransitionModel new];
    transitionModel.story = [[[self storyDisplayViewModel] latestStoriesUpdate].array objectAtIndex:indexPath.row];
    
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
