//
//  DDDCommentCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCommentCollectionViewCell.h"
#import "DDDCommentTreeInfo.h"
#import "DDDHackerNewsComment.h"

@interface DDDCommentCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *depthIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *distantDateCommentPostedLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@end

@implementation DDDCommentCollectionViewCell
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDCommentTreeInfo *commentTreeInfo = (DDDCommentTreeInfo *)model;
    self.commentUserLabel.text = commentTreeInfo.comment.by;
    self.distantDateCommentPostedLabel.text = [commentTreeInfo.comment.dateCreated relativeDateTimeStringToNow];
    
    // TODO: We HAVE to handle text that's marked up with HTML, currently we're not doing that and it looks ugly.
    // we can use NSAttributedString's initWithData:options:documentAttributes:error:, but this is SUPER SUPER slow and
    // we can't create the attributed string on a background thread. Using a webview is slow and too cumbersome for what needs
    // to be done here....
    self.commentTextView.text = commentTreeInfo.comment.text;
    
    [self setupDepthIndicatorWithDepth:commentTreeInfo.depth];
}

- (void)setupDepthIndicatorWithDepth:(NSInteger)depth
{
    self.depthIndicatorView.backgroundColor = [UIColor colorForDepth:depth];
}
@end
