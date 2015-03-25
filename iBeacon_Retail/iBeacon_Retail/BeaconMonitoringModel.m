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
@property (nonatomic, strong) ESTBeaconRegion *regionKidsSection;
@property (nonatomic, assign) RegionIdentifier beaconRegion;
@property (nonatomic, strong) ESTBeaconRegion *mainEntraneRegion;
@property(nonatomic,strong) GlobalVariables *globals;
@property(nonatomic,strong)NSDictionary *dict;
@end


BOOL isMenOfferShown = NO;
BOOL isWomenOfferShown = NO;
BOOL isKidsOfferShown = NO;

@implementation BeaconMonitoringModel
@synthesize dict;

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
    dict = [[NSDictionary alloc] initWithContentsOfFile:path];
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
    self.regionKidsSection = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconId
                                                                     major:[[dict objectForKey:@"KidSectionBeacon_Major"] intValue] minor:[[dict objectForKey:@"KidSectionBeacon_Minor"] intValue] identifier:@"KIDSECTIONBEACON"
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
    self.regionKidsSection.notifyOnEntry=YES;
    [self.beaconManager requestAlwaysAuthorization];
    [self.beaconManager startMonitoringForRegion:  self.mainEntraneRegion];
    [self.beaconManager startMonitoringForRegion:  self.region];
    [self.beaconManager startMonitoringForRegion:  self.regionMenSection];
    [self.beaconManager startMonitoringForRegion:  self.regionWomenSection];
    [self.beaconManager startMonitoringForRegion:  self.regionKidsSection];
    
    [self.beaconManager startRangingBeaconsInRegion:  self.mainEntraneRegion];
    [self.beaconManager startRangingBeaconsInRegion:  self.region];
    [self.beaconManager startRangingBeaconsInRegion:  self.regionMenSection];
    [self.beaconManager startRangingBeaconsInRegion:  self.regionWomenSection];
    [self.beaconManager startRangingBeaconsInRegion:  self.regionKidsSection];
   
}

#pragma beaconmanager Delegate method
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
   
    @synchronized(self) {
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
                self.globals.hasUserGotKidSectionOffers=NO;
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
            NSDictionary *userInformation=[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"offerId", nil];
            notification.userInfo=userInformation;
            self.globals.hasUserEnteredTheStore=YES;
            self.globals.hasUserEntredEntryBeacon=YES;
        }
        else if([region.identifier isEqualToString:@"MENSECTIONBEACON"]&& !self.globals.hasUserGotMenSectionOffers &&  self.globals.hasUserEntredEntryBeacon ){
            notification.alertBody = @"Visit Men section to avail the exiting offers.";
            NSDictionary *userInformation=[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"offerId", nil];
            notification.userInfo=userInformation;
            self.globals.hasUserGotMenSectionOffers=YES;
            
            
        }
        else if([region.identifier isEqualToString:@"WOMENSECTIONBEACON"]&& !self.globals.hasUserGotWOmenSectionOffers && self.globals.hasUserEntredEntryBeacon){
            notification.alertBody = @"Visit Women section to avail the exiting offers.";
            NSDictionary *userInformation=[[NSDictionary alloc] initWithObjectsAndKeys:@"3",@"offerId", nil];
            notification.userInfo=userInformation;
            self.globals.hasUserGotWOmenSectionOffers=YES;
        }
        else if([region.identifier isEqualToString:@"KIDSECTIONBEACON"]&& !self.globals.hasUserGotKidSectionOffers && self.globals.hasUserEntredEntryBeacon){
            notification.alertBody = @"Visit Kids section to avail the exiting offers.";
            NSDictionary *userInformation=[[NSDictionary alloc] initWithObjectsAndKeys:@"4",@"offerId", nil];
            notification.userInfo=userInformation;
            self.globals.hasUserGotKidSectionOffers=YES;
        }
        
        else{
            notification.alertBody=nil;
        }
        if(notification.alertBody){
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }

    }
    NSLog(@"recieved region is %@",region.identifier);
    
   
  
   }

- (void)beaconManager:(ESTBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(ESTBeaconRegion *)region{
    for(ESTBeacon *beaconObj in beacons){
        
        if(([beaconObj.major isEqualToNumber:[dict objectForKey:@"MenSectionBeacon_Major"]])){
            if(beaconObj.proximity == CLProximityFar || beaconObj.proximity == CLProximityUnknown){
                isMenOfferShown = NO;
            }
            else if(((beaconObj.proximity==CLProximityImmediate)||(beaconObj.proximity==CLProximityNear)) && !isMenOfferShown){
                isMenOfferShown = YES;
                self.beaconRegion = MENSECTIONBEACON;
                [self showPopUpForOffer];
            }
        }
        else if(([beaconObj.major isEqualToNumber:[dict objectForKey:@"WomenSectionBeacon_Major"]])){
            if(beaconObj.proximity == CLProximityFar || beaconObj.proximity == CLProximityUnknown){
                isWomenOfferShown = NO;
            }
            else if(((beaconObj.proximity==CLProximityImmediate)||(beaconObj.proximity==CLProximityNear)) && !isWomenOfferShown){
                isWomenOfferShown = YES;
                self.beaconRegion = WOMENSECTIONBEACON;
                [self showPopUpForOffer];
            }
        }
        else if(([beaconObj.major isEqualToNumber:[dict objectForKey:@"KidSectionBeacon_Major"]])){
            if(beaconObj.proximity == CLProximityFar || beaconObj.proximity == CLProximityUnknown){
                isKidsOfferShown = NO;
            }
            else if(((beaconObj.proximity==CLProximityImmediate)||(beaconObj.proximity==CLProximityNear)) && !isKidsOfferShown){
                isKidsOfferShown = YES;
                self.beaconRegion = KIDSECTIONBEACON;
                [self showPopUpForOffer];
            }
        }
        else{
            
        }
        
    }
    
}

-(void)showPopUpForOffer{
    if(self.globals.isUserOnTheMapScreen){
        [self.globals showOfferPopUpWithTitle:[GlobalVariables returnTitleForRegion:self.beaconRegion] andMessage:@"You have 50% off on selected items"];
        ;
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


