//
//  CheckouViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 16/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "CheckoutViewController.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancelButton.layer.borderColor=[[UIColor blackColor] CGColor];
    self.cancelButton.layer.cornerRadius=2.0f;
    self.cancelButton.layer.borderWidth=1.0f;
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

- (IBAction)dismissVIew:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelButtnClick:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
