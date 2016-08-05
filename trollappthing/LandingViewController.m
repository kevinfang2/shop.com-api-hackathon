//
//  LandingViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "LandingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "imagesViewController.h"

@interface LandingViewController (){
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UIButton *cameraButton;
    __weak IBOutlet UILabel *titleLabel;
}

@end

#define dWidth self.view.frame.size.width
#define dHeight self.view.frame.size.height

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"ac854e9873274e2db64142a9c041f905"
                         size:MOPUB_BANNER_SIZE];
//    self.adView.frame = CGRectMake(dHeight, dWidth - 160, 320, 50);

    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    CGSize size = [self.adView adContentViewSize];
    frame.origin.y = [[UIScreen mainScreen] applicationFrame].size.height - size.height;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    [self.adView loadAd];

    
    searchButton.backgroundColor = [UIColor whiteColor];
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    
    cameraButton.backgroundColor = [UIColor whiteColor];
    cameraButton.layer.cornerRadius = 5;
    cameraButton.layer.masksToBounds = YES;
    
    NSMutableAttributedString *mat = [titleLabel.attributedText mutableCopy];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    titleLabel.attributedText = mat;

//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
}

- (void)dealloc {
    self.adView = nil;
}



//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

@end
