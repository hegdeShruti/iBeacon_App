//
//  Offers.h
//  iBeacon_Retail
//
//  Created by shruthi on 18/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offers : NSObject

@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,assign) NSInteger offerId;
@property(nonatomic,strong)NSString *offerHeading;
@property(nonatomic,strong)NSString *offerDescription;
@property(nonatomic,assign) NSString *beaconId;
@property(nonatomic,assign) NSInteger sectionId;
@property(nonatomic,assign) BOOL isExitOffer;


- (instancetype)initWithDictionary:(NSDictionary*)offerData;
@end
