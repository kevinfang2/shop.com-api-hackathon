//
//  cameraViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "cameraViewController.h"
#import <ImageIO/CGImageProperties.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "imagesViewController.h"
#import <CloudSight/CloudSight.h>
#import "ClarifaiClient.h"

static NSString * const kAppID = @"wsoRfJNqSNH67q1qWDgJHizF6jcX0elwolubIirz";
static NSString * const kAppSecret = @"36f8k34jIGFuV7TXl0iktYh7d1IT6hz4FpbYj47G";

@interface cameraViewController (){
    AVCaptureStillImageOutput* stillImageOutput;
    __weak IBOutlet UIImageView *cameraView;
    __weak IBOutlet UILabel *titleLabel;
}
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
@implementation cameraViewController

- (ClarifaiClient *)client {
    if (!_client) {
        _client = [[ClarifaiClient alloc] initWithAppID:kAppID appSecret:kAppSecret];
        // Uncomment this to request embeddings. Contact us to enable embeddings for your app:
        // _client.enableEmbed = YES;
    }
    return _client;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArray = [[NSMutableArray alloc] init];
    _priceArray = [[NSMutableArray alloc] init];
    _linksArray = [[NSMutableArray alloc] init];
    _imagesArray = [[NSMutableArray alloc] init];
    
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice *device = [self frontCamera];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [session addInput:input];
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    newCaptureVideoPreviewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    newCaptureVideoPreviewLayer.la
    [self.view.layer addSublayer:newCaptureVideoPreviewLayer];
    [session startRunning];
    
    //    capturedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight)];
    //    //    capturedView.image = image;
    //    [self.view addSubview:capturedView];
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    UIImage *backButtonImg = [UIImage imageNamed:@"backButton"];
    [backButton setImage:backButtonImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(unwindSegue) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: backButton];
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 38, 550, 76, 76)];
    UIImage *btnImage = [UIImage imageNamed:@"cameraButton"];
    [cameraButton setImage:btnImage forState:UIControlStateNormal];
    [cameraButton addTarget:self
                     action:@selector(capture)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    NSMutableAttributedString *mat = [titleLabel.attributedText mutableCopy];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    titleLabel.attributedText = mat;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:titleLabel];
}

-(void) unwindSegue{
    [self performSegueWithIdentifier: @"unwindSegue" sender:self];
}



-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void) capture
{
    cameraView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.2 delay:0.0 options:
     UIViewAnimationOptionCurveEaseIn animations:^{
         cameraView.backgroundColor = [UIColor clearColor];
     } completion:^ (BOOL completed) {
         [cameraView removeFromSuperview];
     }];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"snap"]+1 forKey:@"snap"];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer,kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             //             NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         NSData *imageData2 = UIImageJPEGRepresentation(image, 0.0);
         NSString *encodedString = [imageData2 base64EncodedStringWithOptions:0];
         
         [CloudSightConnection sharedInstance].consumerKey = @"w63eVgBk6UKS5zsK2ATaTA";
         [CloudSightConnection sharedInstance].consumerSecret = @"EM8y1gD50g-PaBNVudqxuA";
         
         CloudSightQuery *query = [[CloudSightQuery alloc] initWithImage:imageData2
                                                              atLocation:CGPointMake(image.size.width/2, image.size.height/2)
                                                            withDelegate:self
                                                             atPlacemark: nil
                                                            withDeviceId:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
         
         [query start];
         
         __block NSArray *tags;
         [self.client recognizeJpegs:@[imageData2] completion:^(NSArray *results, NSError *error) {
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
                 
                 NSData *test = [self getRequest:(tag)];
                 
                 
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
                         for (int x = 0; x<=10; x++){
                             [_nameArray addObject:[values[x] objectForKey:@"name"]];
                             [_priceArray addObject:[values[x] objectForKey:@"maximumPrice"]];
                             [_linksArray addObject:[values[x] objectForKey:@"referralUrl"]];
                             
                             //                             NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[values[x] objectForKey:@"imageUrl"]]];
                             //                             UIImage * image = [UIImage imageWithData: imageData];
                             [_imagesArray addObject:[values[x] objectForKey:@"imageUrl"]];
                         }
                     }
                 }
                 
                 [[NSUserDefaults standardUserDefaults] setObject:_nameArray forKey:@"nameArray"];
                 [[NSUserDefaults standardUserDefaults] setObject:_priceArray forKey:@"priceArray"];
                 [[NSUserDefaults standardUserDefaults] setObject:_linksArray forKey:@"linkArray"];
                 [[NSUserDefaults standardUserDefaults] setObject:_imagesArray forKey:@"imageArray"];
                 [[NSUserDefaults standardUserDefaults] setValue:tag forKey:@"title"];
                 
                 NSLog(@"awo3idaciejcd %lu", (unsigned long)_priceArray.count);
                 
                 [self performSegueWithIdentifier:@"afterCamera" sender:self];
             }
         }];
     }];
}




- (NSData *) getRequest:(NSString *)itemName {
    @autoreleasepool {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *endpoint = [NSString stringWithFormat:@"https://api.shop.com/AffiliatePublisherNetwork/v1/products?PublisherID=TEST&locale=en_US&term=%@",itemName];
        
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
        if([urlResponse statusCode] == 0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Server Died Sorry"
                                                                           message:@"The app might crash now"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        NSString *tempprint = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", tempprint);
        return responseData;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
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


-(void) sendRequest:(NSURLRequest*) request
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error,%@", [error localizedDescription]);
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //                 bg.backgroundColor = [UIColor blueColor];
                 NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
             });
         }
     }];
}



@end
