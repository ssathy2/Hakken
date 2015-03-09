//
//  DDDNoContentView.m
//  Hakken
//
//  Created by Sidd Sathyam on 3/9/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDNoContentView.h"

@interface DDDNoContentView()
@property (weak, nonatomic) IBOutlet UILabel *noContentLabel;

@end

@implementation DDDNoContentView
+ (instancetype)instanceWithText:(NSString *)noContentText
{
    DDDNoContentView *contentView = (DDDNoContentView *)[[[UINib nibWithNibName:NSStringFromClass([DDDNoContentView class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    contentView.noContentLabel.text = noContentText;
    return contentView;
}
@end
