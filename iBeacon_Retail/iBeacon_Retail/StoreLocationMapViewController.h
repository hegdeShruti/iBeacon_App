//
//  StoreLocationMapViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/11/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTConfig.h"
#import "ESTLocation.h"
#import "ESTIndoorLocationView.h"

@interface StoreLocationMapViewController : UIViewController

@property (nonatomic, strong) IBOutlet ESTIndoorLocationView *indoorLocationView;

- (instancetype)initWithLocation:(ESTLocation *)location;

@end
