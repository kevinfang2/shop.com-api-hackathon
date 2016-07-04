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

@interface cameraViewController (){
    AVCaptureStillImageOutput* stillImageOutput;
    __weak IBOutlet UIImageView *cameraView;
    __weak IBOutlet UILabel *titleLabel;
}

@end

@implementation cameraViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
         NSString *encodedString = [imageData2 base64Encoding];
         NSLog(@"%@", encodedString);
         NSData *test = [self getRequest:(@"Same")];
         [self performSegueWithIdentifier:@"afterCamera" sender:self];
     }];
}


- (NSData *) getRequest:(NSString *)itemName {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *endpoint = [NSString stringWithFormat:@"https://api.shop.com:8443/AffiliatePublisherNetwork/v1/products/{productID}/"];
    NSString *newString;
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    newString = [@"834207132" stringByAddingPercentEncodingWithAllowedCharacters:set];
    endpoint = [endpoint stringByReplacingOccurrencesOfString:@"{productID}" withString:newString];

    NSString *publisherID = @"publisherID";
    publisherID = [@"publisherID" stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *test;
    test = [@"TEST" stringByAddingPercentEncodingWithAllowedCharacters:set];

    NSString *locale;
    locale = [@"locale" stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *language;
    language = [@"en_US" stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *apikey;
    apikey = [@"apikey" stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *realapikey;
    realapikey = [@"l7xxe152174ac1504f0fbad6d99c056c84cb" stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *queryParams = [NSString stringWithFormat:@"?%@&%@",
                             [NSString stringWithFormat:@"%@=%@", publisherID, test],
                             [NSString stringWithFormat:@"%@=%@", locale, language],
                             [NSString stringWithFormat:@"%@=%@", apikey, realapikey]];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",endpoint,queryParams]]];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response Code: %d", [urlResponse statusCode]);
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSLog(@"Response: %@", result);
    }
    
    return responseData;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}


@end
