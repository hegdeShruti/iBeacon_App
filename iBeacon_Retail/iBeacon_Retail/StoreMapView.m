//
//  StoreMapView.m
//  iBeacon_Retail
//
//  Created by SHALINI on 4/24/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "StoreMapView.h"
#import "AOShortestPath.h"
#import "GlobalVariables.h"
#import "UIImageView+WebCache.h"

@interface StoreMapView ()<ESTIndoorLocationManagerDelegate>
@property(nonatomic,retain)UIImageView *personView;
@property (nonatomic, strong) ESTIndoorLocationManager *manager;
@property (strong, nonatomic) AOShortestPath *pathManager;
@property (strong, nonatomic) NSArray *plane;
@property(nonatomic,strong)NSMutableArray *wommenSectionTagArray;
@property(nonatomic,strong)NSMutableArray *kidSectionTagArray;
@property(nonatomic,strong)NSMutableArray *menSectionTagArray;
@property (assign, nonatomic) CGFloat frameWidthFactor;
@property (assign, nonatomic) CGFloat frameHeightFactor;
@property (strong, nonatomic) UIButton *startField;
@property (strong, nonatomic) UIButton *targetField;
@property (assign, nonatomic) BOOL search;
@property(nonatomic,strong) GlobalVariables *globals;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property(nonatomic,retain)StoreLocationMapViewController *parent;
@property (assign, nonatomic)BOOL isSearchEnabled;

@end

@implementation StoreMapView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    }
-(void)setupLocation:(ESTLocation *)location product:(Products *)product withParentController:(id)parent{
    self.backgroundColor = [UIColor clearColor];
    self.rotateOnPositionUpdate=NO;
    self.backgroundColor = [UIColor clearColor];
    self.rotateOnPositionUpdate=NO;
    self.showWallLengthLabels    = NO;
    self.locationBorderColor     = [UIColor blackColor];
    self.locationBorderThickness = 4;
    self.doorColor               = [UIColor clearColor];
    self.doorThickness           = 6;
    self.traceColor              = [UIColor clearColor];
    self.traceThickness          = 2;
    self.wallLengthLabelsColor   = [UIColor clearColor];

    // You can change the avatar using positionImage property of ESTIndoorLocationView class.
//    self.positionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [self.positionView setBackgroundColor:[UIColor clearColor]];
    self.personView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person.png"]];

    //Adding store layout
    self.parent=parent;
    self.product=product;
    self.frameWidth=self.parent.view.frame.size.width>400?410:320;
    self.frameHeight=self.frameWidth;
    [self setFrame:CGRectMake(0, 164, _frameWidth,_frameHeight)];
    [self drawLocation:location];

    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frameWidth,self.frameHeight)];
   [img setImage:[UIImage imageNamed:@"map.png"]];
    [self addSubview:img];
