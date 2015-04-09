//
//  OfferPopupViewController.h
//  iBeacon_Retail
//
//  Created by shruthi on 07/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferPopupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *offerHeader;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
- (IBAction)hidePopup:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
