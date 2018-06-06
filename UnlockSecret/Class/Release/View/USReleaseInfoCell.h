//
//  USReleaseInfoCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USReleaseInfoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
