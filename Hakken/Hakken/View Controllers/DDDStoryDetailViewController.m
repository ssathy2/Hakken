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

@interface DDDStoryDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation DDDStoryDetailViewController

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
    NSString *identifier = (indexPath.row == 0) ? DDDHackerNewsItemCollectionViewCellIdentifier : DDDWebViewCollectionViewCellIdentifier;
    DDDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell prepareWithModel:[[[self storyDetailViewModel] transitionModel] story]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewFlowLayout *flowLaoyut = (UICollectionViewFlowLayout *)collectionViewLayout;
    if (indexPath.row == 1)
        return CGSizeMake(flowLaoyut.itemSize.width, collectionView.bounds.size.height - flowLaoyut.itemSize.height);
    else
        return flowLaoyut.itemSize;
    
}

@end
