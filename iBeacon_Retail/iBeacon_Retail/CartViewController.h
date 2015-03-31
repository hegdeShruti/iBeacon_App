//
//  CartViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/24/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartTableViewCell.h"
#import "NetworkOperations.h"
#import "GlobalVariables.h"
#import "CartItem.h"

@interface CartViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView* tableview;
@property (nonatomic,strong) NSArray* tableData;
@property (nonatomic,weak) IBOutlet UILabel* totalValue;

-(void) getCartListing;
@end
