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
#import "DDDTopStoriesCollectionViewCell.h"

@interface DDDTopStoriesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *storiesCollectionView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupListenersToViewModel];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    self.storiesCollectionView.delegate     = self;
    self.storiesCollectionView.dataSource   = self;
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
    [self.storiesCollectionView performBatchUpdates:^{
        if (insertionDeletion.indexesInserted)
            [self.storiesCollectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
        if (insertionDeletion.indexesDeleted)
            [self.storiesCollectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
    } completion:^(BOOL finished) {
       
    }];
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
    DDDTopStoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDTopStoriesCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell prepareWithModel:[[[self topStoriesViewModel] latestTopStoriesUpdate] array][indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.selectedIndexPath)
    {
        [collectionView performBatchUpdates:nil completion:nil];
        [self collectionView:collectionView deselectCellAtIndexPath:self.selectedIndexPath];
    }
    else
    {
        self.selectedIndexPath = indexPath;
        // deselect cell at indexpath at previous indexpath
        // IndexPath of cell to be expanded
        [collectionView performBatchUpdates:nil completion:nil];
        [self collectionView:collectionView selectCellAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView deselectCellAtIndexPath:(NSIndexPath *)indexPath
{
    DDDTopStoriesCollectionViewCell *cell = (DDDTopStoriesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCollapseState:DDDCellCollapseStateCollapsed];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView selectCellAtIndexPath:(NSIndexPath *)indexPath
{
    DDDTopStoriesCollectionViewCell *cell = (DDDTopStoriesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCollapseState:DDDCellCollapseStateNotCollapsed];
    [cell loadURLIfNecessary];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGSize newSize = CGSizeMake(collectionView.bounds.size.width, flowLayout.itemSize.height);
    if (indexPath == self.selectedIndexPath)
        newSize.height = collectionView.bounds.size.height;
    return newSize;
}

@end
