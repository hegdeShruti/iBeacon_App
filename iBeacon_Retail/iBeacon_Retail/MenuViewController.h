//
//  MenuViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/3/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>

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

@property (nonatomic,strong) NSArray* menuItems;
@property (nonatomic,weak) IBOutlet UITableView* tableview;
@property (nonatomic,weak) id<MenuViewControllerDelegate> delegate;

@end
