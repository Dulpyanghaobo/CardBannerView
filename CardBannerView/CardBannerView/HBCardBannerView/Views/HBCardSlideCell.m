//
//  HBCardSlideCell.m
//  CardBannerView
//
//  Created by yhb on 2021/1/5.
//

#import "HBCardSlideCell.h"

@implementation HBCardSlideCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void)setItem:(NSString *)item {
    _item = item;
    self.titleLabel.text = item;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}
@end
