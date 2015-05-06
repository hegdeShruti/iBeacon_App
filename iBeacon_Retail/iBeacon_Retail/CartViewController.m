//
//  CartViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/24/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "CartViewController.h"
#import "UIImageView+WebCache.h"

@interface CartViewController ()

@property(nonatomic,strong)NetworkOperations *networks;
@property(nonatomic,assign) float total;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.tableData = [NSArray arrayWithObjects:@"1",@"2",nil];
//    [self.tableview registerClass:[CartTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CartTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self getCartListing];
    self.total=0;
    [self.tableview reloadData];
    
    
}

-(void)viewWillLayoutSubviews{
    [[SlideNavigationController sharedInstance].navigationBar.topItem setTitle:@"Cart"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self EnablePayButtonOnNavBar:YES];
    [self startUserActivities];
    [self updateUserActivityState:self.screenActivity];
    [self getCartListing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self EnablePayButtonOnNavBar:NO];
    [self.screenActivity invalidate];
    NSLog(@"CART SCREEN UNLOADING");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) startUserActivities{
    NSUserActivity* newActivity =  [[NSUserActivity alloc] initWithActivityType:TavantIBeaconRetailContinutiyViewScreen];
    newActivity.title = @"Viewing Product List Screen";
    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:BeaconRetailCartIndex],@"menuIndex",[GlobalVariables getCartItems],@"cartItems",nil];
    newActivity.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil];
    self.screenActivity = newActivity;
    [self.screenActivity becomeCurrent];
}

-(void)updateUserActivityState:(NSUserActivity *)activity{
    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:BeaconRetailCartIndex],@"menuIndex",[GlobalVariables getCartItems],@"cartItems",nil];
    [activity addUserInfoEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil]];
    [super updateUserActivityState:activity];
}

- (void)restoreUserActivityState:(NSUserActivity *)activity{
    NSDictionary* activityInfo = [activity.userInfo objectForKey:TavantIBeaconRetailContinutiyScreenData];
    NSArray* cartItems = [activityInfo objectForKey:@"cartItems"];
    [GlobalVariables clearCartItems];
    [GlobalVariables updateCartItemsWithNewData:cartItems];
    [self getCartListing];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell* cell = (CartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    CartItem* item = (CartItem*)[self.tableData objectAtIndex:indexPath.row];
    
    Products *prodObject= item.product;
    cell.product = prodObject;
    
    cell.productName.text = prodObject.prodName;
    cell.prodDescription.text = prodObject.prodDescription;
    cell.price.text = prodObject.price;
    cell.subTotal.text = prodObject.price;
    NSString *str=[prodObject.price  substringFromIndex:1];
    self.total+=[str floatValue];
    self.totalValue.text=[NSString stringWithFormat:@"$%.2f",self.total];
    
    //NSLog(@"Product Image = %@",prodObject.prodImage );
    [cell.prodImage sd_setImageWithURL:[NSURL URLWithString:[prodObject.prodImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] placeholderImage:[UIImage imageNamed:@"1.png"]];
    //cell.prodImage.image=[UIImage imageNamed:prodObject.prodImage];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        CartItem* item = (CartItem*)[self.tableData objectAtIndex:indexPath.row];
        [GlobalVariables removeItemFromCart:item];
        [self updateUserActivityState:self.screenActivity];
        [self getCartListing];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark This method will be replaced with api call to get cart items to be displayed in the tableview

-(void) getCartListing{
    self.tableData = [[GlobalVariables getCartItems] copy];
    [self.tableview reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

-(void)EnablePayButtonOnNavBar: (BOOL) showPayButton{
    if(showPayButton == YES)
    {
        UIButton *rtButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//        [rtButton setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
        [rtButton setTitle:@"Pay" forState:UIControlStateNormal];
        [rtButton addTarget:self action:@selector(payWithApplePay) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtButton];
        [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    }else{
        UIButton *rtButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [rtButton setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
        [rtButton addTarget:[GlobalVariables getInstance] action:@selector(loadCartScreen) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtButton];
        [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    }
}

-(void)payWithApplePay{
    NSLog(@"Load Apple pay screen!!!");
    UIAlertView* payAlert = [[UIAlertView alloc] initWithTitle:@"Pay with Apple Pay" message:@"Coming Soon!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [payAlert show];
}

@end
