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
#import "OfferPopupMenu.h"
#import "OfferButton.h"
#import "GlobalVariables.h"

@interface StoreLocationMapViewController () <ESTIndoorLocationManagerDelegate>

@property (nonatomic, strong) ESTIndoorLocationManager *manager;
@property (nonatomic, strong) ESTLocation *location;
@property(nonatomic,strong) GlobalVariables *globals;

@end

@implementation StoreLocationMapViewController

- (instancetype)initWithLocation:(ESTLocation *)location
{
    self = [super init];
    //    self = [super initWithNibName:@"StoreLocationMapViewController" bundle:nil];
    if (self)
    {
        self.manager = [[ESTIndoorLocationManager alloc] init];
        self.manager.delegate = self;
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
    
    self.title = self.location.name;

    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SlideNavigationController sharedInstance].navigationBar.topItem setTitle:@"Store Map"];
    self.globals.isUserOnTheMapScreen = YES;
    [self.globals getOffers];
    
    self.indoorLocationView.backgroundColor = [UIColor clearColor];
    
    self.indoorLocationView.rotateOnPositionUpdate=NO;
    
    self.indoorLocationView.showWallLengthLabels    = NO;
    
    // self.indoorLocationView.frame = CGRectMake(self.indoorLocationView.frame.origin.x, self.indoorLocationView.frame.origin.y, 350, 350);
    
    self.indoorLocationView.locationBorderColor     = [UIColor clearColor];
    self.indoorLocationView.locationBorderThickness = 4;
    self.indoorLocationView.doorColor               = [UIColor brownColor];
    self.indoorLocationView.doorThickness           = 6;
    self.indoorLocationView.traceColor              = [UIColor blueColor];
    self.indoorLocationView.traceThickness          = 2;
    self.indoorLocationView.wallLengthLabelsColor   = [UIColor blackColor];
    
    [self.indoorLocationView drawLocation:self.location];
    
    // You can change the avatar using positionImage property of ESTIndoorLocationView class.
