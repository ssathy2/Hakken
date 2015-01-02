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

- (CGSize)adjustedCellSizeWithCellClass:(Class)cellClass withCellModel:(id)model withCellModelIdentifier:(id)identifier
{
    NSParameterAssert(identifier != nil);
    NSParameterAssert(cellClass != nil);
    NSParameterAssert(model != nil);
    
    DDDCollectionViewCellSizingHelperEntry *sizingEntry = [self.modelIdentifierToSizingHelperEntryMapping objectForKey:identifier];
    if (sizingEntry)
        return sizingEntry.size;
    else
    {
        UICollectionViewCell *cell = [self sizingForCellClass:cellClass];
        if ([cell respondsToSelector:@selector(prepareWithModel:)])
            [cell performSelector:@selector(prepareWithModel:) withObject:model];
        [cell layoutIfNeeded];
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        sizingEntry = [DDDCollectionViewCellSizingHelperEntry new];
        sizingEntry.cellClass = [cellClass copy];
        sizingEntry.size = size;
        [self.modelIdentifierToSizingHelperEntryMapping setObject:sizingEntry forKey:identifier];
        return size;
    }
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
