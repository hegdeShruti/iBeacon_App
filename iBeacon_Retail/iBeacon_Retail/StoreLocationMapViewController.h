//
//  StoreLocationMapViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/11/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTConfig.h"
#import "ESTLocation.h"
#import "ESTIndoorLocationView.h"
#import "SlideNavigationController.h"
#import "MapPathGenerator.h"
#import "Products.h"
#import "StoreMapView.h"
@interface StoreLocationMapViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SlideNavigationControllerDelegate>


@property (nonatomic,strong) NSUserActivity* screenActivity;
@property BOOL loadedFromMainMenu;
@property (nonatomic, strong) IBOutlet StoreMapView *indoorLocationView;
@property (nonatomic, retain) IBOutlet UITableView *autocompleteTableView;
@property (nonatomic, retain) NSMutableArray *filteredProductList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (nonatomic, assign) IBOutlet MapPathGenerator *pathGeneratorView;
@property (nonatomic, retain) Products *product;
@property(nonatomic,weak)IBOutlet UIView *labelView;
@property(nonatomic,weak)IBOutlet UILabel *textLabel;

@property(nonatomic,strong)IBOutlet UIImageView *productImage;
- (instancetype)initWithLocation:(ESTLocation *)location;

@end
