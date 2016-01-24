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
#import "DDDHackerNewsComment.h"

@interface DDDCommentsCollectionViewFlowLayout()
@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;
@property (strong, nonatomic) NSMutableDictionary *supplementaryViewLayoutInfo;
@property (assign, nonatomic) CGFloat contentSizeHeight;
//@property (strong, nonatomic) NSMutableArray *collapsedIndexPaths;
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
    
    NSMutableDictionary *footerViewInfo         = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerViewInfo         = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount                      = [self.collectionView numberOfSections];
    NSIndexPath *indexPath                      = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *footerAttributes = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
            UICollectionViewLayoutAttributes *headerAttributes = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];

            itemAttributes.frame = [self frameForLayoutAttributes:itemAttributes atIndexPath:indexPath];
            if (itemAttributes)
                cellLayoutInfo[indexPath] = itemAttributes;
            if (footerAttributes)
               footerViewInfo[indexPath] = footerAttributes;
            if (headerAttributes)
                headerViewInfo[indexPath] = headerAttributes;
        }
    }
    
    supplementaryViewInfo[UICollectionElementKindSectionFooter] = footerViewInfo;
    supplementaryViewInfo[UICollectionElementKindSectionHeader] = headerViewInfo;
    
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

    [self.supplementaryViewLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *dict, BOOL *stop) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *idxPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
            if (CGRectIntersectsRect(rect, attributes.frame))
                [allAttributes addObject:attributes];
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.cellLayoutInfo[indexPath]) ?: [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return (self.supplementaryViewLayoutInfo[elementKind][indexPath]) ?: [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (CGFloat)contentSizeHeight
{
    if (_contentSizeHeight != -1)
        return _contentSizeHeight;
    
    __block CGFloat height = 0;
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *idxPath, UICollectionViewLayoutAttributes *attrs, BOOL *stop) {
        height += CGRectGetHeight(attrs.frame);
    }];
    
    [self.supplementaryViewLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *dict, BOOL *stop) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *idxPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
            height += CGRectGetHeight(attributes.frame);
        }];
    }];
    
    _contentSizeHeight = height;
    return _contentSizeHeight;
}

- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = self.contentSizeHeight;
    return CGSizeMake(contentWidth, contentHeight);
}

//- (void)handleCommentTappedAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.collectionView.collectionViewLayout invalidateLayout];
//    DDDCommentCollectionViewCell *__weak cell = [self.collectionView cellForItemAtIndexPath:indexPath]; // Avoid retain cycles
//    
//   // recursive grab all of the index paths that are children of parameter index path and then invalidate layout for ONLY those indexpaths
//    NSArray *childIndexPathsForCommentIndexPath = [self indexPathsForChildrenOfCommentStartingAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
//    if (childIndexPathsForCommentIndexPath.count == 0)
//        return;
//    
//    DDLogDebug(@"%@", childIndexPathsForCommentIndexPath);
//    
//    // We can't collapse a leaf comment
//    if ([self.collapsedIndexPaths containsObject:indexPath])
//        // we want to expand the comments at this index path, we remove the index path from the collapsed index path array and relayout
//        [self.collapsedIndexPaths removeObject:indexPath];
//    else
//        [self.collapsedIndexPaths addObject:indexPath];
//    
////    UICollectionViewFlowLayoutInvalidationContext *invalidationContext = [UICollectionViewFlowLayoutInvalidationContext new];
////    [invalidationContext invalidateItemsAtIndexPaths:childIndexPathsForCommentIndexPath];
////    [self invalidateLayoutWithContext:invalidationContext];
//}
//
//- (NSArray *)indexPathsForChildrenOfCommentStartingAtIndexPath:(NSIndexPath *)indexPath
//{
//    DDDCommentTreeInfo *info = [self.commentsViewModel commentTreeInfoForIndexPath:indexPath];
//    if (!info)
//        return [NSArray new];
//    
//    if (info.comment.kids.count == 0)
//        return @[info.indexPath];
//    
//    NSMutableArray *idxPaths = [NSMutableArray array];
//    [idxPaths addObject:info.indexPath];
//    for (DDDHackerNewsComment *comment in info.comment.kids)
//    {
//        NSArray *recursiveCallArr = [self indexPathsForChildrenOfCommentStartingAtIndexPath:[self.commentsViewModel commentTreeInfoForComment:comment].indexPath];
//        if (recursiveCallArr.count > 0)
//            [idxPaths addObjectsFromArray:recursiveCallArr];
//    }
//    
//    return idxPaths;
//}
@end
