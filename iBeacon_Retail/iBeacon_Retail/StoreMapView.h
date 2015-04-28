//
//  StoreMapView.h
//  iBeacon_Retail
//
//  Created by SHALINI on 4/24/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTIndoorLocationView.h"
#import "MapPathGenerator.h"
#import"Products.h"

@interface StoreMapView :ESTIndoorLocationView
@property (assign, nonatomic) CGFloat frameWidth;
@property (assign, nonatomic) CGFloat frameHeight;
@property (nonatomic, retain) MapPathGenerator *pathGeneratorView;
@property (nonatomic, retain) Products *product;
-(void)setupLocation:(ESTLocation *)location product:(Products *)product withParentController:(id)parent;
-(void)updateUserPosition:(ESTPoint *)position;
-(void)startLocation;
-(void)stopLocation;
-(void)setupMetricx;
- (void)actionField:(UIButton*)sender;
- (void)clearPath;
-(int)getTagForSectionID:(int)sectionId;
-(void)locateProduct:(Products *)product;
@end
