//
//  AppDelegate.m
//  iBeacon_Retail
//
//  Created by ShrutiHegde on 2/27/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "AppDelegate.h"
#import "ESTConfig.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "OffersViewController.h"
#import "ContainerViewController.h"
#define ESTIMOTE_PROXIMITY_UUID             [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

@interface AppDelegate ()<ESTBeaconManagerDelegate>
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) ESTBeaconRegion *regionSectionSpec;
@property(nonatomic,strong)ESTBeaconManager *beaconManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
                                                           major:majorValue minor:minorValue identifier:@"RegionIdentifier"
                                                         secured:NO];
   
    //settings for monitoring a region
    self.region.notifyOnEntry = YES;
    self.region.notifyOnExit = YES;
    
    [self.beaconManager requestAlwaysAuthorization];
    [self.beaconManager startMonitoringForRegion:  self.region];
     
//    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    
//    if (notification)
//    {
//        ContainerViewController *container=[[ContainerViewController alloc]initWithNibName:@"ContainerViewController" bundle:[NSBundle mainBundle] ];
//                container.shoulOpenOffers=YES;
//    
//    }
    // check if the app opens from notification
//    UILocalNotification *notification =[launchOptions objectForKeyedSubscript:UIApplicationLaunchOptionsLocalNotificationKey];
    
   
    

    
       return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (notification)
    {
        
        NSLog(@"%@",notification.userInfo.description);
      //  ContainerViewController *container=[[ContainerViewController alloc]initWithNibName:@"ContainerViewController" bundle:[NSBundle mainBundle] ];
        ContainerViewController *container = (ContainerViewController *)[self.window rootViewController];
//        ContainerViewController *container = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
       // [container initialize];
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        BOOL result = (state == UIApplicationStateActive);
        if(!result){
            [container.mainScreenViewController loadOffersViewController];
        }
        

              
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
//        OffersViewController *offers = [[OffersViewController alloc]initWithNibName:NSStringFromClass([OffersViewController class]) bundle:nil];
//        [self.window.rootViewController presentViewController:offers animated:YES completion:nil];
        
    }}
#pragma beacon manager delegaes
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
 
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Welcome to Tavant Store..Check for offers here";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{

    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Thank you for visiting Us";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
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
