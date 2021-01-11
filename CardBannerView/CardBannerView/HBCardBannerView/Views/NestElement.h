//
//  NestElement.h
//  CardBannerView
//
//  Created by 杨皓博 on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NestElement : NSObject

@property (nonatomic, assign)NSInteger nearestElementIndex;

@property (nonatomic, assign)CGFloat minimumDistance;
@end

NS_ASSUME_NONNULL_END
