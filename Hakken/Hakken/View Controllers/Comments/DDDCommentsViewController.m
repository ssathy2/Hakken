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

typedef NS_ENUM(NSInteger, DDDCommentsSection)
{
    DDDCommentsSectionHeader,
    DDDCommentsSectionComments,
    
    DDDCommentsSectionCount
};

@interface DDDCommentsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation DDDCommentsViewController

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
    
    // Do any additional setup after loading the view.
    [self setupViewModelListeners];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDCommentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDCommentCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDDHackerNewsItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
    
    DDDCommentsCollectionViewFlowLayout *commentsCollectionViewLayout = (DDDCommentsCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;    
    [commentsCollectionViewLayout setCommentsViewModel:[self commentsViewModel]];
}

- (void)setupViewModelListeners
{
    [RACObserve([self commentsViewModel], latestComments)
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
    [self.collectionView.collectionViewLayout invalidateLayout];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
    switch (indexPath.section)
    {
        case DDDCommentsSectionHeader:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier forIndexPath:indexPath];
            [cell prepareWithModel:[[self commentsViewModel] story]];
            break;
        }
        case DDDCommentsSectionComments:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDCommentCollectionViewCellIdentifier forIndexPath:indexPath];
            [cell prepareWithModel:[[self commentsViewModel] commentTreeInfoForIndexPath:indexPath]];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case DDDCommentsSectionHeader:
        {
            DDDHackerNewsItem *item = [[self commentsViewModel] story];
            return [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDCommentCollectionViewCell class] withCellModel:item withModelIdentifier:@(item.id)];
            break;
        }
        case DDDCommentsSectionComments:
        {
            DDDCommentTreeInfo *treeInfo = [[self commentsViewModel] commentTreeInfoForIndexPath:indexPath];
            return [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDCommentCollectionViewCell class] withCellModel:treeInfo withModelIdentifier:@(treeInfo.comment.id)];
        }
        default:
        {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
            return flowLayout.itemSize;
        }
    }
}

@end
