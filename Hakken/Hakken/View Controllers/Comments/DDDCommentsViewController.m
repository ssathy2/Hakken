//
//  DDDCommentsViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCommentsViewController.h"
#import "CommentsStoryboardIdentifiers.h"
#import "DDDCommentsViewModel.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDCommentCollectionViewCell.h"
#import "DDDCommentsCollectionViewFlowLayout.h"
#import "DDDCommentTreeInfo.h"
#import "DDDHackerNewsComment.h"
#import "DDDCollectionViewCellSizingHelper.h"
#import "DDDHackernewsItemCollectionViewCell.h"
#import "DDDHackernewsUserItemCollectionViewCell.h"
#import "DDDLoadingCollectionReusableView.h"
#import "DDDStoryTransitionModel.h"
#import "DDDTransitionAttributes.h"
#import "DetailStoryboardIdentifiers.h"
#import <SafariServices/SFSafariViewController.h>

typedef NS_ENUM(NSInteger, DDDCommentsSection)
{
    DDDCommentsSectionHeader,
    DDDCommentsSectionComments,
    
    DDDCommentsSectionCount
};

@interface DDDCommentsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, DDDCommentsViewModelDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL viewIsVisible;
@end

@implementation DDDCommentsViewController
@dynamic indexPathsCollapsedBlock, indexPathsExpandedBlock;
+ (NSString *)storyboardIdentifier
{
    return DDDCommentsViewControllerIdentifier;
}

+ (NSString *)storyboardName
{
    return CommentsStoryboardName;
}

+ (Class)viewModelClass
{
    return [DDDCommentsViewModel class];
}

- (DDDCommentsViewModel *)commentsViewModel
{
    return (DDDCommentsViewModel *)self.viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self commentsViewModel] setDelegate:self];
    [[[self commentsViewModel] markStoryAsRead] subscribeNext:^(id x) {
        DDLogInfo(@"X: x");
    } completed:^{
        DDLogInfo(@"Story Mark as read!");
    }];
    
    // Do any additional setup after loading the view.
    [self setupViewModelListeners];
    [self setupCollectionView];
    [self setupRefreshControl];
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

- (void)setupRefreshControl
{
    self.refreshControl             = [UIRefreshControl new];
    self.refreshControl.tintColor   = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    [[self commentsViewModel] refreshComments];
}

- (void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDCommentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDCommentCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDHackerNewsItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDHackernewsUserItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDHackernewsUserItemCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDLoadingCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DDDLoadingCollectionResuableViewIdentifier];
    
    DDDCommentsCollectionViewFlowLayout *commentsCollectionViewLayout = (DDDCommentsCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;    
    [commentsCollectionViewLayout setCommentsViewModel:[self commentsViewModel]];
    [commentsCollectionViewLayout setFooterReferenceSize:CGSizeMake(self.collectionView.frame.size.width, 50.f)];
}

- (void)setupViewModelListeners
{
    __weak typeof(self) weakSelf = self;
    RACSignal *signal = [self commentsViewModel].latestComments.arrayChangedSignal;
    signal = [signal filter:^BOOL(id value) {
        return value != nil;
    }];
    [signal subscribeNext:^(DDDArrayInsertionDeletion *latestInsertionDeletion) {
         DDLogInfo(@"latestInsertionDeletion: %@", latestInsertionDeletion);
        [weakSelf updateWithInsertionDeletion:latestInsertionDeletion];
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
        if (self.viewIsVisible)
        {
            if (insertionDeletion.indexesInserted.count > 0 && insertionDeletion.indexesDeleted.count > 0)
            {
                [self.collectionView.collectionViewLayout invalidateLayout];
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
                    [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesDeleted]];
                } completion:nil];
            }
            else if (insertionDeletion.indexesDeleted.count > 0 && insertionDeletion.indexesInserted.count == 0)
            {
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesDeleted]];
                } completion:nil];
            }
            else if (insertionDeletion.indexesDeleted.count == 0 && insertionDeletion.indexesInserted.count > 0)
            {
                [self.collectionView.collectionViewLayout invalidateLayout];                
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertionDeletion.indexesInserted]];
                } completion:nil];
            }
        }
        else
            [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
    }
}

- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)set
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSUInteger currentIndex = [set firstIndex];
    while (currentIndex != NSNotFound)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:currentIndex inSection:1]];
        currentIndex = [set indexGreaterThanIndex:currentIndex];
    }
    return indexPaths;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDHackerNewsItem *item = [[self commentsViewModel] story];
    if (indexPath.section == DDDCommentsSectionHeader && !item.isUserGenerated)
    {
        DDDStoryTransitionModel *transitionModel = [DDDStoryTransitionModel new];

        transitionModel.story = item;
        
        DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
        attrs.model = transitionModel;
        
        [self.navigationController transitionToScreen:DDDStoryDetailViewControllerIdentifier withAttributes:attrs animated:YES];
    }
    // TODO: Handle URL's tapped in teh cell
    else
    {
        [[self commentsViewModel] toggleChildCommentsExpandedCollapsedWithRootCommentAtIndexPath:indexPath];
        DDDCommentTreeInfo *commentTreeInfo = [[self commentsViewModel] commentTreeInfoForIndexPath:indexPath];
        DDDCommentCollectionViewCell *commentCVC = (DDDCommentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (commentTreeInfo.comment.areChildrenCollapsed)
            [commentCVC showCollapsedView];
        else
            [commentCVC showExpandedView];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self commentsViewModel].story.isUserGenerated && [self commentsViewModel].story.itemType == DDDHackerNewsItemTypeJob)
        return 1;
    else
        return DDDCommentsSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case DDDCommentsSectionComments:
            return [[self commentsViewModel] commentCount];
        case DDDCommentsSectionHeader:
            return 1;
        default:    
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDCollectionViewCell *cell;
    NSString *identifier;
    id model;
    switch (indexPath.section)
    {
        case DDDCommentsSectionHeader:
        {
            if ([self commentsViewModel].story.isUserGenerated)
                identifier = DDDHackernewsUserItemCollectionViewCellIdentifier;
            else
                identifier = DDDHackerNewsItemCollectionViewCellIdentifier;
            model = [[self commentsViewModel] story];
            break;
        }
        case DDDCommentsSectionComments:
        {
            identifier = DDDCommentCollectionViewCellIdentifier;
            model = [[self commentsViewModel] commentTreeInfoForIndexPath:indexPath];
            break;
        }
        default:
            break;
    }
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell prepareWithModel:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DDDLoadingCollectionReusableView *loadingView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DDDLoadingCollectionResuableViewIdentifier forIndexPath:indexPath];
    [loadingView setLabel:@"Loading Comments"];
    return loadingView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    if ([self commentsViewModel].story.isUserGenerated && [self commentsViewModel].story.itemType == DDDHackerNewsItemTypeJob)
        return CGSizeZero;
    else if ([[self commentsViewModel] shouldShowLoadingFooter])
        return flowLayout.footerReferenceSize;
    else
        return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize preferredSize;
    switch (indexPath.section)
    {
        case DDDCommentsSectionHeader:
        {
            DDDHackerNewsItem *item = [[self commentsViewModel] story];
            Class cellKlass = (item.isUserGenerated) ? [DDDHackernewsUserItemCollectionViewCell class] : [DDDHackerNewsItemCollectionViewCell class];
            preferredSize = [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:cellKlass withCellModel:item withModelIdentifier:[@(item.id) stringValue]];
            break;
        }
        case DDDCommentsSectionComments:	
        {
            DDDCommentTreeInfo *treeInfo = [[self commentsViewModel] commentTreeInfoForIndexPath:indexPath];
            if (treeInfo.comment.isCollapsed)
                preferredSize = CGSizeZero;
            else
            {
                preferredSize = [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDCommentCollectionViewCell class] withCellModel:treeInfo withModelIdentifier:[@(treeInfo.comment.id) stringValue]];
                preferredSize.height += 20;
            }
            break;
        }
        default:
        {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
            preferredSize = flowLayout.itemSize;
            break;
        }
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), preferredSize.height);
}

#pragma mark - DDDCommentsViewModelDelegate

- (ArrayParameterBlock)indexPathsCollapsedBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(NSArray *indexPathsCollapsed) {
        if (indexPathsCollapsed.count > 0)
        {
            [weakSelf.collectionView performBatchUpdates:nil completion:nil];
        }
    };
}

- (ArrayParameterBlock)indexPathsExpandedBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(NSArray *indexPathsExpanded) {
        if (indexPathsExpanded.count > 0)
        {
            [weakSelf.collectionView performBatchUpdates:nil completion:nil];
        }
    };
}

@end
