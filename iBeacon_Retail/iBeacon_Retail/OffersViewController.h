//
//  OffersViewController.h
//  iBeacon_Retail
//
//  Created by shruthi on 04/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersViewController : UIViewController
- (IBAction)menuButtonCLicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property(nonatomic,assign) NSInteger offerId;
@end
