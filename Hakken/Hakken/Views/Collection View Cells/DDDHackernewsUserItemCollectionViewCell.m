//
//  DDDHackernewsUserItemCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/5/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDHackernewsUserItemCollectionViewCell.h"
#import "DDDHackerNewsItem.h"
#import <DTCoreText/DTCoreText.h>

@interface DDDHackernewsUserItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *userItemTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DDDHackernewsUserItemCollectionViewCell

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    
    DDDHackerNewsItem *hnItem = (DDDHackerNewsItem *)model;
    self.usernameLabel.text = [NSString stringWithFormat:@"from %@", hnItem.by];
    
    self.pointsHoursLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", @(hnItem.score), (hnItem.score > 1) ? @"points" : @"point", [[hnItem dateCreated] relativeDateTimeStringToNow]];
    self.titleLabel.text = hnItem.title;
    
    NSData *data = [hnItem.text dataUsingEncoding:NSUTF8StringEncoding];
    UIFont *font = self.userItemTextLabel.font;
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
    self.userItemTextLabel.attributedText = attrString;
}

@end
