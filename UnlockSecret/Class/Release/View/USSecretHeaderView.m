//
//  USSecretHeaderself.m
//  Headerself
//
//  Created by xlk on 2018/6/7.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USSecretHeaderView.h"

//获取屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation USSecretHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatMessage];
    }
    return self;
}

- (void)creatMessage {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15;
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor colorWithRed:233/256.f green:234/256.f blue:236/256.f alpha:1];
    NSString *name = @"至尊宝～";
    NSString *time = @"05/20";
    NSString *title = @"大话西游";
    NSString *str = @"曾经有份真挚的爱情摆在我的面前，我没有珍惜，等到失去的时候才后悔莫急，人世间最痛苦的事莫过余此，如果上天在给我一次机会，我会对那个女孩说我爱你，如果要在这份爱上加个期限，我希望是一万年。";
    NSMutableArray *imageArray = [@[]mutableCopy];
    
    //头像
    NSInteger USER_BTN_HEIGHT = 60;
    UIImageView *headImgae = [[UIImageView alloc] init];
    [headImgae setBackgroundColor:[UIColor cyanColor]];
    headImgae.center = CGPointMake(SCREEN_WIDTH/2, 0);
    headImgae.bounds = CGRectMake(0, 0, USER_BTN_HEIGHT, USER_BTN_HEIGHT);
    headImgae.layer.cornerRadius = USER_BTN_HEIGHT/2;
    [self addSubview:headImgae];
    
    // +
    NSInteger ADD_BTN_HEIGHT = 15;
    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addBtn setBackgroundColor:[UIColor redColor]];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    addBtn.center = CGPointMake(SCREEN_WIDTH/2, USER_BTN_HEIGHT/2);
    addBtn.bounds = CGRectMake(0, 0, ADD_BTN_HEIGHT, ADD_BTN_HEIGHT);
    addBtn.layer.cornerRadius = ADD_BTN_HEIGHT/2;
    [addBtn addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];

    
    //标题
    NSInteger TITLE_HEIGHT;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:16];
    CGSize lblSize = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    TITLE_HEIGHT = lblSize.height;
    titleLabel.frame = CGRectMake(10,ADD_BTN_HEIGHT + USER_BTN_HEIGHT/2, SCREEN_WIDTH - 20, TITLE_HEIGHT);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    // 姓名
    NSInteger NAME_HEIGHT = 20;
    
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.textColor = [UIColor colorWithRed:105/256.f green:106/256.f blue:107/256.f alpha:1];
    namelabel.frame = CGRectMake(10, ADD_BTN_HEIGHT + USER_BTN_HEIGHT/2  + TITLE_HEIGHT, SCREEN_WIDTH-20, NAME_HEIGHT);
    namelabel.font = [UIFont systemFontOfSize:10];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.text = [NSString stringWithFormat:@"%@  %@",time,name];
    [self addSubview:namelabel];
    
    //内容
    NSInteger CONTENT_HEIGHT;
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [UIColor colorWithRed:27/256.f green:28/256.f blue:29/256.f alpha:1];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = 10; // 行距
    muParagraph.paragraphSpacing = 20; // 段距
//    muParagraph.firstLineHeadIndent = 30; // 首行缩进
    
    
    CGSize lblSize1 = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:muParagraph} context:nil].size;
    CONTENT_HEIGHT = lblSize1.height + 1;
    contentLabel.frame = CGRectMake(20, ADD_BTN_HEIGHT + USER_BTN_HEIGHT/2  + TITLE_HEIGHT + NAME_HEIGHT, SCREEN_WIDTH - 20, CONTENT_HEIGHT );
    contentLabel.textAlignment = NSTextAlignmentLeft;
//    contentLabel.text = str;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:muParagraph range:NSMakeRange(0, str.length)];
    contentLabel.attributedText = attributedString;
    [self addSubview:contentLabel];
    
    //左右间距
    NSInteger leftSpacing = 20;
    NSInteger topSpacing = 10;
    //图片
    for (int i = 0 ; i < imageArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(leftSpacing*(1+i%3) + i%3 * (SCREEN_WIDTH - leftSpacing*4)/3,
                                                                      ADD_BTN_HEIGHT + USER_BTN_HEIGHT/2  + TITLE_HEIGHT + NAME_HEIGHT  + CONTENT_HEIGHT +
                                                                      topSpacing*(i/3 + 1) + i/3 * (SCREEN_WIDTH - leftSpacing*4)/3,
                                                                      (SCREEN_WIDTH - 80)/3,
                                                                      (SCREEN_WIDTH - 80)/3)];
        button.backgroundColor = [UIColor blackColor];
        [self addSubview:button];
    }
    
    NSInteger IMAGE_HEIGHT;
    NSInteger IMGAE_SPACING;
    if (imageArray.count == 0) {
        IMAGE_HEIGHT = 0;
        IMGAE_SPACING = topSpacing;
    }else if (imageArray.count == 1||imageArray.count == 2||imageArray.count == 3){
        IMAGE_HEIGHT = (SCREEN_WIDTH - leftSpacing*4)/3;
        IMGAE_SPACING = topSpacing * 2;
    }else if (imageArray.count == 4||imageArray.count == 5||imageArray.count == 6){
        IMAGE_HEIGHT = (SCREEN_WIDTH - leftSpacing*4)/3 * 2;
        IMGAE_SPACING = topSpacing * 3;
    }else{
        IMAGE_HEIGHT = (SCREEN_WIDTH - leftSpacing*4)/3 * 3;
        IMGAE_SPACING = topSpacing * 4;
    }
    
    
    
    // 评论
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, ADD_BTN_HEIGHT + USER_BTN_HEIGHT/2  + TITLE_HEIGHT + NAME_HEIGHT  + CONTENT_HEIGHT +
                                 IMGAE_SPACING + IMAGE_HEIGHT + 10, SCREEN_WIDTH-20, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"看看大家的吐槽";
    [self addSubview:label];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH,
                            USER_BTN_HEIGHT/2  + TITLE_HEIGHT + NAME_HEIGHT  + CONTENT_HEIGHT +
                            IMGAE_SPACING + IMAGE_HEIGHT + 20+30);
    
}

- (void)addUser {
    NSLog(@"add user");
}


@end