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

- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = 2 * self.centerOffset + self.cellSize.centerWidth + (CGFloat)(self.numberOfItems - 1) * self.cellSize.normalWidth;
    return CGSizeMake(contentWidth, self.height);
}

- (void)prepareLayout {
//    if self.cache.cou || cache.count != numberOfItems {
//        for item in 0..<numberOfItems {
//            let indexPath = IndexPath(item: item, section: 0)
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            cache.append(attributes)
//        }
//        updateLayout(forBounds: (collectionView?.bounds)!)
//    }
    if (self.cache.count == 0 || self.cache.count != self.numberOfItems) {
        for (int i = 0;  i< self.numberOfItems;i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            [self.cache addObject:attributes];
        }
        
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    
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