//    [self.manager startIndoorLocation:self.location];
    self.manager = [[ESTIndoorLocationManager alloc] init];
    self.manager.delegate = self;
    self.globals=[GlobalVariables getInstance];
    self.pathGeneratorView=[[MapPathGenerator alloc]initWithFrame:CGRectMake(0, 0, self.frameWidth,self.frameHeight)];
    [self.pathGeneratorView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.pathGeneratorView];
    [self setupMetricx];
    _isSearchEnabled = NO;


}
-(void)startLocation{
    [self.manager startIndoorLocation:self.location];
}
-(void)stopLocation{
  [self.manager stopIndoorLocation];
}
-(void)updateUserPosition:(ESTOrientedPoint *)position{
    if (position !=nil) {
//        [super updatePosition:position];
        
        [super drawObject:_personView withPosition:position];
        int tagNo=[self getTag:position];
        if (_startField.tag!=tagNo) {
            [_startField setBackgroundImage:nil forState:UIControlStateNormal];
        }
        _startField = (UIButton*)[self viewWithTag:tagNo];
//        [_personView setFrame:CGRectMake(w, h, 20, 20)];
//        [self.pathGeneratorView.layer addSublayer:_personView.layer];
//        [_startField setBackgroundImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        if(_product!=nil && _isSearchEnabled != YES)
            [self locateProduct:_product];

    }
}
-(void)locateProduct:(Products *)product{
        if (product!=nil ) {
            NSArray *tempArray = [self.globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"productName",product.prodName]];
            if([tempArray count] > 0){
                NSDictionary *resultProduct=[tempArray objectAtIndex:0];
                Products *product = [(Products *)[Products alloc] initWithDictionary:resultProduct];
                UIButton *but=(UIButton *)[self viewWithTag:[self getTagForSectionID:[[resultProduct valueForKey:@"sectionId"]intValue]]];
                //    [but setBackgroundImage:[UIImage imageNamed:@"map-pin-green.png"] forState: UIControlStateNormal];
                //show the description ...
                _parent.labelView.hidden = NO;
                _parent.textLabel.text = [NSString stringWithFormat:@"The product %@ is available in the %@",product.prodName,[GlobalVariables returnTitleForSection:[[resultProduct valueForKey:@"sectionId"] intValue]]];
                [_parent.productImage sd_setImageWithURL:[NSURL URLWithString:[product.prodImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ] placeholderImage:[UIImage imageNamed:@"1.png"]];
                // self.productImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[resultProduct valueForKey:@"productName"]]];
                _isSearchEnabled = YES;
                [self clearPath];
                [self actionField:(UIButton *)[self viewWithTag:but.tag]];
                
            }
        }
        
    
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

-(void)setupMetricx{
    _pathManager = [[AOShortestPath alloc] init];
    _pathManager.pointList = [NSMutableArray array];
    _wommenSectionTagArray = [NSMutableArray array];
    _kidSectionTagArray = [NSMutableArray array];
    _menSectionTagArray = [NSMutableArray array];
    // create visual structure of plane
    _plane = @[
               @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0], //1
               @[@0,@0,@1,@0,@1,@1,@1,@0,@1,@0], //2
               @[@0,@1,@1,@1,@0,@1,@0,@1,@1,@0], //3
               @[@0,@0,@0,@1,@1,@1,@1,@1,@0,@0], //4
               @[@0,@1,@0,@1,@0,@0,@1,@0,@1,@0], //5
               @[@0,@1,@1,@1,@0,@0,@1,@1,@1,@0], //6
               @[@0,@0,@0,@1,@1,@1,@1,@0,@0,@0], //7
               @[@0,@1,@0,@0,@1,@1,@1,@0,@0,@0], //8
               @[@0,@1,@1,@1,@1,@1,@1,@1,@1,@0], //9
               @[@0,@1,@1,@0,@0,@0,@0,@0,@0,@0]//14
               ];
    
    // set default field size
    
    _frameWidthFactor = self.frameWidth/[_plane[0] count];
    _frameHeightFactor = self.frameHeight/[_plane count];
    // generate plans's fields
    for (int i = 0; i<_plane.count; i++) {
        NSArray *row = _plane[i];
        for (int j=0; j<row.count; j++) {
            UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(j*_frameWidthFactor, i*_frameHeightFactor, _frameWidthFactor, _frameHeightFactor)];
            l.tag = i*20 + j + 1;
            l.backgroundColor = [UIColor clearColor];
            l.layer.borderColor = [UIColor clearColor].CGColor;
            l.layer.borderWidth = 0;
            NSNumber *num = _plane[i][j];
            if ([num integerValue] == 0) {
                [l setTitle:@"X" forState:UIControlStateNormal];
                [l setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                l.backgroundColor = [UIColor clearColor];
            } else {
                l.backgroundColor = [UIColor clearColor];
            }
            
            [self addSubview:l];
            if((i>2&&i<7)&& j<3){
                [_wommenSectionTagArray addObject:[NSNumber numberWithInteger:l.tag]];
                [l addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
            }
            if((i>2&&i<7)&& j>6){
                [_kidSectionTagArray addObject:[NSNumber numberWithInteger:l.tag]];
                [l addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            if((j>2&&j<7)&& i<3){
                [_menSectionTagArray addObject:[NSNumber numberWithInteger:l.tag]];
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
            c.point = [_pathManager getPathPointWithTag:b.tag];
            [p addConnection:c];
        }];
    }
    

}
- (void)actionField:(UIButton*)sender {
    //    [_startField setBackgroundImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
    _isSearchEnabled = YES;

    if([sender.titleLabel.text isEqualToString:@"X"]){
        NSLog(@"Its a wall !!");
    }
    else if (!_search) {
        _search = YES;
        _targetField = sender;
        
        AOPathPoint *startPoint = [_pathManager getPathPointWithTag:_startField.tag];
        AOPathPoint *endPoint = [_pathManager getPathPointWithTag:_targetField.tag];
        NSArray *path = [_pathManager getShortestPathFromPoint:startPoint toPoint:endPoint];
        if (path.count) {
            NSMutableArray *buttonPath = [NSMutableArray array];
            self.pathArray=[NSMutableArray array];
            for (AOPathPoint *p in path) {
                UIButton *but = (UIButton*)[self viewWithTag:p.tag];
                if(![but.currentTitle isEqualToString:@"X"] ){
                    float w=p.tag%20*_frameWidthFactor-16;
                    float h=p.tag/20*_frameWidthFactor+16;
                    
                    [self.pathArray addObject:[NSValue valueWithCGPoint:CGPointMake(w, h)]];
                    NSLog(@"tag  %ld  point %@   %@",p.tag,[NSValue valueWithCGPoint:CGPointMake(w, h)],but.currentTitle);
                }
            }
            
            [_pathGeneratorView setPathList:_pathArray];
            _pathGeneratorView.hidden=NO;
            _search = NO;
            
        } else {
            _search = NO;
        }
    }
}

// we need this method to easily generate connections for basic 2d game plane
- (NSArray*)getConnectionListForTag:(long)tag {
    int row = (int)tag/20;
    int col = (int)tag-row*20;
    
    NSString *titleX = @"X";
    
    NSMutableArray *cons = [NSMutableArray array];
    if (col-1 > 0) {
        UIButton *but = (UIButton*)[self viewWithTag:(row*20+col-1)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (col+1 < [_plane[0] count]+1) {
        UIButton *but = (UIButton*)[self viewWithTag:(row*20+col+1)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (row-1 >= 0) {
        UIButton *but = (UIButton*)[self viewWithTag:((row-1)*20+col)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    if (row+1 < [_plane count]) {
        UIButton *but = (UIButton*)[self viewWithTag:((row+1)*20+col)];
        if (![but.currentTitle isEqualToString:titleX]) {
            [cons addObject:but];
        }
    }
    
    return cons;
}

-(int)getTag:(ESTOrientedPoint *)beaconPosition{
    float positionX,positionY;
//    positionX = ceilf(beaconPosition.y);
//    positionY = ceilf(beaconPosition.x);
//    
//    positionX=positionX > 0 ?positionX-4:positionX-5;
//    positionX=fabsf(positionX);
//    positionY=positionY < 0 ?positionY+6:positionY+5;
//    //NSLog(@"POsition is %f,%f", positionX,positionY);
//    
//    int row=roundf(positionX);
//    int column=roundf(positionY);
    NSLog(@"POsition is %f,%f", beaconPosition.x,beaconPosition.y);
    positionX = roundf(beaconPosition.y);
    positionY = roundf(beaconPosition.x);
    positionX=positionX-5;
    positionX=fabsf(positionX);
    positionY=positionY+5;
    NSLog(@"row column is %f,%f", positionX,positionY);
    
    int row=roundf(positionX);
    int column=roundf(positionY);
    int tagNo=row*20+column;
    return tagNo;
    
}
- (void)showOffer:(id)sender{
    
    NSLog(@"offer  %@",self.globals.offersDataArray);
    
    int section=[self getSectionID:(int)((UIButton *)sender).tag];
    NSArray *resultOfferArray=[self.globals.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %d", @"sectionId",section]];
    NSDictionary *resultOffer;
    if (resultOfferArray !=nil &&  [resultOfferArray count ]!=0)
        resultOffer=[resultOfferArray objectAtIndex:0 ];
    if (resultOffer!=nil) {
        int offerID = [[resultOffer valueForKey:@"offerid"] intValue];//[self getOfferbasedOnID:section];
        Products *prodObject=  [GlobalVariables getProductWithID:offerID];
        Offers *offerObject= [GlobalVariables getOfferWithID:offerID];
        // CGRect mainFrame = [UIScreen mainScreen].bounds;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIGraphicsBeginImageContext(window.bounds.size);
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height) afterScreenUpdates:YES];
        //  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //  UIGraphicsEndImageContext();
        if (prodObject!=nil) {
            [self.globals showOfferPopUp:prodObject andMessage:offerObject.offerHeading onController:self.parent withImage:image];
        }
    }
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

- (void)clearPath{
    _pathGeneratorView.hidden=YES;
for (UIButton *b in self.subviews) {
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
#pragma mark - ESTIndoorLocationManager delegate

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager
            didUpdatePosition:(ESTOrientedPoint *)position
                   inLocation:(ESTLocation *)location
{
    [self updateUserPosition:position];
    
//    [self locateProduct];
    
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didFailToUpdatePositionWithError:(NSError *)error
{
    NSLog(@"didFailToUpdatePositionWithError is %@", [error debugDescription]);

}

@end