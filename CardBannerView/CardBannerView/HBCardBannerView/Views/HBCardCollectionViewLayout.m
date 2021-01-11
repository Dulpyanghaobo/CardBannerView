//
//  HBCardCollectionViewLayout.m
//  CardBannerView
//
//  Created by yhb on 2021/1/11.
//

#import "HBCardCollectionViewLayout.h"
#import "HBCardSlideCellSize.h"

@interface HBCardCollectionViewLayout ()

@property (nonatomic, assign) CGFloat centerOffset;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) NSInteger numberOfItems;

@property (nonatomic, assign) CGFloat dragOffset;

@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *cache;

@property (nonatomic, strong) HBCardSlideCellSize *cellSize;

@end

@implementation HBCardCollectionViewLayout

- (instancetype)initWithCellSize:(HBCardSlideCellSize *)cellSize
{
    self = [super init];
    if (self) {
        self.cellSize = cellSize;
        self.ignoringBoundsChange = NO;
        self.centerOffset = (self.collectionView.bounds.size.width - cellSize.centerWidth) / 2;
        self.height = self.collectionView.bounds.size.height;
        self.numberOfItems = [self.collectionView  numberOfItemsInSection:0];
        self.dragOffset = self.cellSize.normalWidth;
        self.cache = [NSMutableArray array];
    }
    return self;
}

- (void)updateLayout:(CGRect)newBounds {
    CGFloat deltaX = self.cellSize.centerWidth - self.cellSize.normalWidth;
    CGFloat deltaY = self.cellSize.centerHeight - self.cellSize.normalHeight;
    CGFloat leftSizeInset = (newBounds.size.width - self.cellSize.centerWidth) / 2;
    
    [self.cache enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat normalCellOffsetX = leftSizeInset + (CGFloat)(attribute.indexPath.row) * self.cellSize.normalWidth;
        CGFloat normalCellOffsetY = (newBounds.size.height - self.cellSize.normalHeight) / 2;
        CGFloat distanceBetweenCellAndBoundCenters = normalCellOffsetX - CGRectGetMidX(newBounds) + self.cellSize.centerWidth / 2;
        CGFloat normalizedCenterScale = distanceBetweenCellAndBoundCenters / self.cellSize.normalWidth;
        
        BOOL isCenterCell = fabsf((float)(normalizedCenterScale)) < 1;
        BOOL isNormalCellOnRightOfCenter = normalizedCenterScale > 0 && !isCenterCell;
        BOOL isNormalCellOnLeftOfCenter = normalizedCenterScale < 0 && !isCenterCell;
        if (isCenterCell) {
            CGFloat incrementX  = (1.0 - (CGFloat)(fabsf((float)(normalizedCenterScale)))) * deltaX;
            CGFloat incrementY  = (1.0 - (CGFloat)(fabsf((float)(normalizedCenterScale)))) * deltaY;
            
            CGFloat offsetX  = normalizedCenterScale > 0 ? deltaX - incrementX : 0;
            CGFloat offsetY  = -incrementY / 2;
            
            attribute.frame = CGRectMake(normalCellOffsetX + offsetX, normalCellOffsetY + offsetY, self.cellSize.normalWidth + incrementX, self.cellSize.normalHeight + incrementY);
        } else if (isNormalCellOnRightOfCenter) {
            attribute.frame = CGRectMake(normalCellOffsetX + deltaX, normalCellOffsetY, self.cellSize.normalWidth, self.cellSize.normalHeight);
        } else if (isNormalCellOnLeftOfCenter) {
            attribute.frame = CGRectMake(normalCellOffsetX, normalCellOffsetY, self.cellSize.normalWidth, self.cellSize.normalHeight);
        }
    }];
}

- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = 2 * self.centerOffset + self.cellSize.centerWidth + (CGFloat)(self.numberOfItems - 1) * self.cellSize.normalWidth;
    return CGSizeMake(contentWidth, self.height);
}

- (void)prepareLayout {
    if (self.cache.count == 0 || self.cache.count != self.numberOfItems) {
        for (int i = 0;  i< self.numberOfItems;i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            [self.cache addObject:attributes];
        }
        [self updateLayout:self.collectionView.bounds];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [self updateLayout:newBounds];
    return !self.ignoringBoundsChange;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cache[indexPath.row];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *visibleLayoutAttributes = [NSMutableArray array];
    [self.cache enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj ,NSUInteger idx,BOOL * _Nonnull stop){
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [visibleLayoutAttributes addObject: obj];
        }
    }];
    return visibleLayoutAttributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat itemIndex = round(proposedContentOffset.x / self.dragOffset);
    CGFloat xOffset = itemIndex * self.dragOffset;
    return CGPointMake(xOffset, 0);
}
@end
