//
//  USReleaseTextCell.h
//  UnlockSecret
//
//  Created by xlk on 2018/6/5.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ResponseTextEndChangeDelegate;

@interface USReleaseTextCell : UICollectionViewCell <UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *secretTextView;
@property (nonatomic, weak) id<ResponseTextEndChangeDelegate> delegate;
@end


@protocol ResponseTextEndChangeDelegate<NSObject>

- (void)textHaveTouchDone;

@end
