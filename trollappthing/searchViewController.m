//
//  searchViewController.m
//  trollappthing
//
//  Created by family on 7/24/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "searchViewController.h"
#import "ClarifaiClient.h"
#import <CloudSight/CloudSight.h>

static NSString * const kAppID = @"-ZyxNh2erUiU9-4IL-X5HJEAxJIxppO2r-wg6AMv";
static NSString * const kAppSecret = @"14jeXj05O265YuxIRHGLq1lKN40odmDv0WBl2cga";

@interface searchViewController (){
    cameraViewController *cameraView;
}

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) ClarifaiClient *client;

@end

@implementation NSString (URLEncoding)
//function used to encode query and matrix parameters
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (CFStringRef)self,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                        CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end


@implementation searchViewController
- (ClarifaiClient *)client {
    if (!_client) {
        _client = [[ClarifaiClient alloc] initWithAppID:kAppID appSecret:kAppSecret];
        // Uncomment this to request embeddings. Contact us to enable embeddings for your app:
        // _client.enableEmbed = YES;
    }
    return _client;
}
- (IBAction)backButton:(id)sender {
    [self unwindSegue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cameraView = [[cameraViewController alloc] init];
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 90, 90)];
//    UIImage *backButtonImg = [UIImage imageNamed:@"darkerBackButton"];
//    [backButton setImage:backButtonImg forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(unwindSegue) forControlEvents:UIControlEventTouchUpInside];
     self.searchField.delegate = self;
//    [self.view addSubview: backButton];
    [_searchField becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    _nameArray = [[NSMutableArray alloc] init];
    _priceArray = [[NSMutableArray alloc] init];
    _imagesArray = [[NSMutableArray alloc] init];
    _linksArray = [[NSMutableArray alloc] init];
    _brandArray = [[NSMutableArray alloc] init];
    [self.view addGestureRecognizer:tap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    textField.text = @"";
    if([_searchField hasText]) {
        [self search:(_searchField.text)];
    }
    return YES;
}

- (IBAction)submitPressed:(id)sender {
    [self dismissKeyboard];
    if([_searchField hasText]) {
        [self search:(_searchField.text)];
    }
}


- (IBAction)uploadImagePressed:(id)sender {
     NSLog(@"same");
    [self dismissKeyboard];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.0);
    
    [CloudSightConnection sharedInstance].consumerKey = @"w63eVgBk6UKS5zsK2ATaTA";
    [CloudSightConnection sharedInstance].consumerSecret = @"EM8y1gD50g-PaBNVudqxuA";
    
    CloudSightQuery *query = [[CloudSightQuery alloc] initWithImage:imageData
                                                         atLocation:CGPointMake(chosenImage.size.width/2, chosenImage.size.height/2)
                                                       withDelegate:self
                                                        atPlacemark: nil
                                                       withDeviceId:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    [query start];
    
    __block NSArray *tags;
    [self.client recognizeJpegs:@[imageData] completion:^(NSArray *results, NSError *error) {
        // Handle the response from Clarifai. This happens asynchronously.
        if (error) {
            NSLog(@"Error: %@", error);
            NSLog(@"Sorry, there was an error recognizing the image.");
        } else {
            ClarifaiResult *result = results.firstObject;
            
            NSLog([NSString stringWithFormat:@"Tags:\n%@",
                   [result.tags componentsJoinedByString:@", "]]);
            NSString *string = [NSString stringWithFormat:@"%@", result.tags];
            tags = [string componentsSeparatedByString: @","];
            NSLog(@"the first tag is %@", tags[0]);
            NSString *tag = tags[0];
            tag = [tag substringWithRange:NSMakeRange(6, [tag length] - 6)];
            NSLog(@"the modified tag is %@", tag);
            
            [self getRequest:(tag)];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)search:(NSString *)searchQuery {
    NSLog(@"%@",searchQuery);
    [self getRequest:(searchQuery)];
}

-(void)getRequest:(NSString *)searchQuery {
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
        NSArray * values = [jsonReq objectForKey:@"products"];
        //             NSLog(@"%@", NSStringFromClass([values[0] class]));
        NSLog(@"%@", values[0]); //change to watev, this is the first one, "Tools"
        for (int x = 0; x <= 11; x++){
            [_nameArray addObject:[values[x] objectForKey:@"name"]];
            [_priceArray addObject:[values[x] objectForKey:@"maximumPrice"]];
            [_linksArray addObject:[values[x] objectForKey:@"referralUrl"]];
            [_imagesArray addObject:[values[x] objectForKey:@"imageUrl"]];
            [_brandArray addObject:[values[x] objectForKey:@"brand"]];
        }
    }
        
    [[NSUserDefaults standardUserDefaults] setObject:_nameArray forKey:@"nameArray"];
    [[NSUserDefaults standardUserDefaults] setObject:_priceArray forKey:@"priceArray"];
    [[NSUserDefaults standardUserDefaults] setObject:_linksArray forKey:@"linkArray"];
    [[NSUserDefaults standardUserDefaults] setObject:_imagesArray forKey:@"imageArray"];
    [[NSUserDefaults standardUserDefaults] setObject:_brandArray forKey:@"brandArray"];

    NSLog(@"awo3idaciejcd %lu", (unsigned long)_priceArray.count);
    
    [self performSegueWithIdentifier:@"afterSearch" sender:self];
}

- (void)cloudSightQueryDidFinishUploading:(CloudSightQuery *)query
{
    NSLog(@"uploaded");
}

- (void)cloudSightQueryDidFinishIdentifying:(CloudSightQuery *)query {
    if (query.skipReason != nil) {
        NSLog(@"Skipped: %@", query.skipReason);
    } else {
        NSLog(@"Identified: %@", query.title);
    }
}

- (void)cloudSightQueryDidFail:(CloudSightQuery *)query withError:(NSError *)error {
    NSLog(@"Error: %@", error);
}
-(void)dismissKeyboard {
    [_searchField resignFirstResponder];
}


-(void) unwindSegue{
    [self dismissKeyboard];
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
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
