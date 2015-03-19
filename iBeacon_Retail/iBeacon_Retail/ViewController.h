//
//  ViewController.h
//  iBeacon_Retail
//
//  Created by ShrutiHegde on 2/27/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//
//
//  MainScreenViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/4/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ProductViewController.h"
#import "OffersViewController.h"
#import "StoreLocationMapViewController.h"
#import "GlobalVariables.h"


@protocol MainScreeViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
@end


@interface ViewController : UIViewController <MenuViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) void (^resetMainScreenPositionOnMenuSelection)(void);
@property (assign) menuIndexes selectedIndex;
@property (nonatomic,weak) IBOutlet UIBarButtonItem* menuButton;
@property (nonatomic,weak) IBOutlet UINavigationBar* navbar;
@property (nonatomic,weak) IBOutlet UIView* contentView;
@property (nonatomic,weak) id<MainScreeViewControllerDelegate> delegate;
@property (nonatomic, strong) ProductViewController* productsViewController;
@property (nonatomic, strong) OffersViewController* offersViewController;
@property (nonatomic, strong) StoreLocationMapViewController* storeLocationMapViewController;

- (IBAction)menuButtonPressed:(id)sender;
-(void)loadProductsViewController;
-(void)loadOffersViewController:(NSInteger) offerId;
-(void)loadCartViewController;
-(void)loadMapViewController;


@end
