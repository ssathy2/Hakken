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

@import ObjectiveC;

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
    self.commentTextView.text = commentTreeInfo.comment.text;
    
    [self setupDepthIndicatorWithDepth:commentTreeInfo.depth];
}


- (void)setupDepthIndicatorWithDepth:(NSInteger)depth
{
    self.depthIndicatorView.backgroundColor = [UIColor colorForDepth:depth];
}
@end
