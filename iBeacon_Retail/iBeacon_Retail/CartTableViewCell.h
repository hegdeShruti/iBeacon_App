//
//  CartTableViewCell.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/26/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Products.h"

@interface CartTableViewCell : UITableViewCell

@property (nonatomic,strong) Products* product;
@property (nonatomic,weak) IBOutlet UILabel* productName;
@property (nonatomic,weak) IBOutlet UILabel* prodDescription;
@property (nonatomic,weak) IBOutlet UILabel* price;
@property (nonatomic,weak) IBOutlet UILabel* subTotal;
@property (weak, nonatomic) IBOutlet UIImageView *prodImage;
@end
