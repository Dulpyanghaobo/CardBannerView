//
//  HBCardSlideCellSize.h
//  CardBannerView
//
//  Created by yhb on 2021/1/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HBCardSlideCellSize : NSObject

@property (nonatomic, assign)CGFloat normalWidth;

@property (nonatomic, assign)CGFloat centerWidth;

@property (nonatomic, assign)CGFloat normalHeight;

@property (nonatomic, assign)CGFloat centerHeight;

- (instancetype)initWithNormal:(CGFloat)normalWidth center:(CGFloat)centerWidth;

- (instancetype)initWithNormal:(CGFloat)normalWidth center:(CGFloat)centerWidth normalHeight:(CGFloat)normalHeight centerHeight:(CGFloat)centerHeight;

@end

NS_ASSUME_NONNULL_END
