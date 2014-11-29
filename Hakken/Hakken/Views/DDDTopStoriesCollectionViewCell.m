//
//  DDDTopStoriesCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesCollectionViewCell.h"
#import "DDDHackerNewsItem.h"

@interface DDDTopStoriesCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *pointDatePostedLabel;

@property (weak, nonatomic) IBOutlet UIView *pageableContentView;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DDDTopStoriesCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self styleCell];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setCollapseState:DDDCellCollapseStateCollapsed];
}

- (void)styleCell
{
    self.commentsButton.layer.masksToBounds = NO;
    [self.commentsButton.layer setCornerRadius:self.commentsButton.frame.size.height/1.2];
}

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    
    DDDHackerNewsItem *hnItem = (DDDHackerNewsItem *)model;
    self.userName.text = [NSString stringWithFormat:@"from %@", hnItem.by];
    
    NSURL *url = [NSURL URLWithString:hnItem.url];
    self.urlLabel.text = [NSString stringWithFormat:@"(%@)", [url host]];
    
    self.pointDatePostedLabel.text = [NSString stringWithFormat:@"%@ point %@", hnItem.score, [[NSDate dateWithTimeIntervalSince1970:[hnItem.time doubleValue]] relativeDateTimeStringToNow]];
    self.titleLabel.text = hnItem.title;
    
    // TODO: Get the actual number of comments
    [self.commentsButton setTitle:[@(hnItem.kids.count) stringValue] forState:UIControlStateNormal];
}

- (void)setCollapseState:(DDDCellCollapseState)collapseState
{
    switch (collapseState) {
        case DDDCellCollapseStateCollapsed:
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.webview.hidden = YES;
                self.pointDatePostedLabel.hidden = NO;
                self.userName.hidden = NO;
            }];
            break;
        }
        case DDDCellCollapseStateNotCollapsed:
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.webview.hidden = NO;
                self.pointDatePostedLabel.hidden = YES;
                self.userName.hidden = YES;
            }];
            break;
        }
        default:
            break;
    }
}

- (void)loadURLIfNecessary
{
    if ([self.model url])
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:(NSString *)[self.model url]]]];
}

@end
