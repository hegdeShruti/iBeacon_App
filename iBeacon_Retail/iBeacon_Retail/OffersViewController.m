//
//  OffersViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 04/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "OffersViewController.h"
#import "OffersTableCell.h"
#import "NetworkOperations.h"
#import "Offers.h"
#import "GlobalVariables.h"
#import "Products.h"
#import "ProductDetailViewController.h"
#import "OfferPopupViewController.h"
#import "AppDelegate.h"
#import "ProductDetailViewController.h"


@interface OffersViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *offersImageArray;
@property(nonatomic,strong) NSMutableArray *offersDataArray;
@property(nonatomic,strong) NetworkOperations *networks;
@property(nonatomic,strong) GlobalVariables *globals;
@end

@implementation OffersViewController
@synthesize globals;

- (void)viewDidLoad {
    [super viewDidLoad];
    globals=[GlobalVariables getInstance];
     self.offersImageArray = [[NSMutableArray alloc ]initWithObjects:@"AND gown.png",@"prod1.png",@"Nike Mens Basketball shoes.png",@"Bvlgari Mens perfume.png",@"Seiko Mens Watch.png",@"Philips Hair dryer.png",nil];
    // Do any additional setup after loading the view from its nib.
    if(![globals.offersDataArray count]>0){
        [self getOffersListing];
        
    }
   [self filterOffersforSections];
    [self startUserActivities];   
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *rtButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rtButton setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
    [rtButton addTarget:[GlobalVariables getInstance] action:@selector(loadCartScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtButton];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    [[SlideNavigationController sharedInstance].navigationBar.topItem setTitle:@"Offers"];
    [self.offersTableView reloadData];
//    [self startUserActivities];
//    self.userActivity.needsSave = YES;
    [self updateUserActivityState:self.screenActivity];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.screenActivity invalidate];
    [super viewWillDisappear:animated];
}

-(void) startUserActivities{
    self.screenActivity =  [[NSUserActivity alloc] initWithActivityType:TavantIBeaconRetailContinutiyViewScreen];
    self.screenActivity.title = @"Viewing Product List Screen";
    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:BeaconRetailOffersIndex],@"menuIndex",[GlobalVariables getCartItems], @"cartItems", nil];
    self.screenActivity.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil];
    self.userActivity = self.screenActivity;
    [self.userActivity becomeCurrent];
}

-(void)updateUserActivityState:(NSUserActivity *)activity{
    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:BeaconRetailOffersIndex],@"menuIndex",[GlobalVariables getCartItems], @"cartItems", nil];
    [activity addUserInfoEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil]];
//    [self.screenActivity becomeCurrent];
    [super updateUserActivityState:activity];
    
}

- (void)restoreUserActivityState:(NSUserActivity *)activity{
    if([activity.activityType isEqualToString:TavantIBeaconRetailContinutiyViewProduct]){
        NSDictionary* activityInfo = [activity.userInfo objectForKey:TavantIBeaconRetailContinutiyScreenData];
        ProductDetailViewController* prodDetailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        prodDetailVC.product = (Products*)[activityInfo objectForKey:@"product"];
        prodDetailVC.prevScreen = BeaconRetailOffersIndex;
        prodDetailVC.prevVCForUserActivityFlow = self;
        [prodDetailVC restoreUserActivityState:activity];
        [[SlideNavigationController sharedInstance] pushViewController:prodDetailVC animated:YES];
    }
    [super restoreUserActivityState:activity];
}

// hardcoding section data for now
-(void)filterOffersforSections{
    switch (self.offerId) {
        case 1: self.offersDataArray=[[NSMutableArray alloc]initWithArray:globals.offersDataArray];
            
            break;
        case 2: self.offersDataArray=[[NSMutableArray alloc] initWithObjects:[globals.offersDataArray objectAtIndex:2], nil];
            
            break;
        case 3:self.offersDataArray=[[NSMutableArray alloc] initWithObjects:[globals.offersDataArray objectAtIndex:0], nil];
            
            break;
        case 4:self.offersDataArray=[[NSMutableArray alloc] initWithObjects:[globals.offersDataArray objectAtIndex:1], nil];
            break;
            
        default:self.offersDataArray=[[NSMutableArray alloc]initWithArray:globals.offersDataArray];
            break;
    }
     [self.offersTableView reloadData];
}

-(void) getOffersListing{
    self.networks=[[NetworkOperations alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"The product Api is %@",[dict objectForKey:@"Offers_Api"]);
    // send block as parameter to get callbacks
    [self.networks fetchDataFromServer:[dict objectForKey:@"Offers_Api"] withreturnMethod:^(NSMutableArray* data){
        globals.offersDataArray=data;
        NSLog(@"The product Api is %lu",(unsigned long)[globals.offersDataArray count]);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                          // [self.offersTableView reloadData];
                           [self filterOffersforSections];
                           
                       });
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.offersDataArray count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 103;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    OffersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OffersTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Offers *offerObject=[[Offers alloc]initWithDictionary:[self.offersDataArray objectAtIndex:indexPath.row] ];
   
    NSArray *productsArray = [globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(offerid == %@)", offerObject.offerId]];
    Products *prodObject;
    if([productsArray count]>0){
        prodObject=[[Products alloc]  initWithDictionary:[productsArray objectAtIndex:0]];
    }
       cell.offerHeader.text=prodObject.prodName;
    cell.offerDescription.text=offerObject.offerHeading;
    cell.offerInfo.text=offerObject.offerDescription;
    cell.offerImage.image=[UIImage imageNamed:[self.offersImageArray objectAtIndex:indexPath.row]];
    
    // Configure Cell
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    
//    UIGraphicsBeginImageContext(CGSizeMake(mainFrame.size.width, mainFrame.size.height));
//    [self.parentViewController.view drawViewHierarchyInRect:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height) afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [globals showOfferPopUp:@"Camera" andMessage:@"Rush to avail offers" onController:self withImage:image];
    Offers *offerObject= [[Offers alloc] initWithDictionary:[globals.offersDataArray objectAtIndex:indexPath.row]];
    NSArray *productsArray = [globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(offerid == %@)", offerObject.offerId]];
    Products *prodObject;
    if([productsArray count]>0){
        prodObject=[[Products alloc]  initWithDictionary:[productsArray objectAtIndex:0]];
       // prodObject.prodImage=[self.offersImageArray objectAtIndex:indexPath.row];
    }
    
    ProductDetailViewController* prodDetailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    prodDetailVC.product = prodObject;
    prodDetailVC.prevScreen = BeaconRetailOffersIndex;
    [[SlideNavigationController sharedInstance] pushViewController:prodDetailVC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuButtonCLicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}
@end
