//
//  CollectionViewController.m
//  NoName
//
//  Created by 划落永恒 on 2018/12/12.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "CollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "ToolsVideo.h"
#import <UIImage+GIF.h>
#import "LookViewController.h"

@interface CollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *pathArray;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"ImageCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.pathArray = [NSMutableArray arrayWithArray:[ToolsVideo getImageArray]];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pathArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *str = [NSTemporaryDirectory() stringByAppendingPathComponent:[self.pathArray[indexPath.row] valueForKey:@"path"]] ;
    NSData *gifData = [NSData dataWithContentsOfFile:str];
    cell.imageView.image = [UIImage imageWithData:gifData];

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(self.view.frame)/2 - 10, CGRectGetWidth(self.view.frame)/2 - 10);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    LookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LookViewController"];
    vc.str = [self.pathArray[indexPath.row] valueForKey:@"path"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
#pragma mark <UICollectionViewDelegate>
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
