//
//  DDDCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCollectionViewCell.h"

@implementation DDDCollectionViewCell

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.model = nil;
}

- (void)prepareWithModel:(id)model
{
    self.model = model;
}
@end
