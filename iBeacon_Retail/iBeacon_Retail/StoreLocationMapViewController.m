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
#import "AOShortestPath.h"

@interface StoreLocationMapViewController () <ESTIndoorLocationManagerDelegate>

@property (nonatomic, strong) ESTIndoorLocationManager *manager;
@property (nonatomic, strong) ESTLocation *location;
@property(nonatomic,strong) GlobalVariables *globals;

@property (strong, nonatomic) AOShortestPath *pathManager;
@property (strong, nonatomic) NSArray *plane;

@property (strong, nonatomic) UIButton *startField;
@property (strong, nonatomic) UIButton *targetField;

@property (strong, nonatomic) UIImageView *person;

@property (assign, nonatomic) BOOL search;

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
    
    self.globals.isUserOnTheMapScreen = YES;
    [self.globals getOffers];
    
//    self.indoorLocationView.backgroundColor = [UIColor clearColor];
//    
//    self.indoorLocationView.rotateOnPositionUpdate=NO;
//    
//    self.indoorLocationView.showWallLengthLabels    = NO;
//    
//    // self.indoorLocationView.frame = CGRectMake(self.indoorLocationView.frame.origin.x, self.indoorLocationView.frame.origin.y, 350, 350);
//    
//    self.indoorLocationView.locationBorderColor     = [UIColor clearColor];
//    self.indoorLocationView.locationBorderThickness = 4;
//    self.indoorLocationView.doorColor               = [UIColor brownColor];
//    self.indoorLocationView.doorThickness           = 6;
//    self.indoorLocationView.traceColor              = [UIColor blueColor];
//    self.indoorLocationView.traceThickness          = 2;
//    self.indoorLocationView.wallLengthLabelsColor   = [UIColor blackColor];
//    
//    [self.indoorLocationView drawLocation:self.location];
//    
//    // You can change the avatar using positionImage property of ESTIndoorLocationView class.
////    self.indoorLocationView.positionImage = [UIImage imageNamed:@"arrow.png"];
//    
//    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 290)];
//    [img setImage:[UIImage imageNamed:@"map.png"]];
//    [self.indoorLocationView drawObject:img withPosition:[ESTPoint pointWithX:0 y:0]];
//    
//    for(ESTPositionedBeacon *beacon in self.location.beacons){
//        OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 50)];
//        sectionLogo.tag=[GlobalVariables getSectionId:beacon.macAddress];
//        [sectionLogo setBackgroundImage:[UIImage imageNamed:@"map-pin-red.png"] forState: UIControlStateNormal] ;
//        [sectionLogo addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
//        [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
//    }
//
//    [self.manager startIndoorLocation:self.location];
    
    _pathManager = [[AOShortestPath alloc] init];
    _pathManager.pointList = [NSMutableArray array];
    
    // create visual structure of plane
    _plane = @[
               @[@1,@0,@1,@1,@1,@1,@1],
               @[@1,@1,@1,@0,@0,@0,@1],
               @[@1,@0,@1,@0,@1,@0,@1],
               @[@1,@0,@0,@0,@1,@0,@1],
               @[@1,@0,@1,@0,@1,@1,@1],
               @[@1,@0,@1,@0,@0,@1,@1],
               @[@1,@0,@1,@0,@1,@1,@1],
               @[@1,@0,@1,@0,@1,@1,@1],
               @[@1,@0,@1,@1,@1,@1,@1]
               ];
    
    // set default field size
    CGFloat size = 45;//self.indoorLocationView.frame.size.width/[_plane[0] count];
    
    // generate plans's fields
    for (int i = 0; i<_plane.count; i++) {
        NSArray *row = _plane[i];
        for (int j=0; j<row.count; j++) {
            UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(j*size, i*size+50, size, size)];
            l.tag = i*10 + j + 1;
            l.backgroundColor = [UIColor whiteColor];
            l.layer.borderColor = [UIColor whiteColor].CGColor;
            l.layer.borderWidth = 1;
            NSNumber *num = _plane[i][j];
            if ([num integerValue] == 0) {
                [l setTitle:@"X" forState:UIControlStateNormal];
                l.backgroundColor = [UIColor blackColor];
            } else {
                //[l setTitle:[NSString stringWithFormat:@"%d%d", i, j] forState:UIControlStateNormal];
            }
            if (l.tag == 76) {
                l.backgroundColor = [UIColor whiteColor];
            }
            [l addTarget:self action:@selector(actionField:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:l];
            
            // add path path point
            AOPathPoint *p = [[AOPathPoint alloc] initWithTag:l.tag];
            [_pathManager.pointList addObject:p];
        }
    }
    
    // create path connections
    for (int i = 0; i<_pathManager.pointList.count; i++) {
        AOPathPoint *p = _pathManager.pointList[i];
        NSArray *connectionList = [self getConnectionListForTag:p.tag];
        [connectionList enumerateObjectsUsingBlock:^(UIButton *b, NSUInteger idx, BOOL *stop) {
            AOPathConnection *c = [[AOPathConnection alloc] init];
            if (p.tag == 76) {
                // its very hard to get on this field
                c.weight = 10;
            }
            c.point = [_pathManager getPathPointWithTag:b.tag];
            [p addConnection:c];
        }];
    }
    
    _startField = (UIButton*)[self.view viewWithTag:1];
    _startField.backgroundColor = [UIColor greenColor];
    
    _person = [[UIImageView alloc] initWithFrame:_startField.frame];
    _person.contentMode = UIViewContentModeScaleAspectFit;
    _person.image = [UIImage imageNamed:@"person.png"];
    [self.view addSubview:_person];

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

