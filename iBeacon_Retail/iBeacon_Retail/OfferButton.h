//
//  OfferButton.h
//  iBeacon_Retail
//
//  Created by SHALINI on 3/18/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferButton : UIButton
@property (nonatomic, strong) NSString *secTitle;
@property (nonatomic, strong) NSString *offerMsg;
@property (nonatomic, assign) int tagNo;

@end
