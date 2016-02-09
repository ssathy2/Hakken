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
#import "Hakken-Swift.h"
#import <DTCoreText/DTCoreText.h>

@interface DDDCommentCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *subcommentsArrowContainer;
@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *distantDateCommentPostedLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) RotatableArrow *rotatableArrow;
@property (strong, nonatomic) NSArray *linkRanges; // -> contains dictionaries containing mappings { 'range' : <# range #>, 'url' : <# url #> }
@property (assign, nonatomic) CGPoint lastTappedLocation;
@end

@implementation DDDCommentCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rotatableArrow = [[RotatableArrow alloc] initWithFrame:self.bounds];
    [self.subcommentsArrowContainer addSubviewWithConstraints:self.rotatableArrow];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.lastTappedLocation = [touch locationInView:self];
}

- (void)prepareWithModel:(DDDCommentTreeInfo *)model
{
    [super prepareWithModel:model];
    self.commentUserLabel.text = model.comment.by;
    self.distantDateCommentPostedLabel.text = [model.comment.dateCreated relativeDateTimeStringToNow];
    
    NSData *data = [model.comment.text dataUsingEncoding:NSUTF8StringEncoding];
    UIFont *font = self.commentLabel.font;
    NSDictionary *optionsDict = @{
                                  DTUseiOS6Attributes    : @(YES),
                                  DTDefaultLinkColor     : [UIColor yellowColor],
                                  DTDefaultTextColor     : [UIColor whiteColor],
                                  DTDefaultFontName      : font.fontName,
                                  DTDefaultFontFamily    : font.familyName,
                                  DTDefaultFontSize      : @(font.pointSize)
                                  };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data
                                                                          options:optionsDict
                                                               documentAttributes:nil];

    NSMutableAttributedString *mutAttrString = [attrString mutableCopy];
    [mutAttrString removeAttribute:@"CTForegroundColorFromContext" range:NSMakeRange(0, mutAttrString.length)];

    // remove the new line at the end of the attr string
    [mutAttrString deleteCharactersInRange:NSMakeRange(mutAttrString.length-1, 1)];
    if (model.comment.deleted)
    {
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Deleted" attributes:@{
                                                                                                            NSFontAttributeName : [UIFont italicFontOfSize:self.commentLabel.font.pointSize]
                                                                                                            }];
        self.commentLabel.attributedText = attrString;
    }
    else
        self.commentLabel.attributedText = mutAttrString;
}

- (NSURL *)tappedLinkInCell
{
    __block NSURL *tappedLinkInCell = nil;
    [self.linkRanges enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        CGRect clickHereRect = [self boundingRectForCharacterRange:[[dict valueForKey:@"range"] rangeValue]];
        CGPoint convertedPoint = [self convertPoint:self.lastTappedLocation toView:self.commentLabel];
        if (CGRectContainsPoint(clickHereRect, convertedPoint))
        {
            tappedLinkInCell = [dict valueForKey:@"url"];
            return ;
        }
    }];
    return tappedLinkInCell;
}

- (NSArray *)linkRanges
{
    if (_linkRanges)
        return _linkRanges;
    NSMutableArray *urlRanges = [NSMutableArray array];
    [self.commentLabel.attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, self.commentLabel.attributedText.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value)
        {
            [urlRanges addObject:@{
                                   @"url"   : value,
                                   @"range" : [NSValue valueWithRange:range]
                                   }];
        }
    }];
    
    _linkRanges = urlRanges;
    return _linkRanges;
}

#pragma mark - Cell Comment Collapse/Expand styling
- (void)showCollapsedView
{
    [self.rotatableArrow setDirection:ArrowDirectionArrowDirectionRight animated:YES];
}

- (void)showExpandedView
{
    [self.rotatableArrow setDirection:ArrowDirectionArrowDirectionDown animated:YES];
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.commentLabel.attributedText];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    rect.origin.y += 5;
    rect.size.height += 10;
    return rect;
}

@end
