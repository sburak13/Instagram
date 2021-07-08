//
//  SignUpViewController.m
//  Instagram
//
//  Created by samanthaburak on 7/8/21.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property UIAlertController *signupAlert;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.placeholder = @"Username";
    self.passwordTextField.placeholder = @"Password";
    self.nameTextField.placeholder = @"Name";
    
    [[self.bioTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.bioTextView layer] setBorderWidth:2.3];
    [[self.bioTextView layer] setCornerRadius:15];
    
    self.signupAlert = [UIAlertController alertControllerWithTitle:@"Invalid Sign Up"
                                                          message:@"message"
                                                   preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [self.signupAlert addAction:okAction];

}


- (IBAction)didTapRegister:(id)sender {
    [self registerUser];
}


- (void)registerUser {
    self.signupAlert.title = @"Invalid Sign Up";
    
    if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]) {
        self.signupAlert.message = @"Username or Password field is blank.";
        [self presentViewController:self.signupAlert animated:YES completion:^{}];
    } else {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameTextField.text;
        newUser.password = self.passwordTextField.text;
        // newUser.name = self.nameTextField.text;
        // newUser.bio = self.bioTextView.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                
                self.signupAlert.message = [@"Error: " stringByAppendingString:error.localizedDescription];
                [self presentViewController:self.signupAlert animated:YES completion:^{}];
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
