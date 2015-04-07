//
//  ProductDetailViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/31/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductImageCollectionViewCell.h"
#import "ProductRecommendationCollectionViewCell.h"
#import "Products.h"

@interface ProductDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UICollectionViewDelegate>
@property (nonatomic,strong) NSArray* productImagesArray;
@property (nonatomic,strong) NSArray* recommendationDataArray;
@property (nonatomic,strong) Products* product;

@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,weak) IBOutlet UIScrollView* scrollview;
@property (nonatomic,weak) IBOutlet UIView* contentView;

@property (weak, nonatomic) IBOutlet UICollectionView *productImageCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *recommendationCollectionView;

- (IBAction)pageControlChanged:(UIPageControl *)sender;
@end
