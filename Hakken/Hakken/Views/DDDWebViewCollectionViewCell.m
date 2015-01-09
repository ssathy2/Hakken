//
//  DDDWebViewCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDWebViewCollectionViewCell.h"
#import "DDDHackerNewsItem.h"

@interface DDDWebViewCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;
@end

@implementation DDDWebViewCollectionViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)prepareWithModel:(DDDHackerNewsItem *)item
{
    [super prepareWithModel:item];
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.url]]];
}

@end
