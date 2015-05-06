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

typedef NS_ENUM(NSInteger, BeconRetailMenuIndex) {
    BeaconRetailProductIndex=0,
    BeaconRetailOffersIndex,
    BeaconRetailCartIndex,
    BeaconRetailMapIndex,
    BeaconRetailLogoutIndex,
    BeaconRetailNotAMenuOption
};

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
@property(nonatomic,strong) CustomHeaderView *headerView;
@property (nonatomic,strong) NSArray* menuItems;
@property (nonatomic,strong) NSArray* menuImageItems;
@property (nonatomic,weak) IBOutlet UITableView* tableview;

-(UIViewController*) loadMenuScreenAtIndex:(NSInteger) idx;

@end
