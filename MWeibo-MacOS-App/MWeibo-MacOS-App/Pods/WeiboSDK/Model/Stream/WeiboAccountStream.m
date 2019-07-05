//
//  WeiboAccountStream.m
//  Weibo
//
//  Created by Wu Tian on 12-2-19.
//  Copyright (c) 2012年 Wutian. All rights reserved.
//

#import "WeiboAccountStream.h"
#import "WeiboAccount.h"
#import "WeiboBaseStatus.h"
#import "WeiboUser.h"

@implementation WeiboAccountStream
@synthesize account;

- (WeiboBaseStatus *)newestStatusThatIsNotMine{
    for (WeiboBaseStatus * status in statuses) {
        if (status.user.userID != self.account.user.userID) {
            return status;
        }
    }
    return nil;
}
- (NSString *)autosaveName{
    return [[super autosaveName] 
            stringByAppendingFormat:@"weibo.com/%@/",account.username];
}

@end
