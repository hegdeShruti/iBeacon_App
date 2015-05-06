//
//  MenuViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/3/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "MenuViewController.h"
#import "ESTBeaconManager.h"
#import "ESTConfig.h"
#import "GlobalVariables.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "ESTIndoorLocationManager.h"
#import "ESTConfig.h"
#import "ESTLocationBuilder.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.menuItems = [NSArray arrayWithObjects:@"Products",@"Offers",@"Cart",@"Store Map",@"Logout", nil];
    self.menuImageItems = [NSArray arrayWithObjects:@"product.png",@"offer.png",@"Cart.png",@"Map.png",@"Logout.png", nil];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    NSIndexPath *indexPath = [self.tableview indexPathForSelectedRow];
    [self.tableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
   _tableHeader.frame=CGRectMake(0, 0, self.tableview.frame.size.width , 162);
   
    self.tableview.tableHeaderView = self.headerView;
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 162)];
//    headerView.backgroundColor = [UIColor redColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XXX, YYY, XXX, YYY)];
//    [headerView addSubview:imageView];
//    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(XXX, YYY, XXX, YYY)];
//    [headerView addSubview:labelView];
 //   self.tableview.tableHeaderView = headerView;

 //   [self setBlurredBackground];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)restoreUserActivityState:(NSUserActivity *)activity{
    if([activity.activityType isEqualToString:TavantIBeaconRetailContinutiyViewScreen]){
        NSDictionary* activityInfo = [activity.userInfo objectForKey:TavantIBeaconRetailContinutiyScreenData];
        self.currentIndex = [[activityInfo objectForKey:@"menuIndex"] integerValue];
        UIViewController* vc = [self loadMenuScreenAtIndex:self.currentIndex];
//        [vc restoreUserActivityState:activity];
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:^{
            [vc restoreUserActivityState:activity];
        }];
    }else if([activity.activityType isEqualToString:TavantIBeaconRetailContinutiyViewProduct]){
        NSDictionary* activityInfo = [activity.userInfo objectForKey:TavantIBeaconRetailContinutiyScreenData];
        if([[activityInfo objectForKey:@"prevScreen"] integerValue] != BeaconRetailNotAMenuOption){
            self.currentIndex = [[activityInfo objectForKey:@"prevScreen"] integerValue];
            UIViewController* vc = [self loadMenuScreenAtIndex:self.currentIndex];
            //        [vc restoreUserActivityState:activity];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:^{
                [vc restoreUserActivityState:activity];
            }];
        }else{
            
        }
    }
    [self.tableview reloadData];
        
    [super restoreUserActivityState:activity];
}

-(UIView *) headerView {
    if (!_headerView) {
       _headerView= [[[NSBundle mainBundle] loadNibNamed:@"CustomHeaderView" owner:self options:nil]objectAtIndex:0 ];
    }
   
    _headerView.iconImage.layer.cornerRadius=_headerView.iconImage.frame.size.width/2;
     _headerView.iconImage.clipsToBounds=YES;
//     _headerView.iconImage.layer.borderWidth = 1.0f;
//     _headerView.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    return _headerView;
}

-(void)viewDidLayoutSubviews {
    [self setBlurredBackground];
}

-(void)setBlurredBackground{
    
    
    [self.backgroundView setImage:[UIImage imageNamed:@"bg_blur.png"]];
//    [_backgroundView setContentMode:UIViewContentModeLeft];
//    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = self.backgroundView.bounds;
//    effectView.alpha=1.0;
//     [self.backgroundView addSubview:effectView];
   

}

#pragma mark - For Status Bar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont* menuFont = [UIFont fontWithName:@"AvenirNext" size:18];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];

    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.selectedBackgroundView.frame];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3]];
    [cell setSelectedBackgroundView:backgroundView];
    [cell.textLabel setFont:menuFont];
    [cell.textLabel setText:[self.menuItems objectAtIndex:indexPath.row]];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:[self.menuImageItems objectAtIndex:indexPath.row]];
    
    if(indexPath.row == self.currentIndex)
    {
        [tableView
         selectRowAtIndexPath:indexPath
         animated:TRUE
         scrollPosition:UITableViewScrollPositionNone
         ];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* vc;
    UIAlertView *alert;
    vc = [self loadMenuScreenAtIndex:indexPath.row];    
    if(indexPath.row != BeaconRetailLogoutIndex){
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    }else{
        alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want logout." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

#pragma mark WARNING------THERE IS A MEMORY LEAK HERE THAT NEEDS TO BE FIXED!!!!
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    __block UIViewController* vc;
    __block UIStoryboard *storyboard;
    __block AppDelegate *testAppDelegate;
    
    if([title isEqualToString:@"Yes"])
    {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^(){
            SlideNavigationController *slideMenuSetToNull = [SlideNavigationController sharedInstance];
            slideMenuSetToNull = nil;
            [GlobalVariables clearLeftMenu];
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            vc = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            testAppDelegate = [UIApplication sharedApplication].delegate;
            testAppDelegate.window.rootViewController = vc;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasALreadyLoggedIn"];
        }];
        
    }
    else if([title isEqualToString:@"No"])
    {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    }
}

#pragma mark - this method is DEPRECATED
-(StoreLocationMapViewController*)loadStoreMap:(StoreLocationMapViewController*) vc{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    ESTLocation *location = [ESTLocationBuilder parseFromJSON:content];
    vc = [[StoreLocationMapViewController alloc] initWithLocation:location];
    GlobalVariables *globalVar = [GlobalVariables getInstance];
    globalVar.storeLocationController = vc;
    return vc;
}
-(UIViewController*) loadMenuScreenAtIndex:(NSInteger) idx{
    UIViewController* vc;
    switch(idx)
    {
        case BeaconRetailProductIndex:
            vc = (ProductViewController*)[[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
            break;
        case BeaconRetailOffersIndex:
            vc = (OffersViewController*)[[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:nil];
            break;
        case BeaconRetailCartIndex:
            vc = (CartViewController*)[[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
            break;
        case BeaconRetailMapIndex:
            //            vc = [self loadStoreMap:(StoreLocationMapViewController*)vc];
            vc = [GlobalVariables getStoreMap];
            break;
        case BeaconRetailLogoutIndex:
            break;
        default:
            break;
    }
    return vc;
}
@end
