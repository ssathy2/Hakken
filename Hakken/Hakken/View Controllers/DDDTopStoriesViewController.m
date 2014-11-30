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
//    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.storiesCollectionView.collectionViewLayout;
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
    [self.storiesCollectionView performBatchUpdates:^{
        if (insertionDeletion.indexesInserted)
            [self.storiesCollectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
        if (insertionDeletion.indexesDeleted)
            [self.storiesCollectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
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
    DDDTopStoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDTopStoriesCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell prepareWithModel:[[[self topStoriesViewModel] latestTopStoriesUpdate] array][indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // push webview/comments controller here...
}

@end
