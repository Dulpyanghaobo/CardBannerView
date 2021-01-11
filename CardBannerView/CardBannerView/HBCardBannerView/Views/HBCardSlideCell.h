//
//  HBCardSlideCell.h
//  CardBannerView
//
//  Created by yhb on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "HBCardSliderModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HBCardSlideCell : UICollectionViewCell

@property (nonatomic, strong) NSObject<HBCardSliderModelProtocol> *model;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *item;

@property (nonatomic, strong) void (^SelectedCallBack)(id object);

@end

NS_ASSUME_NONNULL_END
