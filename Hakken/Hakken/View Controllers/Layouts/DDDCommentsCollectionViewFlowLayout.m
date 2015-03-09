//
//  DDDCommentsCollectionViewLayout.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCommentsCollectionViewFlowLayout.h"
#import "DDDCommentsViewModel.h"
#import "DDDCommentTreeInfo.h"
#import "DDDCommentCollectionViewCell.h"

@interface DDDCommentsCollectionViewFlowLayout()
@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;
@property (strong, nonatomic) NSMutableDictionary *supplementaryViewLayoutInfo;
@property (assign, nonatomic) CGFloat contentSizeHeight;
@end

@implementation DDDCommentsCollectionViewFlowLayout
+ (instancetype)layoutWithCommentsViewModel:(DDDCommentsViewModel *)viewModel
{
    DDDCommentsCollectionViewFlowLayout *layout = [DDDCommentsCollectionViewFlowLayout new];
    layout.commentsViewModel = viewModel;
    return layout;
}

- (instancetype)init
{
    self = [super init];
    if (self)
        [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    return self;
}

- (void)setup
{
    
}

- (void)prepareLayout
{
    [super prepareLayout];
    _contentSizeHeight = -1;
    NSMutableDictionary *cellLayoutInfo         = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplementaryViewInfo  = [NSMutableDictionary dictionary];
    NSInteger sectionCount                      = [self.collectionView numberOfSections];
    NSIndexPath *indexPath                      = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            itemAttributes.frame = [self frameForLayoutAttributes:itemAttributes atIndexPath:indexPath];
            if (itemAttributes)
                cellLayoutInfo[indexPath] = itemAttributes;
            
            UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
            UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            if (footerAttributes)
                supplementaryViewInfo[indexPath] = footerAttributes;
            if (headerAttributes)
                supplementaryViewInfo[indexPath] = headerAttributes;
        }
    }
    
    self.cellLayoutInfo = cellLayoutInfo;
    self.supplementaryViewLayoutInfo = supplementaryViewInfo;
}

- (CGRect)frameForLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexpath
{
    DDDCommentTreeInfo *treeInfo = [self.commentsViewModel commentTreeInfoForIndexPath:indexpath];
    CGRect attributesFrame = attributes.frame;
    if (treeInfo.depth > 0)
    {
        CGFloat depthOffset = (treeInfo.depth * 12);
        attributesFrame.size.width -= depthOffset;
        attributesFrame.origin.x += depthOffset;
    }
    return attributesFrame;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.cellLayoutInfo.count];
    
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame))
                [allAttributes addObject:attributes];
    }];
    
    [self.supplementaryViewLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame))
                [allAttributes addObject:attributes];
    }];
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = (self.cellLayoutInfo[indexPath]) ?: [super layoutAttributesForItemAtIndexPath:indexPath];
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = (self.supplementaryViewLayoutInfo[indexPath]) ?: [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    return attrs;
}

- (CGFloat)contentSizeHeight
{
    if (_contentSizeHeight == -1)
    {
        __block CGFloat height = 0;
        [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *idxPath, UICollectionViewLayoutAttributes *attrs, BOOL *stop) {
            height += CGRectGetHeight(attrs.frame);
        }];
        
        [self.supplementaryViewLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *idxPath, UICollectionViewLayoutAttributes *attrs, BOOL *stop) {
            height += CGRectGetHeight(attrs.frame);
        }];
        
        _contentSizeHeight = height;
    }
    return _contentSizeHeight;
}

- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = self.contentSizeHeight;
    return CGSizeMake(contentWidth, contentHeight);
}

@end