- (void)actionField:(UIButton*)sender {
    if (!_search) {
        _search = YES;
        sender.backgroundColor = [UIColor greenColor];
        _targetField = sender;
        
        AOPathPoint *startPoint = [_pathManager getPathPointWithTag:_startField.tag];
        AOPathPoint *endPoint = [_pathManager getPathPointWithTag:_targetField.tag];
        NSArray *path = [_pathManager getShortestPathFromPoint:startPoint toPoint:endPoint];
        if (path.count) {
            NSMutableArray *buttonPath = [NSMutableArray array];
            for (AOPathPoint *p in path) {
                UIButton *but = (UIButton*)[self.view viewWithTag:p.tag];
                UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(but.frame.size.width/2 - 5, but.frame.size.height/2 - 5, 10, 10)];
                dotView.layer.cornerRadius = 2.0;
                dotView.backgroundColor = [UIColor redColor];
                [but addSubview:dotView];
                //but.backgroundColor = [UIColor redColor];
                [buttonPath addObject:but];
            }
            [self animate:buttonPath withCompletion:^{
                for (UIButton *b in self.view.subviews) {
                    if ([b isKindOfClass:[UIButton class]]) {
                        if ([b.currentTitle isEqualToString:@"X"]) {
                            b.backgroundColor = [UIColor blackColor];
                        } else if (b.tag == 76) {
                            b.backgroundColor = [UIColor whiteColor];
                        } else {
                            b.backgroundColor = [UIColor whiteColor];
                            [b.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                        }
                    }
                }
                _search = NO;
                _startField = _targetField;
                _startField.backgroundColor = [UIColor greenColor];
            }];
        } else {
            _search = NO;
        }
    }
}

- (void)animate:(NSArray*)path withCompletion:(void(^)())completion {
    NSMutableArray *animatePoints = [NSMutableArray array];
    for (UIButton *field in path) {
        void (^p)(void) = ^{
            _person.center = field.center;
        };
        [animatePoints addObject:p];
    }
    
    float duration = 0.1;
    long numberOfKeyframes = path.count;
    [UIView animateKeyframesWithDuration:duration*numberOfKeyframes delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
        for (long i=0; i<numberOfKeyframes; i++) {
            [UIView addKeyframeWithRelativeStartTime:duration*i relativeDuration:duration animations:animatePoints[i]];
        }
        
    } completion:^(BOOL finished) {
        completion();
    }];
}

// we need this method to easily generate connections for basic 2d game plane
- (NSArray*)getConnectionListForTag:(long)tag {
    int row = tag/10;
    int col = tag-row*10;
    
    NSString *titleX = @"X";
    
    NSMutableArray *cons = [NSMutableArray array];
    if (col-1 > 0) {
        UIButton *but = (UIButton*)[self.view viewWithTag:(row*10+col-1)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (col+1 < [_plane[0] count]+1) {
        UIButton *but = (UIButton*)[self.view viewWithTag:(row*10+col+1)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (row-1 >= 0) {
        UIButton *but = (UIButton*)[self.view viewWithTag:((row-1)*10+col)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (row+1 < [_plane count]) {
        UIButton *but = (UIButton*)[self.view viewWithTag:((row+1)*10+col)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    
    return cons;
}

#pragma mark Slide view delegate method
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
@end
