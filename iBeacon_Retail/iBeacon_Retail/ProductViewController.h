//
//  ProductViewController.h
//  iBeacon_Retail
//
//  Created by shruthi on 02/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ProductDetailViewController.h"
#import "SlideNavigationController.h"

@protocol productViewControllerDelegate <NSObject>

@required
-(void) toggleMenuButtonOnceProductDetailVCLoaded;
@optional
-(void) setGesturesOn:(BOOL) switchOn;
@end


@interface ProductViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate, SlideNavigationControllerDelegate>


@property (nonatomic,strong) NSUserActivity* screenActivity;
@property (nonatomic,strong) NSMutableArray *products;
@property (nonatomic,strong) NSArray *searchFilteredProducts;
@property (nonatomic,strong) NSString* searchString;


@property (nonatomic,weak) id<productViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *prodCollectionView;
@property (nonatomic,weak) IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong) NSArray *entries;
@property (weak, nonatomic) IBOutlet UIView *loadingIndicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end
