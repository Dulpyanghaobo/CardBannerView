//
//  HBCardSlideDataSource.m
//  CardBannerView
//
//  Created by yhb on 2021/1/5.
//

#import "HBCardSlideDataSource.h"
#import "HBCardSlideCell.h"
#import "HBCardCollectionViewLayout.h"
#import <objc/runtime.h>
#import "NestElement.h"

/** 设置tags状态 */
typedef NS_ENUM(NSInteger, NearestPointDirection) {
    NearestPointDirectionAny,         //!< 任意方向
    NearestPointDirectionLeft,        //!< 左边
    NearestPointDirectionRight,          //!< 右边
};




@interface HBCardSlideDataSource ()

/** 滑动速度*/
@property (nonatomic, assign) CGFloat scrollVelocity;

/** 下标选择*/
@property (nonatomic, assign) NSInteger selectedItem;


/** 触觉反馈器*/
@property (nonatomic, strong) UISelectionFeedbackGenerator *selectionFG;

/** 设置滑动中心*/
@property (nonatomic, assign) CGFloat collectionViewCenter;


@end

@implementation HBCardSlideDataSource

/** 初始化模型*/
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView cardSlideCellSize:(HBCardSlideCellSize *)cellSize
{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        self.collectionViewCenter = collectionView.bounds.size.width / 2;
        self.selectionFG = [UISelectionFeedbackGenerator new];
        self.cellSize = cellSize;
        self.selectedItem = 0;
    }
    return self;
}

//MARK: 描述 - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.selectedItem == NSIntegerMax) {
        return;
    }
    NSInteger previousSelectIndex = self.selectedItem;
//    滚动时为selectedItem添加一个占位符值
    self.selectedItem = NSIntegerMax;
    
    [self reloadCell:[NSIndexPath indexPathForRow:previousSelectIndex inSection:0] selectState:false];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout nonnull CGPoint *)targetContentOffset {
    self.scrollVelocity = velocity.x;
    
    if (self.scrollVelocity == 0) {
        CGPoint targetOffset = [self offect:targetContentOffset->x direction:NearestPointDirectionAny];
        targetContentOffset = &targetOffset;
    }
    if (self.scrollVelocity < 0) {
        CGPoint targetOffset = [self offect:targetContentOffset->x direction:NearestPointDirectionLeft];
        targetContentOffset = &targetOffset;
    } else if (self.scrollVelocity > 0) {
        CGPoint targetOffset = [self offect:targetContentOffset->x direction:NearestPointDirectionRight];
        targetContentOffset = &targetOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCell:[NSIndexPath indexPathForRow:self.selectedItem inSection:0] selectState:YES];
    [self.selectionFG selectionChanged];
    [self.delegate cellSelected:self.selectedItem];
}


/** 获取当前被选中的cell*/
- (void)reloadCell:(NSIndexPath *)indexPath selectState:(BOOL)selected {
    UICollectionViewCell *selectCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (selectCell) {
        selectCell.selected = selected;
    }
}

/** 计算离中心最近的Cell*/
- (CGPoint)offect:(CGFloat)centerX direction:(NearestPointDirection)direction {
    NestElement *leftNearestCenters = [self nearestLeftCenter:centerX];
    NSInteger leftCenterIndex = leftNearestCenters.nearestElementIndex;
    CGFloat leftCenter = leftNearestCenters.minimumDistance;
    NestElement *rightNearestCenters = [self nearestRightCenter:centerX];
    NSInteger rightCenterIndex = rightNearestCenters.nearestElementIndex;
    CGFloat rightCenter = rightNearestCenters.minimumDistance;
    NSInteger nearestItemIndex  = NSIntegerMax;
    switch (direction)  {
    case NearestPointDirectionAny:
        if (leftCenter > rightCenter) {
            nearestItemIndex = rightCenterIndex;
        } else {
            nearestItemIndex = leftCenterIndex;
        }
    case NearestPointDirectionLeft:
            nearestItemIndex = leftCenterIndex;
    case NearestPointDirectionRight:
            nearestItemIndex = rightCenterIndex;
    }
    
    self.selectedItem = nearestItemIndex;
    return CGPointMake((CGFloat)(nearestItemIndex) * self.cellSize.normalWidth, 0);
}

/** 最左边元素*/
- (NestElement *)nearestLeftCenter:(CGFloat)centerX {
    NSInteger nearestLeftElementIndex = (centerX - self.collectionViewCenter - self.cellSize.centerWidth + self.cellSize.normalWidth)/self.cellSize.normalWidth;
    CGFloat minimumLeftDistance = centerX - nearestLeftElementIndex * self.cellSize.normalWidth - self.collectionViewCenter - self.cellSize.centerWidth + self.cellSize.normalWidth;
    NestElement *nearElement = [NestElement new];
    nearElement.nearestElementIndex = nearestLeftElementIndex;
    nearElement.minimumDistance = minimumLeftDistance;
    return nearElement;
}

/** 最右边元素*/
- (NestElement *)nearestRightCenter:(CGFloat)centerX {
    NSInteger nearestRightElementIndex = (centerX - self.collectionViewCenter - self.cellSize.centerWidth + self.cellSize.normalWidth)/self.cellSize.normalWidth;
    CGFloat minimumRightDistance = centerX - nearestRightElementIndex * self.cellSize.normalWidth - self.collectionViewCenter - self.cellSize.centerWidth + self.cellSize.normalWidth;
    NestElement *nearElement = [NestElement new];
    nearElement.nearestElementIndex = nearestRightElementIndex;
    nearElement.minimumDistance = minimumRightDistance;
    return nearElement;
}

/** DataSourcenumberOfSections*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CardSlideView:cellForItemAtIndexPath:)]) {
        [self.delegate CardSlideView:self cellForItemAtIndexPath:indexPath];
    }
    HBCardSlideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBCardSlideCell" forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
    if (cell.SelectedCallBack) {
        __weak typeof(self) weakSelf = self;
        cell.SelectedCallBack = ^(id  _Nonnull object) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.SelectedCallBack(object);
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self scrollViewWillBeginDragging:collectionView];
    self.selectedItem = indexPath.item;
    HBCardCollectionViewLayout *layout = [[HBCardCollectionViewLayout alloc] init];
    CGFloat x = (CGFloat)(self.selectedItem) * self.cellSize.normalWidth;
    layout.ignoringBoundsChange = YES;
    [collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
    layout.ignoringBoundsChange = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(scrollViewDidEndDragging:) withObject:collectionView afterDelay:0.3];
    });

}


@end
