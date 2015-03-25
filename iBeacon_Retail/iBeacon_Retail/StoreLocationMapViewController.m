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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.globals.isUserOnTheMapScreen = YES;
    
    self.indoorLocationView.backgroundColor = [UIColor clearColor];
    
    self.indoorLocationView.rotateOnPositionUpdate=NO;
    
    self.indoorLocationView.showWallLengthLabels    = NO;
    
    // self.indoorLocationView.frame = CGRectMake(self.indoorLocationView.frame.origin.x, self.indoorLocationView.frame.origin.y, 350, 350);
    
    self.indoorLocationView.locationBorderColor     = [UIColor blackColor];
    self.indoorLocationView.locationBorderThickness = 4;
    self.indoorLocationView.doorColor               = [UIColor brownColor];
    self.indoorLocationView.doorThickness           = 6;
    self.indoorLocationView.traceColor              = [UIColor blueColor];
    self.indoorLocationView.traceThickness          = 2;
    self.indoorLocationView.wallLengthLabelsColor   = [UIColor blackColor];
    
    [self.indoorLocationView drawLocation:self.location];
    
    // You can change the avatar using positionImage property of ESTIndoorLocationView class.
    // self.indoorLocationView.positionImage = [UIImage imageNamed:@"name_of_your_image"];
    
    
    for(ESTPositionedBeacon *beacon in self.location.beacons){
        if([beacon.macAddress isEqualToString:MENSECTION_MAC]){
            //Men's Section ...
            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
            sectionLogo.secTitle=@"Men's Section ";
            sectionLogo.offerMsg=@"You have 50% off on selected items";
            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"Test_MenSection.png"] forState: UIControlStateNormal] ;
            [sectionLogo addTarget:self action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
        }
        
        else if([beacon.macAddress isEqualToString:WOMENSECTION_MAC]){
            //Women's Section ...
            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
            sectionLogo.secTitle=@"Women's Section ";
            sectionLogo.offerMsg=@"You have 50% off on selected items";
            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"Test_Women'sSection.png"] forState: UIControlStateNormal] ;
            [sectionLogo addTarget:nil action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
            
        }
        else if([beacon.macAddress isEqualToString:KIDSSECTION_MAC]){
            //Kid's Section ...
            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
            sectionLogo.secTitle=@"Kid's Section ";
            sectionLogo.offerMsg=@"You have 50% off on selected items";
            [sectionLogo setBackgroundImage:[UIImage imageNamed:@"Test_Kid'sSection.png"] forState: UIControlStateNormal] ;
            [sectionLogo addTarget:nil action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
        }
        else{
            //Electronic Section...
            OfferButton *sectionLogo = [[OfferButton alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
            sectionLogo.secTitle=@"";
            sectionLogo.offerMsg=@"Welcome to Our Store";
            //[sectionLogo setBackgroundImage:[UIImage imageNamed:@"Test_men'sSection.png"] forState: UIControlStateNormal] ;
            [sectionLogo addTarget:nil action:@selector(showOffer:) forControlEvents:UIControlEventTouchUpInside];
            [self.indoorLocationView drawObject:sectionLogo withPosition:[ESTPoint pointWithX:beacon.position.x y:beacon.position.y]];
            
        }
    }
    
    [self.manager startIndoorLocation:self.location];
}
- (void)showOffer:(id)sender{
    //(NSString *)offerMessage inSection:(NSString *)section
            OfferPopupMenu *popup = [[OfferPopupMenu alloc]initWithTitle:((OfferButton *)sender).secTitle message:((OfferButton *)sender).offerMsg];
    popup.menuStyle = MenuStyleOval;
    [self.globals showOfferPopUpWithTitle:((OfferButton *)sender).secTitle andMessage:((OfferButton *)sender).offerMsg ];
    
    
    //
    //    [popup showMenuInParentViewController:self withCenter:self.indoorLocationView.center];
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
    //    self.positionLabel.text = [NSString stringWithFormat:@"x: %.2f  y: %.2f   α: %.2f",
    //                               position.x,
    //                               position.y,
    //                               position.orientation];
    
    [self.indoorLocationView updatePosition:position];
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didFailToUpdatePositionWithError:(NSError *)error
{
    //    self.positionLabel.text = @"It seems you are outside the location.";
    //    NSLog(@"%@", error.localizedDescription);
}

@end
