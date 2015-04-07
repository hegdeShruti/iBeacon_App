//
//  MainScreenViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/4/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"
#import "ESTConfig.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "ESTIndoorLocationManager.h"
#import "ESTConfig.h"
#import "ESTLocationBuilder.h"
#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface ViewController ()<ESTBeaconManagerDelegate>
@property(nonatomic,strong)ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property(nonatomic, assign) BOOL hasShownOffersForMen;
@property(nonatomic, assign) BOOL hasShownOffersForWomen;

-(void) checkProximity:(ESTBeacon *)bcn withMessage:(NSString *) msg ;
@end

@implementation ViewController

static ViewController *instance = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
  
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - For Status Bar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(ViewController *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            // instance.hasALreadyLoggedIn=NO;
        }
    }
    return instance;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)loadProductsViewController
{
    
    if(self.productsViewController == nil){
        
        self.productsViewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
        self.productsViewController.delegate=self;
        self.productNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.productsViewController];
        self.productNavigationViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }
    
    self.productNavigationViewController.navigationBarHidden = YES;
//    [self.contentView addSubview:self.productsViewController.view];
        [self.contentView addSubview:self.productNavigationViewController.view];
    
    [self addChildViewController:self.productNavigationViewController];
    [self.productNavigationViewController didMoveToParentViewController:self];
    self.navbar.topItem.title = @"Products";
    self.selectedIndex = productsMenuIndex;
}

-(void) loadOffersViewController: (NSInteger) offerId

{
    
   
    //if(self.offersViewController ==  nil){
        self.offersViewController = [[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:nil];
    //}
    self.offersViewController.offerId=offerId;
    [self.contentView addSubview:self.offersViewController.view];
    
    self.offersViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [self addChildViewController:self.offersViewController];
    [self.offersViewController didMoveToParentViewController:self];
    self.navbar.topItem.title = @"Offers";
    self.selectedIndex = offersMenuIndex;
}

-(void)loadCartViewController
{
    if(self.cartViewController == nil){
        self.cartViewController = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    }
    [self.contentView addSubview:self.cartViewController.view];
    
    self.cartViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [self addChildViewController:self.cartViewController];
    [self.cartViewController didMoveToParentViewController:self];
    
    self.navbar.topItem.title = @"Cart";
    self.selectedIndex = cartMenuIndex;
}

-(void)loadMapViewController
{
    self.navbar.topItem.title = @"Map";
    self.selectedIndex = mapMenuIndex;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if(self.storeLocationMapViewController ==  nil){
        ESTLocation *location = [ESTLocationBuilder parseFromJSON:content];
//        self.storeLocationMapViewController = [[StoreLocationMapViewController alloc] initWithNibName:@"StoreLocationMapViewController" bundle:nil];
        self.storeLocationMapViewController = [[StoreLocationMapViewController alloc] initWithLocation:location];
        GlobalVariables *globalVar = [GlobalVariables getInstance];
        globalVar.storeLocationController = self.storeLocationMapViewController;
    }
    [self.contentView addSubview:self.storeLocationMapViewController.view];
    
    self.storeLocationMapViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [self addChildViewController:self.storeLocationMapViewController];
    [self.storeLocationMapViewController didMoveToParentViewController:self];
    
//    StoreLocationMapViewController *storeMapVC = [[StoreLocationMapViewController alloc] initWithLocation:location];
//    storeMapVC.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
//    [self.navigationController pushViewController:storeMapVC animated:YES];
    
}

//-(void)loadProductDetailViewController
//{
//    if(self.productDetailViewController == nil){
//        self.productDetailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
//    }
//    [self.contentView addSubview:self.productDetailViewController.view];
//    
//    self.productDetailViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
//    
//    [self addChildViewController:self.productDetailViewController];
//    [self.productDetailViewController didMoveToParentViewController:self];
//    self.navbar.topItem.title = @"Products";
//    self.selectedIndex = productDetailMenuIndex;
//}


-(void) resetViews
{
    switch(self.selectedIndex){
        case productsMenuIndex:{
            [self.productNavigationViewController removeFromParentViewController];
            [self.productNavigationViewController.view removeFromSuperview];
            self.productNavigationViewController = nil;
            
            [self.productsViewController removeFromParentViewController];
            [self.productsViewController.view removeFromSuperview];
            self.productsViewController = nil;
            break;
        }
        case offersMenuIndex:{
            //            for (UIView *subView in self.contentView.subviews)
            //            {
            //                if ( [subView isKindOfClass:[OffersViewController class]])
            //                {
            //                    [subView removeFromSuperview];
            //                }
            //            }
            [self.offersViewController removeFromParentViewController];
            [self.offersViewController.view removeFromSuperview];
            self.offersViewController = nil;
            break;
        }
        case cartMenuIndex:{
            [self.cartViewController removeFromParentViewController];
            [self.cartViewController.view removeFromSuperview];
            self.cartViewController = nil;
            break;
        }
        case mapMenuIndex:{
            [self.storeLocationMapViewController removeFromParentViewController];
            [self.storeLocationMapViewController.view removeFromSuperview];
            self.storeLocationMapViewController = nil;
            break;
        }
            
        case logoutIndex:{
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:NO forKey:@"hasALreadyLoggedIn"];
                       
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainScreen];
            break;
        }
//        case productDetailMenuIndex:{
//            [self.productDetailViewController removeFromParentViewController];
//            [self.productDetailViewController.view removeFromSuperview];
//            self.productDetailViewController = nil;
//            break;
//        }
        default:
            break;
            
    }
}


- (IBAction)menuButtonPressed:(id)sender {
    UIBarButtonItem* button = sender;
    NSLog(@"The tag status is %i",button.tag);
    //    UIButton *button = sender;
    switch(button.tag){
        case 0:{
            [self.delegate movePanelToOriginalPosition];
            break;
        }
        case 1:{
            [self.delegate movePanelRight];
            break;
        }
        case 2:{
            [self returnToProductListingScreenFromProductDetailScreen];
            break;
        }
        case 3:{
            [self returnToProductListingScreenFromProductDetailScreen];
            break;
        }
        default:
            break;
            
    }
}

-(void)menuItemSelected:(int)menuItem
{
    switch (menuItem) {
        case productsMenuIndex:
            [self resetViews];
            [self loadProductsViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case offersMenuIndex:
            [self resetViews];
            [self loadOffersViewController:1];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case cartMenuIndex:
            [self resetViews];
            [self loadCartViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case mapMenuIndex:
            [self resetViews];
            [self loadMapViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case logoutIndex:{
          
            // confirm if user wants to logout
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Are you sure you want logout."
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
            
            
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        self.selectedIndex=logoutIndex;
        [self resetViews];
        self.selectedIndex=productsMenuIndex;
    }
    else if([title isEqualToString:@"No"])
    {
        self.resetMainScreenPositionOnMenuSelection();
    }
}

-(void)returnToProductListingScreenFromProductDetailScreen{
//    if(self.selectedIndex == productDetailMenuIndex){
//        [self resetViews];
//    }
    [self.productNavigationViewController popViewControllerAnimated:YES];
    self.menuButton. image = [UIImage imageNamed:@"menu_icon.png"];
    self.menuButton.title  = @"";
    self.menuButton.tag = 1;
    [self.delegate setGesturesOn:YES];
}

- (void)setGesturesOn:(BOOL)switchOn{
    [self.delegate setGesturesOn:switchOn];
}

-(void)toggleMenuButtonOnceProductDetailVCLoaded
{
    self.menuButton. image = nil;
    self.menuButton.title  = @"Back";
    self.menuButton.tag = 2;
}

@end
