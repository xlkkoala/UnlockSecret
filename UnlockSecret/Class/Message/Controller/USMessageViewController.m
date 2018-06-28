//
//  USMessageViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/6/4.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USMessageViewController.h"
#import "USMessageTableViewCell.h"
#import "UIImage+ColorAtPixel.h"
#import "USChatViewController.h"
#import <JMessage/JMessage.h>
#import "USChatViewController.h"
@interface USMessageViewController ()<UITableViewDelegate,UITableViewDataSource,JMessageDelegate>
@property (nonatomic, strong) NSMutableArray *conversationArr;
@end

@implementation USMessageViewController

- (NSMutableArray *)conversationArr{
    if (!_conversationArr) {
        _conversationArr = [NSMutableArray array];
    }
    return _conversationArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 渐变色
    UIColor *topleftColor = ColorFromRGB(43, 50, 92);
    UIColor *bottomrightColor = ColorFromRGB(62, 37, 99);
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    self.tableView.backgroundColor = UIColor.clearColor;
    
     [JMessage addDelegate:self withConversation:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getChatList];
}

- (void)getChatList{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        [self methodsInMainQueue:^{
            if (!error) {
                self.conversationArr = [self sortConversation:resultObject];
            }else{
                self.conversationArr = nil;
            }
            [self.tableView reloadData];
        }];
    }];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSArray *sortedArray = [conversationArr sortedArrayUsingDescriptors:sortDescriptors];
    
    return [NSMutableArray arrayWithArray:sortedArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.conversationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USMessageTableViewCell" forIndexPath:indexPath];
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:conversation.avatarLocalPath] placeholderImage:[UIImage imageNamed:@"wd_tx_photo"]];
    cell.name.text = conversation.title;
    cell.content.text = conversation.latestMessageContentText;
    [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        [self methodsInMainQueue:^{
            if (!error) {
                cell.headImage.image = [UIImage imageWithData:data];
            }else{
                cell.headImage.image = DEFUALT_HEADER_IMAGE;
            }
        }];
    }];
//    if ([conversation.unreadCount integerValue] > 0) {
//        [cell.numbers setHidden:NO];
//
//    } else {
//        [cell.numbers setHidden:YES];
//    }
    cell.numbers.text = [NSString stringWithFormat:@"%@", [XLKTool changeToCurrentTimeByStamp:conversation.latestMsgTime]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    USChatViewController *vc = [CHAT_STORYBOARD instantiateViewControllerWithIdentifier:CHATVC_ID];
    vc.conversation = [self.conversationArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
