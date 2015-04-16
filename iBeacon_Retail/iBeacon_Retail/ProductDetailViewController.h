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
#import "StoreLocationMapViewController.h"
#import "GlobalVariables.h"
#import "Products.h"


@interface ProductDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UICollectionViewDelegate>
@property (nonatomic,strong) NSArray* productImagesArray;
@property (nonatomic,strong) NSArray* recommendationDataArray;
@property (nonatomic,strong) Products* product;
@property(nonatomic,strong) NSString *selectedImage;

@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,weak) IBOutlet UIScrollView* scrollview;
@property (nonatomic,weak) IBOutlet UIView* contentView;

@property (weak, nonatomic) IBOutlet UICollectionView *productImageCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *recommendationCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *locateProductButton;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sizeButtonCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *cartButton;
- (IBAction)pageControlChanged:(UIPageControl *)sender;
- (IBAction)sizeButtonSelected:(id)sender;
- (IBAction)locateProduct:(UIButton *)sender;
- (IBAction)addProductToCart:(id)sender;
@end
