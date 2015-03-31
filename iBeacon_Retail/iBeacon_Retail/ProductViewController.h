//
//  ProductViewController.h
//  iBeacon_Retail
//
//  Created by shruthi on 02/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

@interface ProductViewController : UIViewController<UICollectionViewDataSource,MenuViewControllerDelegate,UICollectionViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *prodCollectionView;
@property (nonatomic,weak) IBOutlet UISearchBar* searchBar;
@end
