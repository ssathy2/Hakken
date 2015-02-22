//
//  DDDLoadingCollectionReusableView.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/22/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDLoadingCollectionReusableView.h"

@interface DDDLoadingCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation DDDLoadingCollectionReusableView
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.loadingIndicator startAnimating];
}

@end
