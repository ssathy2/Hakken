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

+ (instancetype)sizingCell
{
    static DDDCommentCollectionViewCell* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
        // do any init for the shared instance here
    });
    return sharedInstance;
}

+ (NSMutableDictionary *)sizingInfos
{
    static NSDictionary *dict = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        dict = [NSMutableDictionary dictionary];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sizingInfos)) ?: dict;
#pragma clang diagnostic pop
}

+ (void)setSizingInfos:(NSMutableDictionary *)sizingInfos
{
    objc_setAssociatedObject(self, @selector(sizingInfos), sizingInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGSize)adjustedCellSizeWithModel:(id)model
{
    NSValue *val = [[[self class] sizingInfos] objectForKey:[model identifier]];
    if (val)
        return [val CGSizeValue];
    else
    {
        [[self sizingCell] prepareWithModel:model];
        [[self sizingCell] layoutIfNeeded];
        [[self sizingCell] updateConstraintsIfNeeded];
        
        CGSize size = [[self sizingCell] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [[[self class] sizingInfos] setObject:[NSValue valueWithCGSize:size] forKey:[model identifier]];
        return size;
    }
}

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
