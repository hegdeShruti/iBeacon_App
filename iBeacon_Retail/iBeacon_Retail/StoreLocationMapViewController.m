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

@interface StoreLocationMapViewController () <ESTIndoorLocationManagerDelegate>

@property (nonatomic, strong) ESTIndoorLocationManager *manager;
@property (nonatomic, strong) ESTLocation *location;

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
    
    self.indoorLocationView.backgroundColor = [UIColor clearColor];
    
    self.indoorLocationView.showTrace               = self.showTraceSwitch.isOn;
    self.indoorLocationView.rotateOnPositionUpdate  = self.rotateOnUpdateSwitch.isOn;
    
    self.indoorLocationView.showWallLengthLabels    = YES;
    
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
    
    
    for(ESTPositionedBeacon *beacon in self.indoorLocationView.location.beacons){
        NSLog(@"mac Address is %@",beacon.description);
        if([beacon.macAddress isEqualToString:MENSECTION_MAC]){
            //Men's Section ...
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(beacon.position.x, beacon.position.y, 50, 50)];
            imageView.image = [UIImage imageNamed:@"Test_men'sSection.png"];
            [self.indoorLocationView addSubview:imageView];
        }
        else if([beacon.macAddress isEqualToString:WOMENSECTION_MAC]){
            //Women's Section ...
            
        }
        else if([beacon.macAddress isEqualToString:KIDSSECTION_MAC]){
            //Kid's Section ...
            
        }
        else{
            //Electronic Section...
            
        }
    }
    
    [self.manager startIndoorLocation:self.location];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.manager stopIndoorLocation];
    [super viewWillDisappear:animated];
}

#pragma mark - UISwitch events

- (IBAction)showTraceSwitchChanged:(id)sender
{
    [self.indoorLocationView clearTrace];
    self.indoorLocationView.showTrace = self.showTraceSwitch.isOn;
}

- (IBAction)rotateOnUpdateSwitchChanged:(id)sender
{
    self.indoorLocationView.rotateOnPositionUpdate = self.rotateOnUpdateSwitch.isOn;
}

//-(void)showAlertForSection:

#pragma mark - ESTIndoorLocationManager delegate

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager
            didUpdatePosition:(ESTOrientedPoint *)position
                   inLocation:(ESTLocation *)location
{
    self.positionLabel.text = [NSString stringWithFormat:@"x: %.2f  y: %.2f   α: %.2f",
                               position.x,
                               position.y,
                               position.orientation];
    
    [self.indoorLocationView updatePosition:position];
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager didFailToUpdatePositionWithError:(NSError *)error
{
    self.positionLabel.text = @"It seems you are outside the location.";
//    NSLog(@"%@", error.localizedDescription);
}

@end
