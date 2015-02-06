//
//  DDDStoryDetailViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDetailViewController.h"
#import "DetailStoryboardIdentifiers.h"
#import "DDDStoryDetailViewModel.h"
#import "DDDStoryTransitionModel.h"
#import "DDDHackerNewsItem.h"
#import "DDDHackerNewsItemCollectionViewCell.h"
#import "DDDWebViewCollectionViewCell.h"
#import "CommentsStoryboardIdentifiers.h"
#import "DDDCollectionViewCellSizingHelper.h"
#import "DDDTransitionAttributes.h"

@interface DDDStoryDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, DDDHackerNewsItemCollectionViewCellDelegate>
@end

@implementation  DDDStoryDetailViewController

+ (NSString *)storyboardIdentifier
{
    return DDDStoryDetailViewControllerIdentifier;
}

+ (NSString *)storyboardName
{
    return DetailStoryboardName;
}

+ (Class)viewModelClass
{
    return [DDDStoryDetailViewModel class];
}

- (DDDStoryDetailViewModel *)storyDetailViewModel
{
    return (DDDStoryDetailViewModel *)self.viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCollectionView];
    [self setupListenersToViewModel];
}

- (void)setupCollectionView
{
    self.collectionView.dataSource  = self;
    self.collectionView.delegate    = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DDDHackerNewsItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DDDWebViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DDDWebViewCollectionViewCellIdentifier];
}

- (void)setupListenersToViewModel
{
    [RACObserve([self storyDetailViewModel], transitionModel)
     subscribeNext:^(DDDStoryTransitionModel *transitionModel) {
         DDLogInfo(@"transitionModel: %@", transitionModel);
         [self.collectionView reloadData];
     } error:^(NSError *error) {
         DDLogError(@"%@", error);
     } completed:^{
         DDLogInfo(@"Complete!");
     }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        DDDHackerNewsItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDHackerNewsItemCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell prepareWithModel:[[[self storyDetailViewModel] transitionModel] story]];
        return cell;
    }
    else
    {
        DDDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DDDWebViewCollectionViewCellIdentifier forIndexPath:indexPath];
        [cell prepareWithModel:[[[self storyDetailViewModel] transitionModel] story]];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0)
        return [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDHackerNewsItemCollectionViewCell class] withCellModel:[[[self storyDetailViewModel] transitionModel] story] withModelIdentifier:@([[[[self storyDetailViewModel] transitionModel] story] id])];
    else
    {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
        return CGSizeMake(flowLayout.itemSize.width, collectionView.bounds.size.height - flowLayout.itemSize.height);
    }
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
