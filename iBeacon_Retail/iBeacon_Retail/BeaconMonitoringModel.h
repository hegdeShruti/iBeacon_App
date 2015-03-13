//
//  BeaconMonitoringModel.h
//  iBeacon_Retail
//
//  Created by shruthi on 10/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  
    ENTRYBEACON,
    MENSECTIONBEACON,
    WOMENSECTIONBEACON,
    KIDSECTIONBEACON,
    MAINENTRANCEBEACON
    
    
    
} RegionIdentifier;

@interface BeaconMonitoringModel : NSObject


-(void) startBeaconOperations;

@end
