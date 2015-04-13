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
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define k_SlidePixelOffset 200;


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
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
//        view.backgroundColor=[UIColor colorWithRed:230/255.0 green:143/255.0 blue:34/255.0 alpha:1.0];
//        [self.window.rootViewController.view addSubview:view];
//    }

    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:74/255.0 green:170/255.0 blue:192/255.0 alpha:1.0]];
    beaconOperations=[[BeaconMonitoringModel alloc] init];
    [beaconOperations startBeaconOperations];
    [self loadSlideNotifications];
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
        
        NSLog(@" offer id is%@",notification.userInfo.description);
      
        ContainerViewController *container = (ContainerViewController *)[self.window rootViewController];

        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        BOOL result = (state == UIApplicationStateActive);
        if(!result){
           
//            [container.mainScreenViewController loadOffersViewController:[[notification.userInfo valueForKey:@"offerId" ] intValue]];
            
            OffersViewController *offersView=[[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:[NSBundle mainBundle]];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:offersView withSlideOutAnimation:NO andCompletion:nil];
            
        }
        else{
            // show Alert
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"offer Alert"
                                                                    message:notification.userInfo.description
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
            
                    [alert show];
            // On Okay show him to Offer
            
             GlobalVariables * globals=[GlobalVariables getInstance];
//            [globals showOfferPopUp:[notification.userInfo valueForKey:@"offerDescription"] andMessage:notification.userInfo.description onController:self.window.rootViewController  ];
            [self clearNotifications];
        }
     
}
}

- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// global method to decide main screen
-(void) showMainScreen{
   NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
   
   // GlobalVariables *globals=[GlobalVariables getInstance];
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if([defaults boolForKey:@"hasALreadyLoggedIn"]){
     
//        if (!containerViewController) {
//           
//            containerViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContainerViewController"];
//            
//        }
//        [self loadSlideMenuInstance];
        
        self.window.rootViewController=[self loadSlideMenuInstance];
    }
    else{
        self.loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController=self.loginViewController;
    }
    
}

-(UINavigationController*)loadSlideMenuInstance{
    
        // this is where you define the view for the left panel
        MenuViewController *menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        ProductViewController* rootViewControllerForSlideMenu = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    
//        menuViewController.view.tag = LEFT_PANEL_TAG;
//        productsViewController.delegate=self;

//        self.menuViewController.delegate = self.mainScreenViewController;
//        // adds the menu view controller in the container view controller (self)
//        [self.view addSubview:self.menuViewController.view];
//        [self addChildViewController:self.menuViewController];
//        [self.menuViewController didMoveToParentViewController:self];
//        
//        self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//        [self.menuViewController.tableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
    SlideNavigationController *slideController = [[SlideNavigationController alloc] initWithRootViewController:rootViewControllerForSlideMenu];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:74/255.0 green:170/255.0 blue:192/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"blue_sq"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"blue_sq"]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    //slideController.rightMenu = menuViewController;
    slideController.leftMenu = menuViewController;
    slideController.menuRevealAnimationDuration = .18;
    [SlideNavigationController sharedInstance].portraitSlideOffset = k_SlidePixelOffset;
    
    // Creating a custom bar button for right menu
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    slideController.leftBarButtonItem = leftBarButtonItem;
    return slideController;
}

-(void)loadSlideNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];
}

@end
