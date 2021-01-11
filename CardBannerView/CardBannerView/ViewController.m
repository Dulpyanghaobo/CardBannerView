//
//  ViewController.m
//  CardBannerView
//
//  Created by yhb on 2021/1/4.
//

#import "ViewController.h"
#import "HBCardSlideCellSize.h"
#import "HBCardSlideDataSource.h"
#import "HBCardCollectionViewLayout.h"
#import "HBCardSlideCell.h"

@interface ViewController ()<HBCardSlideDataDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HBCardSlideDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    HBCardSlideCellSize *cellSize = [[HBCardSlideCellSize alloc]initWithNormal:100 center:160];
    HBCardCollectionViewLayout *layout = [[HBCardCollectionViewLayout alloc]initWithCellSize:cellSize];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 300, 100) collectionViewLayout:layout];

    self.dataSource = [[HBCardSlideDataSource alloc] initWithCollectionView:self.collectionView cardSlideCellSize:cellSize];
    self.dataSource.delegate = self;
    [self.collectionView registerClass:[HBCardSlideCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate =UIScrollViewDecelerationRateFast;
    self.collectionView.backgroundColor = [UIColor clearColor];

    self.collectionView.delegate = self.dataSource;
    self.collectionView.dataSource = self.dataSource;

    self.dataSource.items = @[@"A",@"B",@"C",@"D"];

}
- (void)cellSelected:(NSInteger)index {
    
}
//- (UICollectionViewCell *)CardSlideView:(HBCardSlideDataSource *)CardSlideView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
////    HBCardSlideCell *cell = [CardSlideView];
//    return cell;
//}
@end
