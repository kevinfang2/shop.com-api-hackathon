//
//  imagesViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "imagesViewController.h"
#import "cameraViewController.h"
#import "MPAdInfo.h"
#import <SafariServices/SafariServices.h>
#import "MPCollectionViewAdPlacer.h"
#import "MPCollectionViewAdPlacerView.h"
#import "MPClientAdPositioning.h"
#import "MPNativeAdRequestTargeting.h"
#import "MPNativeAdConstants.h"
#import "MPStaticNativeAdRenderer.h"
#import "MPNativeAdRendererConfiguration.h"
#import "MPStaticNativeAdRendererSettings.h"
#import <CoreLocation/CoreLocation.h>


@interface imagesViewController () <SFSafariViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,MPCollectionViewAdPlacerDelegate> {
    __weak IBOutlet UINavigationItem *navbarItem;
    __weak IBOutlet UICollectionView *CollectionView;
}

@property (nonatomic) MPAdInfo *adInfo;
@property (nonatomic) NSMutableArray *contentItems;
@property (nonatomic) MPCollectionViewAdPlacer *placer;

@end

@implementation imagesViewController


NSString* reuseIdentifier = @"cell";

- (id)initWithAdInfo:(MPAdInfo *)info
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(70, 113);
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Collection View Ads";
        self.adInfo = info;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CollectionView.dataSource = self;
    CollectionView.delegate = self;
    
    _namesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"nameArray"];;
    _pricesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"priceArray"];
    _imagesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageArray"];
    _linksArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"linkArray"];
    _brandArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"brandArray"];
    navbarItem.title = [[NSUserDefaults standardUserDefaults] valueForKey:@"title"];
    
    NSLog(@"aowiecdoawiecmieodm %lu",(unsigned long)_namesArray.count);
    //    NSLog(@"aoweidjoawiejdoa %@", _namesArray[0]);
//    self.view.backgroundColor = [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:220/255];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupContent];
    [self setupAdPlacer];
}


- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - Content

- (void)setupContent
{
    self.contentItems = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 200; i++) {
        NSInteger r = arc4random() % 256;
        NSInteger g = arc4random() % 256;
        NSInteger b = arc4random() % 256;
        [self.contentItems addObject:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]];
    }
}

#pragma mark - AdPlacer
- (void)setupAdPlacer
{
    // Create a targeting object to serve better ads.
    MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
    targeting.desiredAssets = [NSSet setWithObjects:kAdTitleKey, kAdIconImageKey, kAdCTATextKey, nil];
    targeting.location = [[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4175];
    
    // Create and configure a renderer configuration for native ads.
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [MPCollectionViewAdPlacerView class];
    settings.viewSizeHandler = ^(CGFloat maximumWidth) {
        return CGSizeMake(70.0f, 113.0f);
    };
    
    MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    
    // Create a collection view ad placer that uses server-side ad positioning.
    self.placer = [MPCollectionViewAdPlacer placerWithCollectionView:self.collectionView viewController:self rendererConfigurations:@[config]];
    
    // If you wish to use client-side ad positioning rather than configuring your ad unit on the
    // MoPub website, comment out the line above and use the code below instead.
    
    /*
     // Create an ad positioning object and register the index paths where ads should be displayed.
     MPClientAdPositioning *positioning = [MPClientAdPositioning positioning];
     [positioning addFixedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
     [positioning enableRepeatingPositionsWithInterval:15];
     
     self.placer = [MPCollectionViewAdPlacer placerWithCollectionView:self.collectionView viewController:self adPositioning:positioning rendererConfigurations:@[config]];
     */
    
    self.placer.delegate = self;
    // Load ads (using a test ad unit ID). Feel free to replace this ad unit ID with your own.
    [self.placer loadAdsForAdUnitID:self.adInfo.ID targeting:targeting];
}


- (IBAction)reinitializeArrays:(id)sender {
    NSArray *emptyArray;
    [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"nameArray"];
    [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"priceArray"];
    [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"linkArray"];
    [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"imageArray"];
    [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"brandArray"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"apwoedcawed %lu", (unsigned long)_pricesArray.count);
    return self.contentItems.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UICollectionViewCell *cell = [collectionView mp_dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.contentView.layer.cornerRadius = 2.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    
    
    NSLog(@"awied %@", _pricesArray[indexPath.row]);
    UILabel *costLabel = (UILabel *)[cell viewWithTag:96];
    costLabel.text = _pricesArray[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:98];
    nameLabel.text = _namesArray[indexPath.row];
    
    NSLog(@"asdfasdf %@", _brandArray[indexPath.row]);
    
    UILabel *brandLabel = (UILabel *)[cell viewWithTag:97];
    NSString *trimmed = [_brandArray[indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if(![trimmed isEqualToString: @""]){
        brandLabel.text = [NSString stringWithFormat:@"By %@",_brandArray[indexPath.row]];
    }
    else{
        brandLabel.text = @"No Brand";
    }
    
    
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.layer.cornerRadius = 43;
    imageView.layer.masksToBounds = YES;

    NSLog(@"fwedwe %@", _imagesArray[indexPath.row]);
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_imagesArray[indexPath.row]]];
    UIImage * image = [UIImage imageWithData: imageData];
    imageView.image = image;
    //    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoframe"]];
//    cell.backgroundColor = [UIColor colorWithRed:0.937 green:0.870 blue:1.0 alpha:1.0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString: _linksArray[indexPath.row]]];
    svc.delegate = self;
    [self presentViewController:svc animated:YES completion:nil];
}


//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
//    [self dismissViewControllerAnimated:true completion:nil];
//}

//- (void) unwindSegue{
//    [self performSegueWithIdentifier:@"unwindFromImage" sender:self];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
