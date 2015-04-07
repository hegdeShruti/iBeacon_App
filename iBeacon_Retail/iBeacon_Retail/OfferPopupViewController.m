//
//  OfferPopupViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 07/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "OfferPopupViewController.h"

@interface OfferPopupViewController ()
@property(nonatomic,strong) NSString *offerHeaderStr;
@property(nonatomic,strong) NSString *prodName;
@property(nonatomic,strong) NSString *OfferDetails;

@end

@implementation OfferPopupViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backgroundImage.image = [UIImage imageNamed:@"bg.png"];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)hidePopup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
