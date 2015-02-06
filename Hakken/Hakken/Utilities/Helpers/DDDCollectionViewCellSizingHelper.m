//
//  DDDCollectionViewCellSizingHelper.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/2/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDCollectionViewCellSizingHelper.h"
#import "DDDCollectionViewCell.h"

@interface DDDCollectionViewCellSizingHelperEntry : NSObject
@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) Class cellClass;
@end

@implementation DDDCollectionViewCellSizingHelperEntry
@end

@interface DDDCollectionViewCellSizingHelper()
// Contains mappings between model identifer -> DDDCollectionViewCellSizingHelperEntry
@property (strong, nonatomic) NSMutableDictionary *modelIdentifierToSizingHelperEntryMapping;
@property (strong, nonatomic) NSMutableDictionary *cellClassToSizingCellMapping;
@end

@implementation DDDCollectionViewCellSizingHelper
+ (instancetype)sharedInstance
{
	static DDDCollectionViewCellSizingHelper *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [DDDCollectionViewCellSizingHelper new];
        // do any init for the shared instance here
        [sharedInstance sharedInit];
	});
	return sharedInstance;
}

- (void)sharedInit
{
    self.modelIdentifierToSizingHelperEntryMapping = [NSMutableDictionary new];
    self.cellClassToSizingCellMapping = [NSMutableDictionary new];
}

- (CGSize)preferredLayoutSizeWithCellClass:(Class)cellClass withCellModel:(id)model withModelIdentifier:(id)modelIdentifier
{
    NSParameterAssert(modelIdentifier != nil);
    NSParameterAssert(cellClass != nil);
    NSParameterAssert(model != nil);
    
    NSString *helperEntryIdentifier = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(cellClass), modelIdentifier];
    DDDCollectionViewCellSizingHelperEntry *sizingEntry = [self.modelIdentifierToSizingHelperEntryMapping objectForKey:helperEntryIdentifier];
    if (sizingEntry)
        return sizingEntry.size;
    else
    {
        UICollectionViewCell *cell = [self sizingForCellClass:cellClass];
        if ([cell respondsToSelector:@selector(prepareWithModel:)])
            [cell performSelector:@selector(prepareWithModel:) withObject:model];
        
        CGSize size = [self preferredLayoutSizeFittingSize:UILayoutFittingCompressedSize withCell:cell];
        sizingEntry = [DDDCollectionViewCellSizingHelperEntry new];
        sizingEntry.cellClass = [cellClass copy];
        sizingEntry.size = size;
        [self.modelIdentifierToSizingHelperEntryMapping setObject:sizingEntry forKey:helperEntryIdentifier];
        return size;
    }
}

- (CGSize)preferredLayoutSizeFittingSize:(CGSize)targetSize withCell:(UICollectionViewCell *)cell
{
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGSize computedSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return computedSize;
}

- (UICollectionViewCell *)sizingForCellClass:(Class)cellClass
{
    NSString *cellClassString = NSStringFromClass(cellClass);
    UICollectionViewCell *cell = [self.cellClassToSizingCellMapping valueForKey:cellClassString];
    if (!cell)
    {
        cell = [[[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
        [self.cellClassToSizingCellMapping setValue:cell forKey:cellClassString];
    }
    assert([cell isKindOfClass:cellClass]);
    return cell;
}

@end
