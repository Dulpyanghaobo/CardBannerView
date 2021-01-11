//
//  HBCardSlideDataSource.h
//  CardBannerView
//
//  Created by yhb on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "HBCardSlideCellSize.h"
NS_ASSUME_NONNULL_BEGIN
@class HBCardSlideDataSource;
@protocol HBCardSlideDataDelegate <NSObject>

@optional
- (void)cellSelected:(NSInteger)index;

- (UICollectionViewCell *)CardSlideView:(HBCardSlideDataSource *)CardSlideView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


@end


@interface NestElement : NSObject

@property (nonatomic, assign)NSInteger nearestElementIndex;

@property (nonatomic, assign)CGFloat minimumDistance;

@end


@interface HBCardSlideDataSource : NSObject

@property (nonatomic, strong) HBCardSlideCellSize *cellSize;
/** */
@property (nonatomic, weak) UICollectionView *collectionView;


@property (nonatomic, strong) void (^SelectedCallBack)(id object);
@end



NS_ASSUME_NONNULL_END
