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

@interface StoreLocationMapViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SlideNavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet ESTIndoorLocationView *indoorLocationView;
@property (nonatomic, retain) IBOutlet UITableView *autocompleteTableView;
@property (nonatomic, retain) NSMutableArray *filteredProductList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) IBOutlet MapPathGenerator *pathGeneratorView;
- (instancetype)initWithLocation:(ESTLocation *)location;

@end
