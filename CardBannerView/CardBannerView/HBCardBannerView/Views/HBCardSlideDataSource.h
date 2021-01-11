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


@interface HBCardSlideDataSource : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) HBCardSlideCellSize *cellSize;
/** */
@property (nonatomic, weak) UICollectionView *collectionView;

/** 选择*/
@property (nonatomic, weak) id <HBCardSlideDataDelegate>delegate;

@property (nonatomic, strong) void (^SelectedCallBack)(id object);
/** 模型*/
@property (nonatomic, strong) NSArray *items;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView cardSlideCellSize:(HBCardSlideCellSize *)cellSize;
@end



NS_ASSUME_NONNULL_END
