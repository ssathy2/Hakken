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

@interface DDDCommentCollectionViewCell()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIView *depthIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *distantDateCommentPostedLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentLabel;
@end

@implementation DDDCommentCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.commentLabel.delegate = self;
}

- (void)prepareWithModel:(DDDCommentTreeInfo *)model
{
    [super prepareWithModel:model];
    self.commentUserLabel.text = model.comment.by;
    self.distantDateCommentPostedLabel.text = [model.comment.dateCreated relativeDateTimeStringToNow];
    self.depthIndicatorView.backgroundColor = [UIColor colorForDepth:model.depth];
    
    NSData *data = [model.comment.text dataUsingEncoding:NSUTF8StringEncoding];
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
    NSMutableAttributedString *mutAttrString = [attrString mutableCopy];

    // remove the new line at the end of the attr string
    [mutAttrString deleteCharactersInRange:NSMakeRange(mutAttrString.length-1, 1)];
    self.commentLabel.attributedText = mutAttrString;
    
    __block id genericUrl;
    __block NSRange urlRange;
    [mutAttrString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, mutAttrString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value)
        {
            genericUrl = value;
            urlRange = range;
        }
    }];
    
    if (urlRange.location != NSNotFound && genericUrl)
    {
        NSURL *actualURL;
        if ([genericUrl isKindOfClass:[NSString class]])
            actualURL = [NSURL URLWithString:genericUrl];
        else if ([genericUrl isKindOfClass:[NSURL class]])
            actualURL = genericUrl;
        self.commentLabel.linkAttributes = @{
                                             (id)kCTForegroundColorAttributeName: [UIColor blueColor],
                                             (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                             };
        [self.commentLabel addLinkToURL:actualURL withRange:urlRange];
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(commentCollectionViewCell:didTapOnLinkInComment:withLink:)])
        [self.delegate commentCollectionViewCell:self didTapOnLinkInComment:self.model withLink:url];
}

@end
