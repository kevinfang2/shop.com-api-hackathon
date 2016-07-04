//
//  imagesViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "imagesViewController.h"
#import "CollectionViewCell.h"

@interface imagesViewController (){
    __weak IBOutlet UINavigationItem *navbarItem;
    __weak IBOutlet UICollectionView *CollectionView;
    NSMutableArray *shopPhotos;
    NSMutableArray *shopTitles;
    NSMutableArray *shopCosts;
}

@end

@implementation imagesViewController

NSString* reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    CollectionView.dataSource = self;
    CollectionView.delegate = self;
    
    shopPhotos = [NSMutableArray arrayWithObjects:@"background", @"backButton", @"cameraButton", @"darkerBackButton",nil];
    shopTitles = [NSMutableArray arrayWithObjects: @"background", @"backButton", @"cameraButton", @"darkerBackButton", nil];
    shopCosts = [NSMutableArray arrayWithObjects: @"$5.5", @"5.5", @"5.5", @"5.5", nil];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return shopPhotos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *costLabel = (UILabel *)[cell viewWithTag:97];
    costLabel.text = shopCosts[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:98];
    nameLabel.text = shopTitles[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:[shopPhotos objectAtIndex:indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoframe"]];
    
    return cell;
}


- (void) unwindSegue{
    [self performSegueWithIdentifier:@"unwindFromImage" sender:self];
}

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
