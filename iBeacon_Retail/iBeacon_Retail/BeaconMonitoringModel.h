//
//  BeaconMonitoringModel.h
//  iBeacon_Retail
//
//  Created by shruthi on 10/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  
    ENTRYBEACON=1,
    MENSECTIONBEACON=135679,
    WOMENSECTIONBEACON=123679,
    KIDSECTIONBEACON=126679
    
    
    
    
} BeaconIdentifier;

@interface BeaconMonitoringModel : NSObject


-(void) startBeaconOperations;

@end
