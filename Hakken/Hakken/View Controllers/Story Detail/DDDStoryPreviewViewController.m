//
//  DDDStoryPreviewViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/14/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import "DDDStoryPreviewViewController.h"
#import "DDDStoryPreviewViewModel.h"
#import "DDDHackerNewsItem.h"

@interface DDDStoryPreviewViewController()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DDDStoryPreviewViewController
+ (NSString *)storyboardName
{
    return @"DetailStoryboard";
}

+ (Class)viewModelClass
{
    return [DDDStoryPreviewViewModel class];
}

- (DDDStoryPreviewViewModel *)storyPreviewViewModel
{
    return (DDDStoryPreviewViewModel *)self.viewModel;
}

- (void)prepareWithModel:(DDDHackerNewsItem *)model
{
    [super prepareWithModel:model];
    [self updateWebviewWithItem:model];
}

- (void)updateWebviewWithItem:(DDDHackerNewsItem *)item
{
    if (item)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.url]]];
    }
}


@end
