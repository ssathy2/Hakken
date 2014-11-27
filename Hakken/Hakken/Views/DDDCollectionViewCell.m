//
//  DDDCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCollectionViewCell.h"

@implementation DDDCollectionViewCell
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.model = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)prepareWithModel:(id)model
{
    self.model = model;
}
@end
