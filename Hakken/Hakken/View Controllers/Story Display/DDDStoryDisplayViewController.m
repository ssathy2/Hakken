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

#import "TopStoryStoryboardIdentifiers.h"
#import "DetailStoryboardIdentifiers.h"
#import "CommentsStoryboardIdentifiers.h"

#import "DDDTransitionAttributes.h"
#import "DDDStoryTransitionModel.h"

#import "DDDHackerNewsItem.h"
#import "DDDCollectionViewCellSizingHelper.h"

#import "UIPanGestureRecognizer+Helpers.h"
#import "DDDLoadingCollectionReusableView.h"

@interface DDDStoryDisplayViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIGestureRecognizerDelegate>
@end

@interface DDDStoryDisplayViewController()
@property (assign, nonatomic) BOOL viewIsVisible;
@property (strong, nonatomic) UIPanGestureRecognizer *cellSwipePangestureRecognizer;
@property (strong, nonatomic) NSIndexPath *previousCellSwipedIndexPath;
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

    [self setupCellSwipePanGestureRecognizer];
    [self setupCollectionView];
    [self setupFlowLayout];
    [self setupListenersToViewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewIsVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.viewIsVisible = NO;
}

#pragma mark - Setup Methods

- (void)setupCellSwipePanGestureRecognizer
{
    self.cellSwipePangestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.cellSwipePangestureRecognizer.maximumNumberOfTouches = 1;
    self.cellSwipePangestureRecognizer.minimumNumberOfTouches = 1;
    self.cellSwipePangestureRecognizer.delegate = self;
}

- (void)setupCollectionView
{
    self.collectionView.delegate     = self;
    self.collectionView.dataSource   = self;
    
    [self.collectionView addGestureRecognizer:self.cellSwipePangestureRecognizer];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDHackerNewsItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDLoadingCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DDDLoadingCollectionResuableViewIdentifier];
}

- (void)setupFlowLayout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.footerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 50.f);
}

- (void)setupListenersToViewModel
{
    RACSignal *latestStoriesUpdateSignal = [[self storyDisplayViewModel].latestStoriesUpdate.arrayChangedSignal filter:^BOOL(id value) {
                                                return value != nil;
                                            }];
    __weak typeof(self) weakSelf = self;
    [latestStoriesUpdateSignal subscribeNext:^(DDDArrayInsertionDeletion *latestInsertionDeletion) {
        DDLogInfo(@"latestInsertionDeletion: %@", latestInsertionDeletion);
        [weakSelf updateWithInsertionDeletion:latestInsertionDeletion];
    } error:^(NSError *error) {
        DDLogError(@"%@", error);
    } completed:^{
        DDLogInfo(@"Complete!");
    }];
}

#pragma mark - UIGestureRecognizer Related
- (void)handlePanGesture:(UIPanGestureRecognizer *)pangestureRecognizer
{
    CGPoint locationInCollectionView = [pangestureRecognizer locationInView:self.collectionView];
    NSIndexPath *cellIdxPath = [self.collectionView indexPathForItemAtPoint:locationInCollectionView];

    if (pangestureRecognizer.state == UIGestureRecognizerStateBegan)
        self.previousCellSwipedIndexPath = cellIdxPath;
    else if ((pangestureRecognizer.state == UIGestureRecognizerStateEnded) || (pangestureRecognizer.state == UIGestureRecognizerStateFailed))
    {
        self.previousCellSwipedIndexPath = nil;
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(DDDHackerNewsItemCollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
            if ([cell respondsToSelector:@selector(handlePanGesture:)])
                [cell handlePanGesture:pangestureRecognizer];
        }];
    }

    DDDHackerNewsItemCollectionViewCell *newsItemCollectionViewCell = (DDDHackerNewsItemCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.previousCellSwipedIndexPath];
    if ([newsItemCollectionViewCell respondsToSelector:@selector(handlePanGesture:)])
        [newsItemCollectionViewCell handlePanGesture:pangestureRecognizer];
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.collectionView];
    return (translation.y * translation.y < translation.x * translation.x);
}

- (void)updateWithInsertionDeletion:(DDDArrayInsertionDeletion *)insertionDeletion
{
    if (insertionDeletion)
    {
        if (self.viewIsVisible)
        {
            if (insertionDeletion.indexesInserted && insertionDeletion.indexesDeleted)
            {
                [self.collectionView performBatchUpdates:^{
                        [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
                        [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesDeleted]];
                } completion:^(BOOL finished) {
                    
                }];
            }
            else if (insertionDeletion.indexesDeleted && !insertionDeletion.indexesInserted)
                [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesDeleted]];
            else if (!insertionDeletion.indexesDeleted && insertionDeletion.indexesInserted)
                [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];

        }
        else
            [self.collectionView reloadData];
    }
}

- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)set
{
    if (!set)
        return nil;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSUInteger currentIndex = [set firstIndex];
    while (currentIndex != NSNotFound)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
        currentIndex = [set indexGreaterThanIndex:currentIndex];
    }
    return indexPaths;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items = [[[[self storyDisplayViewModel] latestStoriesUpdate] array] count];
    DDLogDebug(@"%@ count-> %li", NSStringFromSelector(_cmd), (long)items);
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDHackerNewsItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell prepareWithModel:[[[self storyDisplayViewModel] latestStoriesUpdate] array][indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DDDLoadingCollectionReusableView *loadingView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DDDLoadingCollectionResuableViewIdentifier forIndexPath:indexPath];
    [loadingView setLabel:@"Loading Stories"];
    return loadingView;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDHackerNewsItem *item = [[[self storyDisplayViewModel] latestStoriesUpdate] array][indexPath.row];
    CGSize size = [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDHackerNewsItemCollectionViewCell class] withCellModel:item withModelIdentifier:[@(item.id) stringValue]];
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    if (![[self storyDisplayViewModel] canLoadMoreStories])
        return CGSizeZero;
    else
        return flowLayout.footerReferenceSize;
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
    
    [[[self storyDisplayViewModel] markStoryAsRead:item] subscribeNext:^(id x) {
        [[[self storyDisplayViewModel] latestStoriesUpdate] updateItemAtIndex:indexPath.row withItems:x];
    } completed:^{
        DDLogInfo(@"Update completed!");
    }];
    
    // push webview/comments controller here...
    if (item.isUserGenerated)
        [self.navigationController transitionToScreen:DDDCommentsViewControllerIdentifier withAttributes:attrs animated:YES];
    else
        [self.navigationController transitionToScreen:DDDStoryDetailViewControllerIdentifier withAttributes:attrs animated:YES];
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
    [self.navigationController transitionToScreen:DDDCommentsViewControllerIdentifier withAttributes:attrs animated:YES];
}

- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectAddToReadLater:(DDDHackerNewsItem *)story withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)errorBlock
{
    __block DDDHackerNewsItem *item;
    [[[self storyDisplayViewModel] saveStoryToReadLater:story] subscribeNext:^(id x) {
        item = x;
    } error:^(NSError *error) {
        errorBlock(error);
    } completed:^{
        completion(item);
    }];
}

- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectRemoveFromReadLater:(DDDHackerNewsItem *)story withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)errorBlock
{
    __block DDDHackerNewsItem *item;
    [[[self storyDisplayViewModel] removeStoryFromReadLater:story] subscribeNext:^(id x) {
        item = x;
    } error:^(NSError *error) {
        errorBlock(error);
    } completed:^{
        completion(item);
    }];
}

@end
