//
//  USChatListViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/19.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USChatListViewController.h"
#import "USChatListCell.h"
#import "USChatViewController.h"
#import <JMessage/JMessage.h>
static NSString *const CHAT_LIST_CELL = @"CHAT_LIST";


@interface USChatListViewController ()<UITableViewDelegate,UITableViewDataSource,JMSGMessageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *conversationArr;
@end

@implementation USChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [JMessage addDelegate:self withConversation:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getChatList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conversationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    USChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_LIST_CELL forIndexPath:indexPath];
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
    if ([conversation.unreadCount integerValue] > 0) {
        [cell.numbers setHidden:NO];
        cell.numbers.text = [NSString stringWithFormat:@"%@", conversation.unreadCount];
    } else {
        [cell.numbers setHidden:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    USChatViewController *vc = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"CHATVC_ID"];
    vc.conversation = [_conversationArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
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
    
    //    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    //    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (NSMutableArray *)conversationArr{
    if (!_conversationArr) {
        _conversationArr = [NSMutableArray array];
    }
    return _conversationArr;
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
