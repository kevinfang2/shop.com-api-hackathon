//
//  imagesViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "imagesViewController.h"
#import "CollectionViewCell.h"
#import "cameraViewController.h"

@interface imagesViewController (){
    __weak IBOutlet UINavigationItem *navbarItem;
    __weak IBOutlet UICollectionView *CollectionView;
}

@end

@implementation imagesViewController


NSString* reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    CollectionView.dataSource = self;
    CollectionView.delegate = self;
    _namesArray = [[NSMutableArray alloc]init];
    _pricesArray = [[NSMutableArray alloc]init];
    _imagesArray = [[NSMutableArray alloc] init];
    _linksArray = [[NSMutableArray alloc] init];
    NSLog(@"aowiecdoawiecmieodm %lu",(unsigned long)_namesArray.count);
    NSLog(@"apwoedcawed %lu", (unsigned long)_pricesArray.count);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _namesArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *costLabel = (UILabel *)[cell viewWithTag:97];
    costLabel.text = _pricesArray[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:98];
    nameLabel.text = _namesArray[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:[_imagesArray objectAtIndex:indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoframe"]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _linksArray[indexPath.row]]];
}


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
