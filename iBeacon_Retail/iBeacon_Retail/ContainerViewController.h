//
//  ViewController.h
//  iBeacon_Retail
//
//  Created by ShrutiHegde on 2/27/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "ViewController.h"

@interface ContainerViewController : UIViewController <MainScreeViewControllerDelegate, UIGestureRecognizerDelegate>

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60


@property (nonatomic,weak) void(^test)(void);
@property (nonatomic, strong) ViewController* mainScreenViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property(nonatomic,strong) NSString *screenToOpen;

@end

