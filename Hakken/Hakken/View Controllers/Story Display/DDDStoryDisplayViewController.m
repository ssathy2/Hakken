//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDisplayViewController.h"

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

@interface DDDStoryDisplayViewController ()<
DDDHackerNewsItemCollectionViewCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate>
@end

@interface DDDStoryDisplayViewController()
@property (nonatomic, assign) CGFloat previousScrollViewYOffset;
@end

@implementation DDDStoryDisplayViewController

+ (NSString *)storyboardName
{
    return DDDTopStoriesStoryboardName;
}

+ (NSString *)storyboardIdentifier
{
    DDLogError(@"To use the stories display vc, the subclass of this vc must define the storyboard identifier");
    return nil;
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
    
    self.collectionView.panGestureRecognizer.enabled = NO;
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
    if (insertionDeletion)
    {
        [self.collectionView reloadData];
        // TODO: Fix collectionview perform batch updates assertion failure
//        [self.collectionView performBatchUpdates:^{
//            if (insertionDeletion.indexesInserted)
//                [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
//            if (insertionDeletion.indexesDeleted)
//                [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesDeleted]];
//        } completion:^(BOOL finished) {
//            
//        }];
    }
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
    CGSize size = [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDHackerNewsItemCollectionViewCell class] withCellModel:item withModelIdentifier:@(item.id)];
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self shrinkCellAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self expandCellAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self shrinkCellAtIndexPath:indexPath animated:YES];
    [self expandCellAtIndexPath:indexPath animated:YES];
    
    DDDStoryTransitionModel *transitionModel = [DDDStoryTransitionModel new];
    DDDHackerNewsItem *item = [[[self storyDisplayViewModel] latestStoriesUpdate].array objectAtIndex:indexPath.row];
    transitionModel.story = item;
    
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.model = transitionModel;
    
    // push webview/comments controller here...
    if (item.isUserGenerated)
        [self.navigationRouter transitionToScreen:DDDCommentsViewControllerIdentifier withAttributes:attrs animated:YES];
    else
        [self.navigationRouter transitionToScreen:DDDStoryDetailViewControllerIdentifier withAttributes:attrs animated:YES];
}


- (void)shrinkCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.transform = CGAffineTransformMakeScale(0.85f, 0.85);
                        } completion:^(BOOL finished) {
                        }];
}

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        } completion:^(BOOL finished) {
                        }];
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

- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectAddToReadLater:(DDDHackerNewsItem *)story
{
    [[self storyDisplayViewModel] saveStoryToReadLater:story completion:^(DDDHackerNewsItem *item) {
       
    } error:^(NSError *error) {
       
    }];
}

- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectRemoveFromReadLater:(DDDHackerNewsItem *)story
{
    [[self storyDisplayViewModel] removeStoryFromReadLater:story completion:^(DDDHackerNewsItem *item) {
      
    } error:^(NSError *error) {
      
    }];
}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGRect frame = self.navigationController.navigationBar.frame;
//    CGFloat size = frame.size.height - 21;
//    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
//    CGFloat scrollOffset = scrollView.contentOffset.y;
//    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
//    CGFloat scrollHeight = scrollView.frame.size.height;
//    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
//    
//    if (scrollOffset <= -scrollView.contentInset.top) {
//        frame.origin.y = 20;
//    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
//        frame.origin.y = -size;
//    } else {
//        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
//    }
//    
//    [self.navigationController.navigationBar setFrame:frame];
//    [self updateBarButtonItems:(1 - framePercentageHidden)];
//    self.previousScrollViewYOffset = scrollOffset;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self stoppedScrolling];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//                  willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate) {
//        [self stoppedScrolling];
//    }
//}
//
//- (void)stoppedScrolling
//{
//    CGRect frame = self.navigationController.navigationBar.frame;
//    if (frame.origin.y < 20) {
//        [self animateNavBarTo:-(frame.size.height - 21)];
//    }
//}
//
//- (void)updateBarButtonItems:(CGFloat)alpha
//{
//    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
//        item.customView.alpha = alpha;
//    }];
//    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
//        item.customView.alpha = alpha;
//    }];
//    self.navigationItem.titleView.alpha = alpha;
//    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
//}
//
//- (void)animateNavBarTo:(CGFloat)y
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = self.navigationController.navigationBar.frame;
//        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
//        frame.origin.y = y;
//        [self.navigationController.navigationBar setFrame:frame];
//        [self updateBarButtonItems:alpha];
//    }];
//}
@end
