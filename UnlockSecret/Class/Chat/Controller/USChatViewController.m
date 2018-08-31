//
//  USChatViewController.m
//  UnlockSecret
//
//  Created by xlk on 2018/4/18.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USChatViewController.h"
#import "USChatInputView.h"
#import "MessageModel.h"
#import "WeChatCell.h"
#import <JMessage/JMessage.h>
static NSInteger const messagefristPageNumber = 20;

@interface USChatViewController ()<USInputViewDelegate,UITableViewDelegate,UITableViewDataSource,JMSGMessageDelegate>

@property (nonatomic, strong) NSMutableArray<MessageModel *> *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation USChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [JMessage addDelegate:self withConversation:self.conversation];
    [self getChatHeaderImage];
    [self initUI];
    self.title = self.titleName;
}

- (void)getChatHeaderImage{
    [_conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (!error) {
            self.headerImage = [UIImage imageWithData:data];
        }else{
            self.headerImage = DEFAULT_IMAGE_HEADER;
        }
        [self getHistoryMessage];
    }];
}

-(void)hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)getHistoryMessage{
    NSMutableArray * arrList = [[NSMutableArray alloc] init];
    NSInteger messageOffset = messagefristPageNumber;
    [arrList addObjectsFromArray:[[[self.conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
    for (int i = 0; i < arrList.count; i ++) {
        
        JMSGMessage *message = arrList[i];
        MessageModel *model = [[MessageModel alloc] init];
        if (message.contentType == kJMSGContentTypeText) {
            JMSGTextContent *textContent = (JMSGTextContent *)message.content;
            model.messageText = textContent.text;
        }
        if (message.isReceived == YES) {
            model.messageSenderType=MessageSenderTypeHantu;
        }else{
            model.messageSenderType=MessageSenderTypeUser;
        }
        model.messageType=MessageTypeText;
        model.headerimage = self.headerImage;
        [self.dataArray addObject:model];
    }
    [self.conversation clearUnreadCount];
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom {
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
    if (rowCount != 0 && rowCount) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    NSLog(@"receive");
    MessageModel *model=[[MessageModel alloc] init];
    model.headerimage = self.headerImage;
//    model.showMessageTime=YES;
//    model.messageTime=@"11:22";
    JMSGAbstractContent *content = message.content;
    if (message.contentType == kJMSGContentTypeText) {
        JMSGTextContent *textContent = (JMSGTextContent *)content;
        model.messageText = textContent.text;
    }
//    model.messageSentStatus=MessageSentStatusSending;
    model.messageSenderType=MessageSenderTypeHantu;
    model.messageType=MessageTypeText;
    [self.dataArray addObject:model];
    [self.conversation clearUnreadCount];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:0 animated:NO];
}

- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    NSLog(@"send");
    if (!error) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:0 animated:NO];
    }
}

- (void)initUI{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    [self.imageView setImage:nil];
    [self.imageView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = [UIView new];
    // add inputView
    for (int i = 0; i < self.dataArray.count; i ++) {
        WeChatCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSLog(@"%f",cell.frame.size.height);
    }
    USChatInputView *inputView = [[USChatInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(_IPHONE_X?(88+34+40):(64+40)), SCREEN_WIDTH, 40)];
    inputView.tableView = self.tableView;
    inputView.placeHolder = @"";
    inputView.delegate = self;
    [inputView.textField resignFirstResponder];
    [self.view addSubview:inputView];
    
//    self.title = ((JMSGConversation *)self.conversation).;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WeChatCell tableHeightWithModel:self.dataArray[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeChatCell *cell=[WeChatCell cellWithTableView:self.tableView messageModel:self.dataArray[indexPath.row]];
    
    [cell setDoubleClickBlock:^(MessageModel *model) {
        
        NSLog(@"%@-----",model.messageText);
        
    }];
    
//    [cell setSingleblock:^(MessageModel *model) {
//
//        //        NSLog(@"%@-----",model.imageUrl);
//
//
//        if (model.messageType==MessageTypeVoice) {
//
//        }else if (model.messageType==MessageTypeImage){
//
//        }
//
//
//    }];

    return cell;
}

- (void)textFieldShouldReturnInputView:(UITextField *)textField{
    JMSGConversation *con = (JMSGConversation *)self.conversation;
    JMSGUser *user = (JMSGUser *)con.target;
    NSString *name = user.username;
    [JMSGMessage sendSingleTextMessage:textField.text toUser:name];

    //判断是否提交成功，直接插入在dataarray 中
    MessageModel *model=[[MessageModel alloc] init];
//    model.showMessageTime=YES;
//    model.messageTime=@"11:22";
    model.messageText=textField.text;
    model.messageSentStatus=MessageSentStatusSended;
    model.messageSenderType=MessageSenderTypeUser;
    model.messageType=MessageTypeText;
    model.headerimage = DEFAULT_IMAGE_HEADER;
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}

- (NSMutableArray <MessageModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray<MessageModel *> array];
    }
    return _dataArray;
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
