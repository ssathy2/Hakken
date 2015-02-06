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
@property (strong, nonatomic) NSMutableDictionary *layoutInfo;
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
    self.layoutInfo = [NSMutableDictionary new];
}

- (void)prepareLayout
{
    [super prepareLayout];
    _contentSizeHeight = -1;
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
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
        }
    }
    
    self.layoutInfo = cellLayoutInfo;
}

- (CGRect)frameForLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexpath
{
    DDDCommentTreeInfo *treeInfo = [self.commentsViewModel commentTreeInfoForIndexPath:indexpath];
    CGRect attributesFrame = attributes.frame;
    if (treeInfo.depth > 0)
    attributesFrame.origin.x += ((treeInfo.depth-1) * 5);
    attributesFrame.size.width -= ((treeInfo.depth-1) * 5);
    return attributesFrame;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame))
                [allAttributes addObject:attributes];
    }];
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = (self.layoutInfo[indexPath]) ?: [super layoutAttributesForItemAtIndexPath:indexPath];
    return attrs;
}

- (CGFloat)contentSizeHeight
{
    if (_contentSizeHeight == -1)
    {
        __block CGFloat height = 0;
        [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *idxPath, UICollectionViewLayoutAttributes *attrs, BOOL *stop) {
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
