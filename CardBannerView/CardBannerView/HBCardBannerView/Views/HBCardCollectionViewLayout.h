//
//  HBCardCollectionViewLayout.h
//  CardBannerView
//
//  Created by yhb on 2021/1/11.
//

#import <UIKit/UIKit.h>
#import "HBCardSlideCellSize.h"
NS_ASSUME_NONNULL_BEGIN

@interface HBCardCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) BOOL ignoringBoundsChange;
- (instancetype)initWithCellSize:(HBCardSlideCellSize *)cellSize;
@end

NS_ASSUME_NONNULL_END
