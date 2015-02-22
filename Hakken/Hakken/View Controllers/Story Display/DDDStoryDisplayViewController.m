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

#import "UIPanGestureRecognizer+Helpers.h"

@interface DDDStoryDisplayViewController ()<
DDDHackerNewsItemCollectionViewCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate>
@end

@interface DDDStoryDisplayViewController()
@property (assign, nonatomic) BOOL viewIsVisible;
@property (strong, nonatomic) UIPanGestureRecognizer *cellSwipePangestureRecognizer;

@property (strong, nonatomic) UIPanGestureRecognizer *collectionViewPanGestureRecognizer;
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
    [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.cellSwipePangestureRecognizer];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDHackerNewsItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
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
    DDDHackerNewsItemCollectionViewCell *newsItemCollectionViewCell = (DDDHackerNewsItemCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:cellIdxPath];
    if ([newsItemCollectionViewCell respondsToSelector:@selector(handlePanGesture:)])
        [newsItemCollectionViewCell handlePanGesture:pangestureRecognizer];
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.cellSwipePangestureRecognizer])
    {
        UIPanGestureRecognizerDirection direction = [gestureRecognizer panGestureDirectionInView:self.collectionView];
        return (direction & UIPanGestureRecognizerDirectionLeft) || (direction & UIPanGestureRecognizerDirectionRight);
    }
    else
        return YES;
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
    DDLogDebug(@"%@ count-> %li", NSStringFromSelector(_cmd), items);
    return items;
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
