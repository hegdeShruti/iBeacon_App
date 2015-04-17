//
//  CheckouViewController.h
//  iBeacon_Retail
//
//  Created by shruthi on 16/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController
- (IBAction)dismissVIew:(id)sender;
@property(nonatomic,weak) IBOutlet UIButton *dismissButton;
- (IBAction)cancelButtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
