//
//  imagesViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "imagesViewController.h"
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
    
    _namesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"nameArray"];;
    _pricesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"priceArray"];
    _imagesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageArray"];
    _linksArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"linkArray"];
    _brandArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"brandArray"];
    navbarItem.title = [[NSUserDefaults standardUserDefaults] valueForKey:@"title"];
    
    NSLog(@"aowiecdoawiecmieodm %lu",(unsigned long)_namesArray.count);
    //    NSLog(@"aoweidjoawiejdoa %@", _namesArray[0]);
//    self.view.backgroundColor = [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:220/255];
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
    return _namesArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
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
