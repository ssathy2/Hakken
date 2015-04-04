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
#import "CommentsStoryboardIdentifiers.h"
#import "DDDCollectionViewCellSizingHelper.h"
#import "DDDTransitionAttributes.h"

typedef NS_OPTIONS(NSInteger, UIScrollViewDirection)
{
    UIScrollViewDirectionNone         = 0,
    UIScrollViewDirectionLeft         = 1 << 0,
    UIScrollViewDirectionRight        = 1 << 1,
    UIScrollViewDirectionUp           = 1 << 2,
    UIScrollViewDirectionDown         = 1 << 3
};

@interface DDDStoryDetailViewController ()<DDDHackerNewsItemCollectionViewCellDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *hackernewsItemDetailContainer;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) CGSize expandedItemDetailSize;
@property (assign, nonatomic) BOOL  isStoryInformationCellExpanded;
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
    
    self.isStoryInformationCellExpanded = YES;
    [self setupWebview];
    [self setupListenersToViewModel];
}

- (void)setupWebview
{
    self.webview.scrollView.delegate = self;
}

- (void)setupListenersToViewModel
{
    [RACObserve([self storyDetailViewModel], transitionModel)
     subscribeNext:^(DDDStoryTransitionModel *transitionModel) {
         DDLogInfo(@"transitionModel: %@", transitionModel);
         [self applyStoryToView:transitionModel.story];
     } error:^(NSError *error) {
         DDLogError(@"%@", error);
     } completed:^{
         DDLogInfo(@"Complete!");
     }];
}

- (void)applyStoryToView:(DDDHackerNewsItem *)story
{
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:story.url]]];
    [self loadDetailViewIntoContainerWithStory:story];
}

- (void)loadDetailViewIntoContainerWithStory:(DDDHackerNewsItem *)story
{
    DDDHackerNewsItemCollectionViewCell *cell = [DDDHackerNewsItemCollectionViewCell instance];
    [cell prepareWithModel:story];
    CGSize cellSize = [[DDDCollectionViewCellSizingHelper sharedInstance] preferredLayoutSizeWithCellClass:[DDDHackerNewsItemCollectionViewCell class] withCellModel:story withModelIdentifier:[@(story.id) stringValue]];
    self.detailContainerHeightConstraint.constant = cellSize.height;
    self.expandedItemDetailSize = cellSize;
    [self.hackernewsItemDetailContainer addSubviewWithConstraints:cell];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIScrollViewDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = UIScrollViewDirectionUp;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = UIScrollViewDirectionDown;
    
    self.lastContentOffset = scrollView.contentOffset.x;
    
    [self adjustCellSizesWithScrollDirection:scrollDirection];
}

- (void)adjustCellSizesWithScrollDirection:(UIScrollViewDirection)direction
{
    if (direction & UIScrollViewDirectionUp)
        self.isStoryInformationCellExpanded = YES;
    else if (direction & UIScrollViewDirectionDown)
        self.isStoryInformationCellExpanded = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.detailContainerHeightConstraint.constant = (self.isStoryInformationCellExpanded) ? self.expandedItemDetailSize.height : 0.f;
    } completion:nil];
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

@end
