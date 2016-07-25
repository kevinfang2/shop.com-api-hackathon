//
//  searchViewController.m
//  trollappthing
//
//  Created by family on 7/24/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController (){
    cameraViewController *cameraView;
}

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cameraView = [[cameraViewController alloc] init];
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
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;
}

-(void)search:(NSString *)searchQuery {
    NSLog(@"%@",searchQuery);
    NSData *test = [cameraView getRequest:(searchQuery)];
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:test options:kNilOptions error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)jsonObject;
        NSLog(@"jsonArray - %@",jsonArray);
    }
    else {
        
        NSLog(@"its probably a dictionary");
        NSDictionary *jsonReq = (NSDictionary *)jsonObject;
        NSArray * values = [jsonReq objectForKey:@"categories"];
        //             NSLog(@"%@", NSStringFromClass([values[0] class]));
        NSLog(@"%@", values[0]); //change to watev, this is the first one, "Tools"
        NSLog(@"%@", [[values[0] objectForKey:@"links"][0]objectForKey:@"href"]);
        
        @autoreleasepool {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSString *endpoint = [NSString stringWithFormat:@"%@",[[values[0] objectForKey:@"links"][0]objectForKey:@"href"]];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",endpoint]]];
            [request addValue:@"l7xxa85a2511a8454491ac39f7a02cab7eb8" forHTTPHeaderField:@"apikey"];
            [request setHTTPMethod:@"GET"];
            
            NSHTTPURLResponse *urlResponse = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Response Code: %d", [urlResponse statusCode]);
            if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
                //            NSLog(@"Response: %@", result);
            }
            NSLog(@"aweodcaowieacjweid %@",result);
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            NSDictionary *jsonReq = (NSDictionary *)jsonObject;
            NSArray * values = [jsonReq objectForKey:@"products"];
//            for (int x = 0; x<=10; x++){
//                [_nameArray addObject:[values[x] objectForKey:@"name"]];
//                [_priceArray addObject:[values[x] objectForKey:@"maximumPrice"]];
//                [_linksArray addObject:[values[x] objectForKey:@"referralUrl"]];
//                
//                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[values[x] objectForKey:@"imageUrl"]]];
//                UIImage * image = [UIImage imageWithData: imageData];
//                [_imagesArray addObject:image];
//            }
        }
    }

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
