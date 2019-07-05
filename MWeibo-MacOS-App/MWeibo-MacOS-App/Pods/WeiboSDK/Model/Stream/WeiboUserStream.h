//
//  WeiboUserStream.h
//  Weibo
//
//  Created by Wu Tian on 12-2-20.
//  Copyright (c) 2012年 Wutian. All rights reserved.
//

#import "WeiboAccountStream.h"
#import "WeiboUser.h"

@interface WeiboUserStream : WeiboAccountStream

@property (assign,nonatomic) WeiboUser * user;

@end
