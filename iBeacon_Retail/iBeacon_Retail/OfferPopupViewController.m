//
//  OfferPopupViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 07/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "OfferPopupViewController.h"
#import "ProductDetailViewController.h"
#import "SlideNavigationController.h"


@interface OfferPopupViewController ()
@property(nonatomic,strong) NSString *offerHeaderStr;
@property(nonatomic,strong) NSString *prodName;
@property(nonatomic,strong) NSString *OfferDetails;

@property (weak, nonatomic) IBOutlet UIView *popupVisibleView;

- (IBAction)openProductDetails:(id)sender;

@end

@implementation OfferPopupViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backgroundImage.image = [UIImage imageNamed:@"bg.png"];
        self.popupVisibleView.layer.cornerRadius=5.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// dismiss the popup screen on click of gray area
- (IBAction)hidePopup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

// opening product  details screen on click of product image
- (IBAction)openProductDetails:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    ProductDetailViewController* prodDetailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    prodDetailVC.product=self.productObject;
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:prodDetailVC withSlideOutAnimation:NO andCompletion:nil];
    
}
@end
