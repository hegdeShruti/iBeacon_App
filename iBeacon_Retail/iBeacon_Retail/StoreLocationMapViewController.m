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
@property(nonatomic,strong)NSMutableArray *kidSectionTagArray;
@property(nonatomic,strong)NSMutableArray *menSectionTagArray;

@property(nonatomic,strong)IBOutlet UIImageView *productImage;

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
    //_productImage.image = [UIImage imageNamed:@"user.png"];
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
    UIButton *rtButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rtButton setImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
    [rtButton addTarget:self action:@selector(clearPath:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtButton];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    
    [super viewWillAppear:animated];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
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
//    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(-47, 0, 320, 320)];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(-47, 0, 410, 410)];
    [img setImage:[UIImage imageNamed:@"map.png"]];
    [self.indoorLocationView addSubview:img];
    
    
    [self.manager startIndoorLocation:self.location];
    
    _pathManager = [[AOShortestPath alloc] init];
    _pathManager.pointList = [NSMutableArray array];
     _wommenSectionTagArray = [NSMutableArray array];
    _kidSectionTagArray = [NSMutableArray array];
    _menSectionTagArray = [NSMutableArray array];
    // create visual structure of plane
    _plane = @[
               @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0], //1
               @[@0,@0,@1,@0,@1,@1,@1,@0,@1,@0], //2
               @[@0,@1,@0,@0,@0,@1,@0,@0,@1,@0], //3
               @[@0,@0,@0,@1,@1,@1,@1,@0,@0,@0], //4
               @[@0,@1,@0,@1,@0,@0,@1,@0,@1,@0], //5
               @[@0,@1,@1,@1,@0,@0,@1,@1,@1,@0], //6
               @[@0,@0,@0,@1,@1,@1,@1,@0,@0,@0], //7
               @[@0,@1,@0,@0,@1,@1,@1,@0,@0,@0], //8
               @[@0,@1,@1,@1,@1,@1,@1,@1,@1,@0], //9
               @[@0,@1,@1,@0,@0,@0,@0,@0,@0,@0]//14
               ];
    
    // set default field size
    // CGFloat size = 45/2;//self.indoorLocationView.frame.size.width/[_plane[0] count];
