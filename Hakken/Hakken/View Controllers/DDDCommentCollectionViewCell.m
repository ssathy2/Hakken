//
//  DDDCommentCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCommentCollectionViewCell.h"
#import "DDDHackerNewsComment.h"

@interface DDDCommentCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *subcommentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distantDateCommentPostedLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation DDDCommentCollectionViewCell
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDHackerNewsComment *comment = (DDDHackerNewsComment *)model;
    self.commentUserLabel.text = comment.by;
    self.subcommentAmountLabel.text = [NSString stringWithFormat:@"%@ comments",@(comment.kids.count)];
    self.distantDateCommentPostedLabel.text = [comment.dateCreated relativeDateTimeStringToNow];
    self.commentTextView.text = comment.text;
}
@end
