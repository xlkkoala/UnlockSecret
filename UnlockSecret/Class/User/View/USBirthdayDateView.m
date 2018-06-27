//
//  USBirthdayDateView.m
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/27.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import "USBirthdayDateView.h"

@interface USBirthdayDateView()

@property (nonatomic, strong) NSDate *date;
@end

@implementation USBirthdayDateView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( self ){
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"USBirthdayDateView" owner:nil options:nil] firstObject];
        self.frame = frame;
        
        //监听datepicker值的改变
        
        [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
        self.date = [NSDate date];
    }
    return self;
}
- (void)dateChange:(UIDatePicker *)date{
    
    self.date = date.date;
    
}
- (IBAction)clickSave:(id)sender {
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *timestamp = [formatter stringFromDate:self.date];
    
    self.birthdayDateBlock(timestamp);
    
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
