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

#import <DTCoreText/DTCoreText.h>

@interface DDDCommentCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *depthIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *distantDateCommentPostedLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation DDDCommentCollectionViewCell
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDCommentTreeInfo *commentTreeInfo = (DDDCommentTreeInfo *)model;
    self.commentUserLabel.text = commentTreeInfo.comment.by;
    self.distantDateCommentPostedLabel.text = [commentTreeInfo.comment.dateCreated relativeDateTimeStringToNow];
    
    NSData *data = [commentTreeInfo.comment.text dataUsingEncoding:NSUTF8StringEncoding];
    UIFont *font = self.commentLabel.font;
    NSDictionary *optionsDict = @{
                                  DTUseiOS6Attributes    : @(YES),
                                  DTDefaultTextColor     : [UIColor whiteColor],
                                  DTDefaultFontName      : font.fontName,
                                  DTDefaultFontFamily    : font.familyName,
                                  DTDefaultFontSize      : @(font.pointSize)
                                  };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data
                                                                          options:optionsDict
                                                               documentAttributes:nil];
    self.commentLabel.attributedText = attrString;
}
@end
