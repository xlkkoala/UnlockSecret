//
//  USUrl.h
//  UnlockSecret
//
//  Created by xlk on 2018/3/22.
//  Copyright © 2018年 com.xlk. All rights reserved.
//

#ifndef USUrl_h
#define USUrl_h

#define HOST @"http://lovexunmi.com:8080/xunmi/interface"
#define PICTUREHOST @"http://lovexunmi.com:8080/xunmi"

// 拼接图片地址 url 图片绝对路径 w、h图片的宽、高
#define IMAGEURL(url,w,h) [NSString stringWithFormat:@"%@/%@&w=%d&h=%d",PICTUREHOST,url,w,h]

 /*
 // url
 */

#define US_CHECK_CODE @"100"
#define US_REGISTER @"101"
#define US_LOGIN @"102"
#define US_RELEASE @"103"
#define US_FOCUS_LIST @"104"
#define US_GET_SECRET @"105"
#define US_GET_QUESTION @"106"
#define US_CHANGE_MESSAGE @"107"
#define US_FORGET_PASSWORD @"108"
#define US_FOCUS @"110"
#define US_SAVE_COMMENT @"111"
#define US_GET_RANK_LIST @"112"
#define US_COMMENT_LIST @"113"
#define US_OPEN_ALL_SECRET @"114"
#define US_RELEASE_ALL_SECRET @"115"
#define US_QUERY_SECRET @"116"
#define US_DELETE_SECRET @"117"
#define US_FOCUS_DETAIL @"118"
#define US_USER_REPLY_COMMENT @"121"
#define US_LIKE_SECRET @"122"
#define US_LIKE_COMMENT @"123"
#define US_DISCUSS_DETAIL @"126"
#define US_BROWSE_SECRET @"129" // 点赞过的秘密
#define US_RELEASE_LABEL @"130"
#define US_FANS_LIST @"131" // FANS
#define US_COMMENTS_LIST @"132" // COMMENTS
#define US_ISOPENBYUSER @"133" // 判断某个秘密是否被用户打开过
#define US_GETIMAGE @"134" // 获取拼图图片
#define US_UPLOAD_PICTURE @"4023"

#endif /* USUrl_h */
