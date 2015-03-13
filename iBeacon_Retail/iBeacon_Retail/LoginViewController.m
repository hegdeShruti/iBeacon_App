//
//  LoginViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setUSerDefaults];
    // Dispose of any resources that can be recreated.
}

-(void) setUSerDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"Shruti" forKey:@"userName"];
    [defaults setObject:@"Welcome123" forKey:@"password"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
}

- (IBAction)loginButtonClicked:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *passWord = [defaults objectForKey:@"password"];
    
    if([self.userNameField.text isEqualToString:userName] && [self.userNameField.text isEqualToString:passWord]){
        
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
@end
