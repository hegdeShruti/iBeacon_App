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
#define OFFER_TAG_OFFSET 1000;

@interface StoreLocationMapViewController () <ESTIndoorLocationManagerDelegate>

@property (nonatomic, strong) ESTIndoorLocationManager *manager;
@property (nonatomic, strong) ESTLocation *location;
@property(nonatomic,strong) GlobalVariables *globals;

@property (strong, nonatomic) AOShortestPath *pathManager;
@property (strong, nonatomic) NSArray *plane;

@property (strong, nonatomic) UIButton *startField;
@property (strong, nonatomic) UIButton *targetField;

@property (strong, nonatomic) UIImageView *person;
@property (assign, nonatomic) int startTag;

@property (assign, nonatomic) BOOL search;

@property (assign, nonatomic) CGFloat frameWidthFactor;
@property (assign, nonatomic) CGFloat frameHeightFactor;

@property (strong, nonatomic) NSMutableArray *pathArray;

@property(nonatomic,weak)IBOutlet UIView *labelView;
@property(nonatomic,weak)IBOutlet UILabel *textLabel;

@property(nonatomic,strong)NSMutableArray *wommenSectionTagArray;
@end

BOOL isSearchEnabled = NO;

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
    self.indoorLocationView.positionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.indoorLocationView.positionView setBackgroundColor:[UIColor clearColor]];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(-47, 0, 320, 320)];
        [img setImage:[UIImage imageNamed:@"StoreMap.png"]];
        img.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
        img.layer.borderWidth = 4.0;
        [self.indoorLocationView addSubview:img];
    

        [self.manager startIndoorLocation:self.location];
    
    _pathManager = [[AOShortestPath alloc] init];
    _pathManager.pointList = [NSMutableArray array];
     _wommenSectionTagArray = [NSMutableArray array];
    // create visual structure of plane
    _plane = @[
               @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0], //1
               @[@0,@0,@1,@1,@1,@1,@1,@1,@1,@0], //2
               @[@0,@1,@0,@0,@1,@0,@0,@0,@1,@0], //3
               @[@0,@1,@0,@1,@1,@1,@1,@0,@1,@0], //4
               @[@0,@1,@1,@1,@0,@0,@1,@1,@1,@0], //5
               @[@0,@1,@0,@1,@0,@0,@1,@0,@1,@0], //6
               @[@0,@1,@0,@1,@1,@1,@1,@0,@1,@0], //7
               @[@0,@1,@1,@0,@1,@0,@0,@0,@1,@0], //8
               @[@0,@1,@1,@1,@1,@1,@1,@1,@1,@0], //9
               @[@0,@0,@0,@1,@0,@0,@0,@0,@0,@0]//14
               ];
    
    // set default field size
   // CGFloat size = 45/2;//self.indoorLocationView.frame.size.width/[_plane[0] count];
    _frameWidthFactor = self.indoorLocationView.frame.size.width/[_plane[0] count];
    _frameHeightFactor = self.indoorLocationView.frame.size.height/[_plane count];
    
    // generate plans's fields
    for (int i = 0; i<_plane.count; i++) {
        NSArray *row = _plane[i];
        for (int j=0; j<row.count; j++) {
            UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(j*_frameWidthFactor-47, i*_frameHeightFactor, _frameWidthFactor, _frameHeightFactor)];
            l.tag = i*20 + j + 1;
            l.backgroundColor = [UIColor clearColor];
            l.layer.borderColor = [UIColor clearColor].CGColor;
            l.layer.borderWidth = 0;
            NSNumber *num = _plane[i][j];
            if ([num integerValue] == 0) {
                [l setTitle:@"X" forState:UIControlStateNormal];
                l.backgroundColor = [UIColor clearColor];
//                [l setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            } else {
                l.backgroundColor = [UIColor clearColor];

                //[l setTitle:[NSString stringWithFormat:@"%d%d", i, j] forState:UIControlStateNormal];
            }
            if (l.tag == 76) {
                l.backgroundColor = [UIColor clearColor];
            }
            [self.indoorLocationView addSubview:l];
            if((i>2&&i<7)&& j<3){
                l.backgroundColor = [UIColor purpleColor];
                [_wommenSectionTagArray addObject:[NSNumber numberWithInt:l.tag]];
            }
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
    
}
- (void)showOffer:(id)sender{
    
    NSLog(@"offer  %@",self.globals.offersDataArray);
    [((OfferButton *)sender)setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal] ;
    SectionIdentifier section=1;
    ((OfferButton *)sender).secTitle=[GlobalVariables returnTitleForSection:section];
    ((OfferButton *)sender).offerMsg=@"You have 50% off on selected items";
    
    NSArray *resultOfferArray=[self.globals.offersDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %d", @"sectionId",section]];
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
//   [self.globals showOfferPopUpWithTitle:((OfferButton *)sender).secTitle message:((OfferButton *)sender).offerMsg andDelegate:self];
//    GlobalVariables * globals=[GlobalVariables getInstance];
//    CGRect mainFrame = [UIScreen mainScreen].bounds;
//    UIGraphicsBeginImageContext(CGSizeMake(mainFrame.size.width, mainFrame.size.height));
//    [self.window.rootViewController.view drawViewHierarchyInRect:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height) afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [globals showOfferPopUp:[notification.userInfo valueForKey:@"offerDescription" ] andMessage:[notification.userInfo valueForKey:@"offerDescription" ] onController:self.window.rootViewController withImage:image];
    
//}

    [self.globals showOfferPopUp:((OfferButton *)sender).secTitle andMessage:((OfferButton *)sender).offerMsg onController:self withImage:[UIImage imageNamed:@"map-pin-green.png"]];
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
    NSLog(@"Normal POsition %f,%f",position.x,position.y);
//    NSLog(@"POsition is %f,%f", fabsf(ceilf(-4.5) -5),ceilf(-4.5) +5);
    
    float positionX,positionY;
    positionX = ceilf(position.y);
    positionY = ceilf(position.x);
    
    positionX=positionX > 0 ?positionX-4:positionX-5;
    positionX=fabsf(positionX);
    positionY=positionY < 0 ?positionY+6:positionY+5;
    NSLog(@"POsition is %f,%f", positionX,positionY);

    int row=roundf(positionX);
    int column=roundf(positionY);
    NSLog(@"%d,%d",row,column);
    int tagNo=row*20+column;
    if (_startField.tag!=tagNo) {
        _startField.backgroundColor = [UIColor clearColor];
        [_startField setBackgroundImage:nil forState:UIControlStateNormal];
    }
   
    _startField = (UIButton*)[self.indoorLocationView viewWithTag:tagNo];
    //_startField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow.png"]];
    [_startField setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];

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
            if ([[resultProduct valueForKey:@"sectionId"] intValue]==((OfferButton *)offer).tag-1000){
                NSLog(@"tag %lu  %d",((OfferButton *)offer).tag , [[resultProduct valueForKey:@"sectionId"] intValue]);
                [((OfferButton *)offer)setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal];
                //show the description ...
                self.labelView.hidden = NO;
                self.textLabel.text = [NSString stringWithFormat:@"The product %@ is available in the %@",[resultProduct valueForKey:@"productName"],[GlobalVariables returnTitleForSection:[[resultProduct valueForKey:@"sectionId"] intValue]]];
                isSearchEnabled = YES;
                [self actionField:(UIButton *)[self.indoorLocationView viewWithTag:((OfferButton *)offer).tagNo]];
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
        //searchBar.text= [[filtered objectAtIndex:0]valueForKey:@"productName"];
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
    
//    [self goPressed];
    
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
    [self clearPath:nil];
    [_startField setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    if(!isSearchEnabled){
        //check women's section ...
        if([_wommenSectionTagArray containsObject:[NSNumber numberWithInteger:sender.tag]])
            [self.globals showOfferPopUp:@"test" andMessage:@"test 123" onController:self withImage:[UIImage imageNamed:@"map-pin-green.png"]];
        
    }
    else{
        
    }
}

-(IBAction)clearPath:(id)sender{
    _targetField.backgroundColor = [UIColor clearColor];
    for (UIButton *b in _indoorLocationView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            if ([b.currentTitle isEqualToString:@"X"]) {
                b.backgroundColor = [UIColor clearColor];
            } else if (b.tag == 76) {
                b.backgroundColor = [UIColor clearColor];
            } else {
                if(b.tag < 1000){
                    if (_startField.tag!=b.tag) {
                        b.backgroundColor = [UIColor clearColor];
                        [b.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                    }
//                    [b.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                }
            }
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
    int row = tag/20;
    int col = tag-row*20;
    
    NSString *titleX = @"X";
    
    NSMutableArray *cons = [NSMutableArray array];
    if (col-1 > 0) {
        UIButton *but = (UIButton*)[self.view viewWithTag:(row*20+col-1)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (col+1 < [_plane[0] count]+1) {
        UIButton *but = (UIButton*)[self.view viewWithTag:(row*20+col+1)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (row-1 >= 0) {
        UIButton *but = (UIButton*)[self.view viewWithTag:((row-1)*20+col)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (row+1 < [_plane count]) {
        UIButton *but = (UIButton*)[self.view viewWithTag:((row+1)*20+col)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    
    return cons;
}

-(int)getTag:(ESTOrientedPoint *)beaconPosition{
    float positionX,positionY;
    positionX = ceilf(beaconPosition.y);
    positionY = ceilf(beaconPosition.x);
    
    positionX=positionX > 0 ?positionX-4:positionX-5;
    positionX=fabsf(positionX);
    positionY=positionY < 0 ?positionY+6:positionY+5;
    NSLog(@"POsition is %f,%f", positionX,positionY);
    
    int row=roundf(positionX);
    int column=roundf(positionY);
    int tagNo=row*20+column;
    return tagNo;

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
