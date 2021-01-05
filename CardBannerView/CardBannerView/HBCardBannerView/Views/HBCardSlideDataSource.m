//
//  HBCardSlideDataSource.m
//  CardBannerView
//
//  Created by yhb on 2021/1/5.
//

#import "HBCardSlideDataSource.h"
#import "HBCardSlideCell.h"


/** 设置tags状态 */
typedef NS_ENUM(NSInteger, NearestPointDirection) {
    NearestPointDirectionAny,         //!< 任意方向
    NearestPointDirectionLeft,        //!< 左边
    NearestPointDirectionRight,          //!< 右边
};


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

@interface HBCardSlideDataSource ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 滑动速度*/
@property (nonatomic, assign) CGFloat scrollVelocity;

/** 下标选择*/
@property (nonatomic, assign) NSInteger selectedItem;

/** 选择*/
@property (nonatomic, weak) id <HBCardSlideDataDelegate>delegate;

/** 模型*/
@property (nonatomic, strong) NSArray *items;

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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.scrollVelocity = velocity.x;
    
    if (self.scrollVelocity == 0) {
//        targetContentOffset =
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCell:[NSIndexPath indexPathForRow:self.selectedItem inSection:0] selectState:YES];
    
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
    nearElement.nearestElementIndex = nearestLeftElementIndex;
    nearElement.minimumDistance = minimumLeftDistance;
    return nearElement;
}

/** DataSourcenumberOfSections*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CardSlideView:cellForItemAtIndexPath:)]) {
        [self.delegate CardSlideView:self cellForItemAtIndexPath:indexPath];
    }
    HBCardSlideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBCardSlideCell" forIndexPath:indexPath];
    cell.model = self.items[indexPath.row];
    if (cell.SelectedCallBack) {
        __weak typeof(self) weakSelf = self;
        cell.SelectedCallBack = ^(id  _Nonnull object) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.SelectedCallBack(object);
        };
    }
    return cell;
}


/** numberOfItemsInSection*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}
@end
