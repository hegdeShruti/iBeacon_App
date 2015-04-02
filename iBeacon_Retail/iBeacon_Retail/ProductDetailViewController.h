//
//  ProductDetailViewController.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/31/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,weak) IBOutlet UIScrollView* scrollview;
@property (nonatomic,weak) IBOutlet UIView* contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *imageScrollViewContentView;


@end
