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

@property (nonatomic,weak) id<productViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *prodCollectionView;
@property (nonatomic,weak) IBOutlet UISearchBar* searchBar;
@end
