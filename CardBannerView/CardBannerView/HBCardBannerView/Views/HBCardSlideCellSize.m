//
//  HBCardSlideCellSize.m
//  CardBannerView
//
//  Created by yhb on 2021/1/11.
//

#import "HBCardSlideCellSize.h"

@implementation HBCardSlideCellSize

- (instancetype)initWithNormal:(CGFloat)normalWidth center:(CGFloat)centerWidth
{
    self = [super init];
    if (self) {
        self.normalWidth = normalWidth;
        self.centerWidth = centerWidth;
        self.normalHeight = self.normalHeight == 0 ? normalWidth : self.normalHeight;
        self.centerHeight = self.centerHeight == 0 ? centerWidth : self.centerHeight;
    }
    return self;
}

- (instancetype)initWithNormal:(CGFloat)normalWidth center:(CGFloat)centerWidth normalHeight:(CGFloat)normalHeight centerHeight:(CGFloat)centerHeight {
    self = [super init];
    if (self) {
        self.normalWidth = normalWidth;
        self.centerWidth = centerWidth;
        self.normalHeight = normalHeight;
        self.centerHeight = centerHeight;
    }
    return self;
}

@end