//    self.indoorLocationView.positionImage = [UIImage imageNamed:@"arrow.png"];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 290)];
    [img setImage:[UIImage imageNamed:@"map.png"]];
    [self.indoorLocationView drawObject:img withPosition:[ESTPoint pointWithX:0 y:0]];
    
    for(ESTPositionedBeacon *beacon in self.location.beacons){
        OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 50)];
        sectionLogo.tag=[GlobalVariables getSectionId:beacon.macAddress];
        [sectionLogo setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal] ;
        [sectionLogo addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
        [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
    }
    //    for(ESTPositionedBeacon *beacon in self.location.beacons){
    //        if([beacon.macAddress isEqualToString:MENSECTION_MAC]){
    //            //Men's Section ...
    //            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 50)];
    //            sectionLogo.tag=2;
    //            sectionLogo.secTitle=@"Men's Section ";
    //            sectionLogo.offerMsg=@"You have 50% off on selected items";
    //            //sectionLogo.backgroundColor=[UIColor whiteColor];
    //            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal] ;
    //            [sectionLogo addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
    //            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
    //        }
    //
    //        else if([beacon.macAddress isEqualToString:WOMENSECTION_MAC]){
    //            //Women's Section ...
    //            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 50)];
    //            sectionLogo.tag=1;
    //            sectionLogo.secTitle=@"Women's Section ";
    //            sectionLogo.offerMsg=@"You have 50% off on selected items";
    ////            sectionLogo.backgroundColor=[UIColor whiteColor];
    //            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal] ;
    //            [sectionLogo addTarget:nil action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
    //            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
    //
    //        }
    //        else if([beacon.macAddress isEqualToString:KIDSSECTION_MAC]){
    //            //Kid's Section ...
    //            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 50)];
    //            sectionLogo.tag=4;
    //            sectionLogo.secTitle=@"Kid's Section ";
    //            sectionLogo.offerMsg=@"You have 50% off on selected items";
    ////            sectionLogo.backgroundColor=[UIColor whiteColor];
    //            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal] ;
    //            [sectionLogo addTarget:nil action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
    //            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
    //        }
    //        else{
    //            //Electronic Section...
    //            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 50)];
    //            sectionLogo.secTitle=@"";
    //            sectionLogo.offerMsg=@"Welcome to Our Store";
    ////            sectionLogo.backgroundColor=[UIColor whiteColor];
    //            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal] ;
    //            [sectionLogo addTarget:nil action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
    //            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
    //
    //        }
    //    }
    
    [self.manager startIndoorLocation:self.location];
}
- (void)showOffer:(id)sender{
    
    NSLog(@"offer  %@",self.globals.offersDataArray);
    [((OfferButton *)sender)setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal] ;
    ((OfferButton *)sender).secTitle=[GlobalVariables returnTitleForSection:((OfferButton *)sender).tag];
    ((OfferButton *)sender).offerMsg=@"You have 50% off on selected items";

    NSArray *resultOfferArray=[self.globals.offersDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %d", @"sectionId",((OfferButton *)sender).tag]];
    NSDictionary *resultOffer;
    if (resultOfferArray !=nil &&  [resultOfferArray count ]!=0)
    resultOffer=[resultOfferArray objectAtIndex:0 ];
    
    if (resultOffer!=nil && [resultOffer count ]!=0) {
    for (id offer in [self.indoorLocationView subviews]) {
        if([offer isKindOfClass:[OfferButton class]] ){
            NSLog(@"tag %lu  %d",((OfferButton *)offer).tag , [[resultOffer valueForKey:@"sectionId"] intValue]);
            if ([[resultOffer valueForKey:@"sectionId"] intValue]==((OfferButton *)offer).tag){
                [((OfferButton *)offer)setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal];
                ((OfferButton *)sender).offerMsg=[NSString stringWithFormat:@"%@\n%@",[resultOffer valueForKey:@"offerHeading"],[resultOffer valueForKey:@"offerDescription"]];

            }
        }

    }
    }
    [self.globals showOfferPopUpWithTitle:((OfferButton *)sender).secTitle message:((OfferButton *)sender).offerMsg andDelegate:self];
//    ((OfferButton *)sender).offerMsg=@"You have 50% off on selected items";

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.manager stopIndoorLocation];
    self.globals.isUserOnTheMapScreen = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - UISwitch events


//-(void)showAlertForSection:

#pragma mark - ESTIndoorLocationManager delegate

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager
            didUpdatePosition:(ESTOrientedPoint *)position
                   inLocation:(ESTLocation *)location
{
    [self.indoorLocationView updatePosition:position];
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didFailToUpdatePositionWithError:(NSError *)error
{
}

#pragma searchBar delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if ([self.filteredProductList count]==0) {
        return;
    }
    NSDictionary *resultProduct=[[self.globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"productName",searchBar.text]] objectAtIndex:0];
    for (id offer in [self.indoorLocationView subviews]) {
        if([offer isKindOfClass:[OfferButton class]] )
            if ([[resultProduct valueForKey:@"sectionId"] intValue]==((OfferButton *)offer).tag){
                NSLog(@"tag %lu  %d",((OfferButton *)offer).tag , [[resultProduct valueForKey:@"sectionId"] intValue]);
                [((OfferButton *)offer)setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal];
            }
    }
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"The product Api is %lu",(unsigned long)[self.globals.productDataArray count]);
    if ([searchText isEqualToString:@""]) {
        for (id offer in [self.indoorLocationView subviews]) {
            if([offer isKindOfClass:[OfferButton class]] )
                [((OfferButton *)offer)setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal];
        }
        self.autocompleteTableView.hidden = YES;
        
        
    }
    else{
        [self.filteredProductList removeAllObjects];
        NSString* searchStr = [NSString stringWithFormat:@"*%@*",searchText];
        [self.filteredProductList addObjectsFromArray:[self.globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"productName",searchStr]]];
        NSLog(@"%@",self.filteredProductList);
        // searchBar.text= [[filtered objectAtIndex:0]valueForKey:@"productName"];
        [self.autocompleteTableView reloadData];
        self.autocompleteTableView.hidden = NO;
    }
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
    
    cell.textLabel.text = [[self.filteredProductList objectAtIndex:indexPath.row]valueForKey:@"productName"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.searchBar.text = selectedCell.textLabel.text;
    
    // [self goPressed];
    
    self.autocompleteTableView.hidden = YES;
    
}

#pragma OfferPopupMenuDelegate methods

-(void)menu:(OfferPopupMenu*)menu willDismissWithSelectedItemAtIndex:(NSUInteger)index{
    
}
-(void)menuwillDismiss:(OfferPopupMenu *)menu{
    for (id offer in [self.indoorLocationView subviews]) {
        if([offer isKindOfClass:[OfferButton class]] )
            [((OfferButton *)offer)setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal];
    }
    
}

#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
@end
