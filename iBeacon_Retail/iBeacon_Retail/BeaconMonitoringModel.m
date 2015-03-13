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
#import "GlobalVariables.h"


@interface BeaconMonitoringModel ()<ESTBeaconManagerDelegate>
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) ESTBeaconRegion *regionSectionSpec;
@property(nonatomic,strong)ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *regionMenSection;
@property (nonatomic, strong) ESTBeaconRegion *regionWomenSection;
@property (nonatomic, assign) RegionIdentifier beaconRegion;
@property (nonatomic, strong) ESTBeaconRegion *mainEntraneRegion;
@property(nonatomic,strong) GlobalVariables *globals;
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
    self.globals=[GlobalVariables getInstance];
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
    self.mainEntraneRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                                       major:[[dict objectForKey:@"MainEntranceBeacon_Major"] intValue] minor:[[dict objectForKey:@"MainEntranceBeacon_Minor"] intValue] identifier:@"MAINENTRANCEBEACON"
                                                                     secured:NO];
//    self.mainEntraneRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
//                                                                      major:37372  minor:20643 identifier:@"MAINENTRANCEBEACON"
//                                                                    secured:NO];
   NSLog(@"main region is %@  Minor %@",self.mainEntraneRegion.major,self.mainEntraneRegion.minor);
    
    //settings for monitoring a region
    self.region.notifyOnEntry = YES;
    self.region.notifyOnExit = YES;
    self.regionMenSection.notifyOnEntry=YES;
    self.regionWomenSection.notifyOnEntry=YES;
    self.mainEntraneRegion.notifyOnEntry=YES;
    self.mainEntraneRegion.notifyOnExit=YES;
    [self.beaconManager requestAlwaysAuthorization];
    [self.beaconManager startMonitoringForRegion:  self.mainEntraneRegion];
    [self.beaconManager startMonitoringForRegion:  self.region];
    [self.beaconManager startMonitoringForRegion:  self.regionMenSection];
    [self.beaconManager startMonitoringForRegion:  self.regionWomenSection];
   
}

#pragma beaconmanager Delegate method
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
   
    NSLog(@"recieved region is %@",region.identifier);
   
    UILocalNotification *notification = [UILocalNotification new];
    // if user is near outside beacon and he has already visted shop not that event as exit and clear all flags
    if([region.identifier isEqualToString:@"MAINENTRANCEBEACON"]) {
        self.globals.hasUsercrossedEntrance=YES;
        if(self.globals.hasUserEnteredTheStore){
            notification.alertBody = @"Thank you for visiting Us";
            self.globals.hasUserEnteredTheStore=NO;
            self.globals.hasUserGotMenSectionOffers=NO;
            self.globals.hasUserGotWOmenSectionOffers=NO;
            self.globals.hasUserEntredEntryBeacon=NO;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location"
//                                                        message:@"Yor r @ main entrance."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        
//        [alert show];
        
    }
   else  if([region.identifier isEqualToString:@"ENTRYBEACON" ] && !self.globals.hasUserEnteredTheStore && self.globals.hasUsercrossedEntrance){
        notification.alertBody = @"Welcome to Tavant Store..Check for offers here";
        self.globals.hasUserEnteredTheStore=YES;
        self.globals.hasUserEntredEntryBeacon=YES;
    }
    else if([region.identifier isEqualToString:@"MENSECTIONBEACON"]&& !self.globals.hasUserGotMenSectionOffers ){
         notification.alertBody = @"Visit Men section to avail the exiting offers.";
        self.globals.hasUserGotMenSectionOffers=YES;
    }
    else if([region.identifier isEqualToString:@"WOMENSECTIONBEACON"]&& !self.globals.hasUserGotWOmenSectionOffers ){
        notification.alertBody = @"Visit Women section to avail the exiting offers.";
        self.globals.hasUserGotWOmenSectionOffers=YES;
    }
    else{
        
    }
  
    if(notification.alertBody){
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
     UILocalNotification *notification = [UILocalNotification new];
    if([region.identifier isEqualToString:@"ENTRYBEACON"] && self.globals.hasUserEnteredTheStore){
//       notification.alertBody = @"Thank you for visiting Us";
//        self.globals.hasUserEnteredTheStore=NO;
//        self.globals.hasUserGotMenSectionOffers=NO;
//        self.globals.hasUserGotWOmenSectionOffers=NO;
//         self.globals.hasUserEntredEntryBeacon=NO;
//         [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
//     if([region.identifier isEqualToString:@"MAINENTRANCEBEACON"] && self.globals.hasUserEnteredTheStore){
//        notification.alertBody = @"Thank you for visiting Us";
//        self.globals.hasUserEnteredTheStore=NO;
//         self.globals.hasUsercrossedEntrance=NO;
//        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//    }
    
   
    
    
    
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


