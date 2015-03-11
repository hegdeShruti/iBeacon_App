//
//  BeaconMonitoringModel.m
//  iBeacon_Retail
//
//  Created by shruthi on 10/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "BeaconMonitoringModel.h"

#import "ESTConfig.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "OffersViewController.h"
#import "ContainerViewController.h"
#import "BeaconMonitoringModel.h"


@interface BeaconMonitoringModel ()<ESTBeaconManagerDelegate>
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) ESTBeaconRegion *regionSectionSpec;
@property(nonatomic,strong)ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *regionMenSection;
@property (nonatomic, strong) ESTBeaconRegion *regionWomenSection;
@property (nonatomic, assign) RegionIdentifier beaconRegion;

@end


@implementation BeaconMonitoringModel


- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)startBeaconOperations{
    [ESTConfig setupAppID:nil andAppToken:nil];
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // read config values from plist and assign it to parameters
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSUUID *beaconId=[[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"UUID"]];
    CLBeaconMajorValue majorValue=[[dict objectForKey:@"EntryBeacon_Major"] intValue];
    CLBeaconMinorValue minorValue=[[dict objectForKey:@"EntryBeacon_Minor"] intValue];
    
    // create a region for entry beacon
    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                           major:majorValue minor:minorValue identifier:@"ENTRYBEACON"
                                                         secured:NO];
    self.regionMenSection = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                                     major:[[dict objectForKey:@"MenSectionBeacon_Major"] intValue] minor:[[dict objectForKey:@"MenSectionBeacon_Minor"] intValue] identifier:@"MENSECTIONBEACON"
                                                                   secured:NO];
    self.regionWomenSection = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                                     major:[[dict objectForKey:@"WomenSectionBeacon_Major"] intValue] minor:[[dict objectForKey:@"WomenSectionBeacon_Minor"] intValue] identifier:@"WOMENSECTIONBEACON"
                                                                   secured:NO];
    
    //settings for monitoring a region
    self.region.notifyOnEntry = YES;
    self.region.notifyOnExit = YES;
    self.regionMenSection.notifyOnEntry=YES;
    self.regionWomenSection.notifyOnEntry=YES;
    [self.beaconManager requestAlwaysAuthorization];
    [self.beaconManager startMonitoringForRegion:  self.region];
    [self.beaconManager startMonitoringForRegion:  self.regionMenSection];
    [self.beaconManager startMonitoringForRegion:  self.regionWomenSection];
}

#pragma beaconmanager Delegate method
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    NSLog(@"recieved region is %@",region.identifier);
    self.beaconRegion=(RegionIdentifier )region.identifier;
     NSLog(@"recieved region is %d",self.beaconRegion);
    UILocalNotification *notification = [UILocalNotification new];
    
    if([region.identifier isEqualToString:@"ENTRYBEACON"]){
        notification.alertBody = @"Welcome to Tavant Store..Check for offers here";
      
    }
    else if([region.identifier isEqualToString:@"MENSECTIONBEACON"]){
         notification.alertBody = @"Visit Men section to avail the exiting offers.";
    }
    else if([region.identifier isEqualToString:@"WOMENSECTIONBEACON"]){
        notification.alertBody = @"Visit Women section to avail the exiting offers.";
    }
    else{
        
    }
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
     UILocalNotification *notification = [UILocalNotification new];
    if([region.identifier isEqualToString:@"ENTRYBEACON"]){
       notification.alertBody = @"Thank you for visiting Us";
         [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
   
    
    
    
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

@end


