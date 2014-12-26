//
//  DDDHackerNewsItemCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/1/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItemCollectionViewCell.h"
#import "DDDHackerNewsItem.h"

#import <objc/runtime.h>

@interface DDDHackerNewsItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *pointDatePostedLabel;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DDDHackerNewsItemCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self styleCell];
}

+ (NSMutableDictionary *)sizingInfos {
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

- (CGSize)adjustedCellSize
{
    NSValue *val = [[[self class] sizingInfos] valueForKey:[self.model identifier]];
    if (val)
        return [val CGSizeValue];
    else
    {
        CGSize size = [self systemLayoutSizeFittingSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
        [[[self class] sizingInfos] setValue:[NSValue valueWithCGSize:size] forKey:[self.model identifier]];
        return size;
    }
}

- (void)styleCell
{
    self.commentsButton.layer.masksToBounds = NO;
    [self.commentsButton.layer setCornerRadius:self.commentsButton.frame.size.height];
}

- (IBAction)didTouchDownOnCommentButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(0.90, 0.90);
                        } completion:^(BOOL finished) {
                        }];
}

- (IBAction)didTouchUpOnCommentButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        } completion:^(BOOL finished) {
                            if (finished)
                            {
                                if ([self.delegate respondsToSelector:@selector(cell:didSelectCommentsButton:)])
                                    [self.delegate cell:self didSelectCommentsButton:self.model];
                            }
                        }];
}

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    
    DDDHackerNewsItem *hnItem = (DDDHackerNewsItem *)model;
    self.userName.text = [NSString stringWithFormat:@"from %@", hnItem.by];
    
    self.urlLabel.text = [NSString stringWithFormat:@"(%@)", [hnItem.itemURL host]];
    
    self.pointDatePostedLabel.text = [NSString stringWithFormat:@"%@ %@ %@", hnItem.score, (hnItem.score.integerValue > 1) ? @"points" : @"point", [[NSDate dateWithTimeIntervalSince1970:[hnItem.time doubleValue]] relativeDateTimeStringToNow]];
    self.titleLabel.text = hnItem.title;
    
    // TODO: Get the actual number of comments
    [self.commentsButton setTitle:[@(hnItem.kids.count) stringValue] forState:UIControlStateNormal];
}
@end