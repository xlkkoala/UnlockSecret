//
//  USFansCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/8/15.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USFansCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *focusName;
@property (weak, nonatomic) IBOutlet UILabel *focusTime;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

- (void)makeContentsByArray:(NSMutableArray *)array indexPath:(NSIndexPath *)index;

@end
