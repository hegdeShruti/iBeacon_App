//
//  MenuViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/3/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LoginViewController.h"
#import "ProductViewController.h"
#import "OffersViewController.h"
#import "CartViewController.h"
#import "StoreLocationMapViewController.h"
#import "AppDelegate.h"
#import "CustomHeaderView.h"


@protocol MenuViewControllerDelegate <NSObject,UIAlertViewDelegate>

@optional
- (void)menuItemSelected:(int) menuItem;
@end

typedef enum {
    productsMenuIndex = 0,
    offersMenuIndex = 1,
    cartMenuIndex = 2,
    mapMenuIndex = 3,
    logoutIndex=4,
//    productDetailMenuIndex = 5,
} menuIndexes;

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
@property(nonatomic,strong) CustomHeaderView *headerView;
@property (nonatomic,strong) NSArray* menuItems;
@property (nonatomic,strong) NSArray* menuImageItems;
@property (nonatomic,weak) IBOutlet UITableView* tableview;
@property (nonatomic,weak) id<MenuViewControllerDelegate> delegate;

@end
