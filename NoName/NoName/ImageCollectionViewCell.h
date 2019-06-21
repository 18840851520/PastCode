//
//  ImageCollectionViewCell.h
//  NoName
//
//  Created by 划落永恒 on 2018/12/12.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *preview;

@end

NS_ASSUME_NONNULL_END
