//
//  searchViewController.m
//  trollappthing
//
//  Created by family on 7/24/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 90, 90)];
    UIImage *backButtonImg = [UIImage imageNamed:@"darkerBackButton"];
    [backButton setImage:backButtonImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(unwindSegue) forControlEvents:UIControlEventTouchUpInside];
     self.searchField.delegate = self;
    [self.view addSubview: backButton];
    [_searchField becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    textField.text = @"";
    [self search:(textField.text)];
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    textField.text = @"";
//    return YES;
//}

- (IBAction)submitPressed:(id)sender {
    [self search:(_searchField.text)];
    [self dismissKeyboard];
}


- (IBAction)uploadImagePressed:(id)sender {
     NSLog(@"same");
    [self dismissKeyboard];
}

-(void)search:(NSString *)searchQuery {
    NSLog(@"%@",searchQuery);
}
    
-(void)dismissKeyboard {
    [_searchField resignFirstResponder];
}


-(void) unwindSegue{
    [self performSegueWithIdentifier: @"unwindSegue" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
