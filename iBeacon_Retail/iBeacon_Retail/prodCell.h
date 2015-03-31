//
//  prodCell.h
//  iBeacon_Retail
//
//  Created by shruthi on 02/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Products.h"

@interface prodCell : UICollectionViewCell

@property (nonatomic,strong) Products* product;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *prodDescription;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *offerPrice;
@property (nonatomic,weak) IBOutlet UIView* availableColor1;
@property (nonatomic,weak) IBOutlet UIView* availableColor2;
@property (nonatomic,weak) IBOutlet UIView* availableColor3;
@property (nonatomic,weak) IBOutlet UIView* availableColor4;
@property (nonatomic,weak) IBOutlet UIImageView* selectedProductIndicator;

@end
