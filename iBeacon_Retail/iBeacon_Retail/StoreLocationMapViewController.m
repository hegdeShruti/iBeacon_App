//
//  StoreLocationMapViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/11/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "StoreLocationMapViewController.h"
#import "ESTIndoorLocationManager.h"
#import "ESTIndoorLocationView.h"
#import "Constants.h"
#import "GlobalVariables.h"
#import "AOShortestPath.h"
#import "UIImageView+WebCache.h"

//#import "OfferPopupMenu.h"
//#import "OfferButton.h"
#define OFFER_TAG_OFFSET 1000;

@interface StoreLocationMapViewController ()

@property (nonatomic, strong) ESTLocation *location;
@property(nonatomic,strong) GlobalVariables *globals;
@property (strong, nonatomic) UIImageView *person;
@end


@implementation StoreLocationMapViewController

- (instancetype)initWithLocation:(ESTLocation *)location
{
    self = [super init];
    if (self)
    {
        self.globals=[GlobalVariables getInstance];
        self.location = location;
        self.filteredProductList=[NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![ESTConfig isAuthorized])
    {
        //TODO:  this info can be found in the app secion of account details of the account/user the beacons are registered to (www.cloud.estimote.com)
        [ESTConfig setupAppID:@"app_16ipimrjvr" andAppToken:@"c370acc9642ae3ca99dfc571dc25b646"];
    }
    
    self.title = @"Store Map";
    
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.hidden = YES;
   [self startUserActivities];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    UIButton *rtButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rtButton setImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
    [rtButton addTarget:self action:@selector(clearPath:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtButton];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    self.globals.isUserOnTheMapScreen = YES;
    [self.globals getOffers];

    [self.indoorLocationView setupLocation:_location product:_product withParentController:self];
    [self.indoorLocationView startLocation];
//    [self startUserActivities];
//    self.userActivity.needsSave = YES;
    [self updateUserActivityState:self.screenActivity];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
   [self.indoorLocationView stopLocation];
    self.globals.isUserOnTheMapScreen = NO;
    [self.screenActivity invalidate];
    [super viewWillDisappear:animated];
}

-(void) startUserActivities{
    self.screenActivity =  [[NSUserActivity alloc] initWithActivityType:TavantIBeaconRetailContinutiyViewScreen];
    self.screenActivity.title = @"Viewing Product List Screen";
    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:BeaconRetailMapIndex],@"menuIndex",[GlobalVariables getCartItems], @"cartItems", nil];
    self.screenActivity.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil];
    self.userActivity = self.screenActivity;
    [self.userActivity becomeCurrent];
}

-(void)updateUserActivityState:(NSUserActivity *)activity{
    NSDictionary* activityData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:BeaconRetailMapIndex],@"menuIndex",[GlobalVariables getCartItems], @"cartItems", nil];
    [activity addUserInfoEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:activityData,TavantIBeaconRetailContinutiyScreenData, nil]];
//    [self.screenActivity becomeCurrent];
    [super updateUserActivityState:activity];
    
}

-(IBAction)clearPath:(id)sender{
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _labelView.hidden = NO;
    _autocompleteTableView.hidden = YES;
    
    [self.indoorLocationView clearPath];
}


-(void)showNoItemAlert{
    UIAlertView *noItemAlertView = [[UIAlertView alloc] initWithTitle:@"The item searched for is not found in the store" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [noItemAlertView show];
    self.autocompleteTableView.hidden = YES;
    self.labelView.hidden = NO;
}

#pragma searchBar delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if ([self.filteredProductList count]==0 || [self.filteredProductList containsObject:searchBar.text]) {
        [self showNoItemAlert];
        searchBar.text = @"";
        return;
    }
    NSArray *tempArray = [self.globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"productName",searchBar.text]];
    if([tempArray count] > 0){
        NSDictionary *resultProduct=[tempArray objectAtIndex:0];
        Products *product = [(Products *)[Products alloc] initWithDictionary:resultProduct];
        [self.indoorLocationView locateProduct:product];

    }
    else{
        [self showNoItemAlert];
        searchBar.text = @"";
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.autocompleteTableView.hidden = YES;
    }
    else{
        [self.filteredProductList removeAllObjects];
        NSString* searchStr = [NSString stringWithFormat:@"*%@*",searchText];
        [self.filteredProductList addObjectsFromArray:[self.globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like[c] %@", @"productName",searchStr]]];
        //searchBar.text= [[filtered objectAtIndex:0]valueForKey:@"productName"];
        [self.autocompleteTableView reloadData];
        self.autocompleteTableView.hidden = NO;
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar) {
        [self.searchBar resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return self.filteredProductList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.filteredProductList count]==0) {
        return nil;
    }
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:232.0/255.0 blue:237.0/255.0 alpha:0.7];
    cell.textLabel.text = [[self.filteredProductList objectAtIndex:indexPath.row]valueForKey:@"productName"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.searchBar.text = selectedCell.textLabel.text;
    self.autocompleteTableView.hidden = YES;
    
}

#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if(self.loadedFromMainMenu == YES){
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

@end
