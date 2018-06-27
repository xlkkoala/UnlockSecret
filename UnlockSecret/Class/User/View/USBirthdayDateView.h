//
//  USBirthdayDateView.h
//  UnlockSecret
//
//  Created by 程浪V587 on 2018/6/27.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BirthdayDateBlock)(NSString *strDate);
@interface USBirthdayDateView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, copy) BirthdayDateBlock birthdayDateBlock;

@end
