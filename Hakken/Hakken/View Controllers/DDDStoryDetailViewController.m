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
#import "DDDStoryDetailTransitionModel.h"
#import "DDDHackerNewsItem.h"

@interface DDDStoryDetailViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *topPeekView;
@property (strong, nonatomic) UIView *bottomPeekView;
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

- (void)updateWithTransitionModel:(DDDStoryDetailTransitionModel *)transitionModel
{
    [self updateWithStory:transitionModel.story];
    
    UIView *topPeekView = transitionModel.topPeekView;
    UIView *bottomPeekView = transitionModel.bottomPeekView;
    
    CGRect detailContentBounds = self.detailContentView.bounds;
    
    [self.scrollView addSubview:topPeekView];
    [self.scrollView addSubview:bottomPeekView];
    
    [topPeekView setFrame:(CGRect){CGPointMake(detailContentBounds.origin.x, detailContentBounds.origin.y-topPeekView.bounds.size.height), topPeekView.bounds.size}];
    [bottomPeekView setFrame:(CGRect){CGPointMake(detailContentBounds.origin.x, detailContentBounds.origin.y+detailContentBounds.size.height), bottomPeekView.bounds.size}];
    
//
//    UIView *superview = self.scrollView;
//    UIView *detailView = self.detailContentView;
//    
//    [topPeekView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superview.mas_top).with.offset(0); //with is an optional semantic filler
//        make.left.equalTo(superview.mas_left).with.offset(0);
//        make.bottom.equalTo(detailView.mas_bottom).with.offset(0);
//        make.right.equalTo(superview.mas_right).with.offset(0);
//    }];
//
//    [bottomPeekView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(detailView.mas_top).with.offset(0); //with is an optional semantic filler
//        make.left.equalTo(superview.mas_left).with.offset(0);
//        make.bottom.equalTo(superview.mas_bottom).with.offset(0);
//        make.right.equalTo(superview.mas_right).with.offset(0);
//    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setupScrollView];
    [self setupListenersToViewModel];
}

- (void)setupListenersToViewModel
{
    [RACObserve([self storyDetailViewModel], transitionModel)
     subscribeNext:^(DDDStoryDetailTransitionModel *transitionModel) {
         DDLogInfo(@"transitionModel: %@", transitionModel);
         [self updateWithTransitionModel:transitionModel];
     } error:^(NSError *error) {
         DDLogError(@"%@", error);
     } completed:^{
         DDLogInfo(@"Complete!");
     }];
}

- (void)setupScrollView
{
    self.scrollView.delegate = self;
}

- (void)updateWithStory:(DDDHackerNewsItem *)story
{
    if (story)
        [self.webView loadRequest:[NSURLRequest requestWithURL:story.itemURL]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end
