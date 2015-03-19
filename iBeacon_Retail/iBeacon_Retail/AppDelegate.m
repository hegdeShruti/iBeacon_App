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
#import "BeaconMonitoringModel.h"
#import "GlobalVariables.h"
#import "LoginViewController.h"
#define ESTIMOTE_PROXIMITY_UUID             [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

@interface AppDelegate ()<ESTBeaconManagerDelegate>
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) ESTBeaconRegion *regionSectionSpec;
@property(nonatomic,strong)ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *regionMenSection;
@property (nonatomic, strong) BeaconMonitoringModel *beaconOperations;
@property (nonatomic,strong) ContainerViewController *containerViewController;
@property (nonatomic,strong) LoginViewController *loginViewController;

@end

@implementation AppDelegate
@synthesize beaconOperations;
@synthesize containerViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    beaconOperations=[[BeaconMonitoringModel alloc] init];
    [beaconOperations startBeaconOperations];
    [self showMainScreen];
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
      
        ContainerViewController *container = (ContainerViewController *)[self.window rootViewController];

        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        BOOL result = (state == UIApplicationStateActive);
        if(!result){
           
            [container.mainScreenViewController loadOffersViewController:[[notification.userInfo valueForKey:@"offerId" ] intValue]];
        }
     
}}

// global method to decide main screen
-(void) showMainScreen{
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   
   // GlobalVariables *globals=[GlobalVariables getInstance];
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if([defaults boolForKey:@"hasALreadyLoggedIn"]){
     
        if (!containerViewController) {
           
            containerViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContainerViewController"];
            
        }
        self.window.rootViewController=containerViewController;
    }
    else{
        self.loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController=self.loginViewController;
    }
    
}

@end
