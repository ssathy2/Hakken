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
@property (assign, nonatomic) CGFloat collectionViewContentSizeHeight;
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
    attributesFrame.origin.x = attributesFrame.origin.x + (treeInfo.depth * 5);
    attributesFrame.size.width = attributesFrame.size.width - (treeInfo.depth * 5);
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
    self.collectionViewContentSizeHeight += attrs.frame.size.height;
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = self.collectionViewContentSizeHeight;
    return CGSizeMake(contentWidth, contentHeight);
}

@end
