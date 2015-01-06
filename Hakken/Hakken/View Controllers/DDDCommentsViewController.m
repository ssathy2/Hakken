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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self commentsViewModel] commentCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDCommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDCommentCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell prepareWithModel:[[self commentsViewModel] commentTreeInfoForIndexPath:indexPath]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDDCommentTreeInfo *treeInfo = [[self commentsViewModel] commentTreeInfoForIndexPath:indexPath];
    return [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDCommentCollectionViewCell class] withCellModel:treeInfo withModelIdentifier:treeInfo.comment.identifier];
}

@end
