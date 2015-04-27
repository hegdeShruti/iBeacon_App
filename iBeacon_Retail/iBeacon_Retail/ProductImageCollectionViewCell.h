//
//  ProductImageCollectionViewCell.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 4/7/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UIImageView* prodImage;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;

@end
