//
//  OffersTableCell.h
//  iBeacon_Retail
//
//  Created by shruthi on 04/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *offerHeader;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *offerInfo;

@end
