//
//  Products.h
//  iBeacon_Retail
//
//  Created by shruthi on 16/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject
@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,strong)NSString *prodName;
@property(nonatomic,assign) NSInteger beaconId;
@property(nonatomic,assign) NSInteger sectionId;



- (instancetype)initWithDictionary:(NSDictionary*)prodcutData;
@end