//    _frameWidthFactor = self.indoorLocationView.frame.size.width/[_plane[0] count];
//    _frameHeightFactor = self.indoorLocationView.frame.size.height/[_plane count];
    _frameWidthFactor = 410/[_plane[0] count];
    _frameHeightFactor = 410/[_plane count];
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
                [l setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//                l.titleLabel.textColor=[UIColor clearColor];
//                [l.titleLabel setTextColor:[UIColor greenColor]];
                l.backgroundColor = [UIColor clearColor];
            } else {
                l.backgroundColor = [UIColor clearColor];
            }

            [self.indoorLocationView addSubview:l];
            if((i>2&&i<7)&& j<3){
                [_wommenSectionTagArray addObject:[NSNumber numberWithInt:l.tag]];
                [l addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
            }
            if((i>2&&i<7)&& j>6){
                [_kidSectionTagArray addObject:[NSNumber numberWithInt:l.tag]];
                [l addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            if((j>2&&j<7)&& i<3){
                [_menSectionTagArray addObject:[NSNumber numberWithInt:l.tag]];
                [l addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
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
//            if (p.tag == 76) {
//                // its very hard to get on this field
//                c.weight = 10;
//            }
            c.point = [_pathManager getPathPointWithTag:b.tag];
            [p addConnection:c];
        }];
    }
    
}
- (void)showOffer:(id)sender{
    
    NSLog(@"offer  %@",self.globals.offersDataArray);
    
    SectionIdentifier section=[self getSectionID:((UIButton *)sender).tag];
    
    NSArray *resultOfferArray=[self.globals.offersDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %d", @"sectionId",section]];
    NSDictionary *resultOffer;
    if (resultOfferArray !=nil &&  [resultOfferArray count ]!=0)
        resultOffer=[resultOfferArray objectAtIndex:0 ];
    int offerID = [self getOfferbasedOnID:section];
    Products *prodObject=  [GlobalVariables getProductWithID:[[resultOffer valueForKey:@"productId" ] intValue]];
    Offers *offerObject= [GlobalVariables getOfferWithID:offerID];
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContext(CGSizeMake(mainFrame.size.width, mainFrame.size.height));
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (offerObject!=nil) {
        [self.globals showOfferPopUp:prodObject andMessage:offerObject.offerHeading onController:self withImage:image];
    }
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
        //        _startField.backgroundColor = [UIColor clearColor];
        [_startField setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    _startField = (UIButton*)[self.indoorLocationView viewWithTag:tagNo];
    //_startField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow.png"]];
    [_startField setBackgroundImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
    
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
    
    UIButton *but=(UIButton *)[self.indoorLocationView viewWithTag:[self getTagForSectionID:[[resultProduct valueForKey:@"sectionId"]intValue]]];
    [but setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal];
    //show the description ...
    self.labelView.hidden = NO;
    self.textLabel.text = [NSString stringWithFormat:@"The product %@ is available in the %@",[resultProduct valueForKey:@"productName"],[GlobalVariables returnTitleForSection:[[resultProduct valueForKey:@"sectionId"] intValue]]];
    self.productImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[resultProduct valueForKey:@"productName"]]];
    isSearchEnabled = YES;
    [self actionField:(UIButton *)[self.indoorLocationView viewWithTag:but.tag]];
    
    
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
    [_startField setBackgroundImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
    if(!isSearchEnabled){
        //check women's section ...
        if([_wommenSectionTagArray containsObject:[NSNumber numberWithInteger:sender.tag]])
            [self.globals showOfferPopUp:@"test" andMessage:@"test 123" onController:self withImage:[UIImage imageNamed:@"map-pin-green.png"]];
        
    }
    else{
       // [self clearPath:nil];
        [_startField setBackgroundImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
        
        if([sender.titleLabel.text isEqualToString:@"X"]){
            NSLog(@"Its a wall !!");
        }
        else if (!_search) {
         //   [self clearPath:nil];
            _search = YES;
            //        sender.backgroundColor = [UIColor greenColor];
            _targetField = sender;
            
            AOPathPoint *startPoint = [_pathManager getPathPointWithTag:_startField.tag];
            AOPathPoint *endPoint = [_pathManager getPathPointWithTag:_targetField.tag];
            NSArray *path = [_pathManager getShortestPathFromPoint:startPoint toPoint:endPoint];
            if (path.count) {
                NSMutableArray *buttonPath = [NSMutableArray array];
                self.pathArray=[NSMutableArray array];
                for (AOPathPoint *p in path) {
                    UIButton *but = (UIButton*)[self.view viewWithTag:p.tag];
                    if(![but.currentTitle isEqualToString:@"X"] ){
                        float w=p.tag%20*41-16-47;
                        float h=p.tag/20*41+16;
                        
                        [self.pathArray addObject:[NSValue valueWithCGPoint:CGPointMake(w, h)]];
                        NSLog(@"tag  %ld  point %@   %@",p.tag,[NSValue valueWithCGPoint:CGPointMake(w, h)],but.currentTitle);
                    }
                }
                
                [_pathGeneratorView setPathList:_pathArray];
                
                [self animate:buttonPath withCompletion:^{
                    _search = NO;
                    //               _startField = _targetField;
                    //                _startField.backgroundColor = [UIColor greenColor];
                    [_startField setBackgroundImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
                    
                }];
            } else {
                _search = NO;
            }
        }
    }
}

-(IBAction)clearPath:(id)sender{
    //    _targetField.backgroundColor = [UIColor clearColor];
    [_searchBar resignFirstResponder];
    
    for (UIButton *b in _indoorLocationView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            if ([b.currentTitle isEqualToString:@"X"]) {
                b.backgroundColor = [UIColor clearColor];
            }
            else {
                if(b.tag < 1000){
                if (_startField.tag!=b.tag) {
                b.backgroundColor = [UIColor clearColor];
                [b.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                    }
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
-(int)getTagForSectionID:(int)sectionId{
    int tag=0 ;
    switch (sectionId) {
        case 3:
            tag = 108;
            break;
        case 1:
            tag = 25;
            break;
        case 2:
            tag = 102;
            break;
        default:
            break;
    }
    return tag;
}

-(int)getSectionID:(int)tag{
    int section=0;
    if([_wommenSectionTagArray containsObject:[NSNumber numberWithInt:tag]]){
        section=2;
    }
    if([_menSectionTagArray containsObject:[NSNumber numberWithInt:tag]]){
        section=1;
    }
    if([_kidSectionTagArray containsObject:[NSNumber numberWithInt:tag]]){
        section=3;
    }
    return section;
}

-(int)getOfferbasedOnID:(int)section{
    int offerID=0 ;
    switch (section) {
        case 3:
            offerID = 2;
            break;
        case 1:
            offerID = 3;
            break;
        case 2:
            offerID = 6;
            break;
        default:
            break;
    }
    return offerID;
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
