//
//  USSessionHeaderView.h
//  HeaderView
//
//  Created by xlk on 2018/6/7.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USSessionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;//全部评论
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeight;
@property (weak, nonatomic) IBOutlet UILabel *addressAndTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end
