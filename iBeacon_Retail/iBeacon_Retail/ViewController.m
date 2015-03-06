//
//  MainScreenViewController.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/4/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    // Do any additional setup after loading the view from its nib.
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

-(void)loadProductsViewController
{
    if(self.productsViewController == nil){
        self.productsViewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    }
    [self.contentView addSubview:self.productsViewController.view];
    [self addChildViewController:self.productsViewController];
    [self.productsViewController didMoveToParentViewController:self];
    self.navbar.topItem.title = @"Products";
    self.selectedIndex = productsMenuIndex;
}

-(void) loadOffersViewController
{
    if(self.offersViewController ==  nil){
        self.offersViewController = [[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:nil];
    }
    [self.contentView addSubview:self.offersViewController.view];
    [self addChildViewController:self.offersViewController];
    [self.offersViewController didMoveToParentViewController:self];
    self.navbar.topItem.title = @"Offers";
    self.selectedIndex = offersMenuIndex;
}

-(void)loadCartViewController
{
    self.navbar.topItem.title = @"Cart";
    self.selectedIndex = cartMenuIndex;
}

-(void)loadMapViewController
{
    self.navbar.topItem.title = @"Map";
    self.selectedIndex = mapMenuIndex;
}


-(void) resetViews
{
    switch(self.selectedIndex){
        case productsMenuIndex:{
            [self.productsViewController removeFromParentViewController];
            [self.productsViewController.view removeFromSuperview];
            self.productsViewController = nil;
            break;
        }
        case offersMenuIndex:{
            //            for (UIView *subView in self.contentView.subviews)
            //            {
            //                if ( [subView isKindOfClass:[OffersViewController class]])
            //                {
            //                    [subView removeFromSuperview];
            //                }
            //            }
            [self.offersViewController removeFromParentViewController];
            [self.offersViewController.view removeFromSuperview];
            self.offersViewController = nil;
            break;
        }
        case cartMenuIndex:{
            break;
        }
        case mapMenuIndex:{
            
            break;
        }
        default:
            break;
            
    }
}


- (IBAction)menuButtonPressed:(id)sender {
    UIBarButtonItem* button = sender;
    NSLog(@"The tag status is %i",button.tag);
    //    UIButton *button = sender;
    switch(button.tag){
        case 0:{
            [self.delegate movePanelToOriginalPosition];
            break;
        }
        case 1:{
            [self.delegate movePanelRight];
            break;
        }
        default:
            break;
            
    }
}

-(void)menuItemSelected:(int)menuItem
{
    switch (menuItem) {
        case productsMenuIndex:
            [self resetViews];
            [self loadProductsViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case offersMenuIndex:
            [self resetViews];
            [self loadOffersViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case cartMenuIndex:
            [self resetViews];
            [self loadCartViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        case mapMenuIndex:
            [self resetViews];
            [self loadMapViewController];
            self.resetMainScreenPositionOnMenuSelection();
            break;
        default:
            break;
    }
}
@end
