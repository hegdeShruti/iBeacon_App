//
//  LoginViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property(nonatomic,strong) NSUserDefaults *defaults;
@end

@implementation LoginViewController
@synthesize defaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUSerDefaults];
    
}

#pragma mark - For Status Bar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    self.contentViewWidthConstraint.constant  = [[UIScreen mainScreen] bounds].size.width;
    self.contentViewHeightConstraint.constant  = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"%f %f",self.contentViewWidthConstraint.constant ,self.contentViewHeightConstraint.constant);
    [self.view layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}


-(void) setUSerDefaults{
    defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"sss" forKey:@"userName"];
    [defaults setObject:@"123" forKey:@"password"];
    [defaults synchronize];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollViewBottomConstraint.constant  = 216.0;
        [self.view layoutIfNeeded];
        [self.scrollView setContentOffset:CGPointMake(0, 216.0) animated:YES];
    }];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollViewBottomConstraint.constant  = 0.0;
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
        return YES;
}
- (IBAction)loginButtonClicked:(id)sender {
    
    GlobalVariables *globals=[GlobalVariables getInstance];
  defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *passWord = [defaults objectForKey:@"password"];
    NSLog(@"User Name is %@",self.userNameField.text);
    NSLog(@"Password is %@",self.userNameField.text);
    if( [self ValidateTExtFields]){
    if([self.userNameField.text isEqualToString:userName] && [self.passWordField.text isEqualToString:passWord]){
        
        //globals.hasALreadyLoggedIn=YES;
        [defaults setBool:YES forKey:@"hasALreadyLoggedIn"];
       // UIStoryboard *mainViewControler=[UIStoryboard s]
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainScreen];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                        message:@"Login Failed please checkl the credentials"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                        message:@"Text fields cannot be empty"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}
-(BOOL) ValidateTExtFields{
    if([self.userNameField.text isEqualToString:@""] || [self.passWordField.text isEqualToString:@""]){
        return NO;
    }
    else{
        return YES;
    }
}

@end
