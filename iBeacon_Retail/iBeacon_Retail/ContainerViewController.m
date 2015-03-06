//
//  ViewController.m
//  iBeacon_Retail
//
//  Created by ShrutiHegde on 2/27/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupView];
    [self setupGestures];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Used to set the intial screen of the app
-(void) setupView
{
    [self loadMainScreenViewController];
}

// loads the main container screen with default/home screen (ProductsViewController)
-(void)loadMainScreenViewController
{
    self.mainScreenViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.mainScreenViewController.view.tag = CENTER_TAG;
    self.mainScreenViewController.delegate = self;
//    if([self.screenToOpen isEqualToString:@"Offers"]){
//        [self.mainScreenViewController loadOffersViewController];
//    }
//    else{
        [self.mainScreenViewController loadProductsViewController];
//    }
    [self.mainScreenViewController loadProductsViewController];
    self.mainScreenViewController.view.frame = self.view.frame;
    self.mainScreenViewController.resetMainScreenPositionOnMenuSelection = ^(void){
        [self movePanelToOriginalPosition];
    };
    [self.view addSubview:self.mainScreenViewController.view];
    [self addChildViewController:self.mainScreenViewController];
    [self.mainScreenViewController didMoveToParentViewController:self];
}

//Loads the menu view controller incase it has not been initailzed and then returns the view of the menuviewcontroller
-(UIView*) getMenuView
{
    // init view if it doesn't already exist
    if (self.menuViewController == nil)
    {
        // this is where you define the view for the left panel
        self.menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        self.menuViewController.view.tag = LEFT_PANEL_TAG;
        self.menuViewController.delegate = self.mainScreenViewController;
        
        // adds the menu view controller in the container view controller (self)
        [self.view addSubview:self.menuViewController.view];
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
        
        self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.menuViewController.tableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.menuViewController.view;
    return view;
}

- (void)movePanelRight // to show left panel by animating the main screen viewcontroller
{
    // loads the menu view and sends it to the background behind the main screen
    UIView *childView = [self getMenuView];
    [self.view sendSubviewToBack: childView];
    
    //slide the mainscreen view to the right to reveal the menu screen
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainScreenViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        if(finished){
            self.mainScreenViewController.menuButton.tag=0;
        }
    }];
}


// reset the man screen view back to hide the menu screen
-(void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.mainScreenViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}

// method used to toggle the shadow effect for the main screen view when the menu is visible or not
- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if(value){
        [self.mainScreenViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [self.mainScreenViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mainScreenViewController.view.layer setShadowOpacity:0.8];
        [self.mainScreenViewController.view.layer setShadowOffset:CGSizeMake(offset,offset)];
    }else{
        [self.mainScreenViewController.view.layer setCornerRadius:0.0f];
        [self.mainScreenViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

//reset the values for the menu button on the main screen
-(void) resetMainView
{
    // remove left view and reset variables, if needed
    if (self.menuViewController != nil)
    {
//        [self.menuViewController.view removeFromSuperview];
//        self.menuViewController = nil;
        
        self.mainScreenViewController.menuButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}


//load gesture recognition for the main screen view
-(void) setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.mainScreenViewController.view addGestureRecognizer:panRecognizer];
}


//move the pan gesture to update the position of the main screen when the pan is detected
-(void)movePanel:(id)sender
{
    CGFloat maxXCoordForViewTranslation = self.view.frame.size.width - (self.view.frame.size.width/2);
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0) {
                childView = [self getMenuView];
        }
        // Make sure the view you're working with is front and center.
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        _showPanel = abs([sender view].center.x - [sender view].frame.size.width/2) > [sender view].frame.size.width/2;
        
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        if([sender view].frame.origin.x >= 0){
            float totalTranslation = [sender view].center.x + translatedPoint.x;
            if(totalTranslation > maxXCoordForViewTranslation){ // to ensure it does move beyond (0,0) in the left direction
                [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
                [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            }
        }
        else{
            [sender view].center = CGPointMake(150, [sender view].center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        
        
        // If you needed to check for a change in direction, you could use this code to do so.
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        NSLog(@"view center X: %f",[sender view].center.x);
//        NSLog(@"view center Y: %f",[sender view].center.y);
        _preVelocity = velocity;
    }
}


@end
