//
//  WeiboAccount.h
//  Weibo
//
//  Created by Wu Tian on 12-2-10.
//  Copyright (c) 2012年 Wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboConstants.h"

@class WeiboUser, WeiboRequestError, WeiboAPI, WTCallback;
@class WeiboTimelineStream, WeiboMentionsStream, WeiboCommentsTimelineStream;
@class WeiboUserTimelineStream, WeiboUnread, WeiboStream;
@class WeiboRepliesStream, WeiboStatus, WeiboBaseStatus;
@class WeiboComposition, WeiboUserStream;

@protocol WeiboAccountDelegate;

@interface WeiboAccount : NSObject <NSCoding> {
    NSString * username;
    NSString * password;
    NSString * oAuthToken;
    NSString * oAuthTokenSecret;
    NSMutableDictionary *usersByUsername;
    NSString * apiRoot;
    WeiboUser * user;
    WeiboTimelineStream * timelineStream;
    WeiboMentionsStream * mentionsStream;
    WeiboCommentsTimelineStream * commentsTimelineStream;
    NSMutableArray *outbox;
    id<WeiboAccountDelegate> _delegate;
    WeiboNotificationOptions notificationOptions;
    NSMutableDictionary * userDetailsStreamsCache;
    
    // DirectMessage & Follower Not Implemented Yet.
    // But we need notificate this things.
    // Temporary use below flags.
    struct {
        unsigned int newDirectMessages:1;
        unsigned int newFollowers:1;
    } _notificationFlags;
}

@property(assign, nonatomic) id<WeiboAccountDelegate> delegate;
@property(readonly, nonatomic) NSString *username;
@property(readonly, nonatomic) NSString *password;
@property(copy, nonatomic) NSString *oAuthTokenSecret;
@property(retain, nonatomic) NSString *oAuthToken;
@property(retain, nonatomic) WeiboUser *user;
@property(readonly, nonatomic) NSString *apiRoot;
@property(assign, nonatomic) WeiboNotificationOptions notificationOptions;

#pragma mark -
#pragma mark Life Cycle
- (id)initWithUsername:(NSString *)aUsername password:(NSString *)aPassword apiRoot:(NSString *)root;
- (id)initWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

#pragma mark -
#pragma mark Accessor
- (WeiboTimelineStream *) timelineStream;
- (WeiboMentionsStream *) mentionsStream;
- (WeiboCommentsTimelineStream *) commentsTimelineStream;

#pragma mark -
#pragma mark Core Methods
- (NSString *)keychainService;
- (BOOL)isEqualToAccount:(WeiboAccount *)anotherAccount;
- (WeiboAPI *)request:(WTCallback *)callback;
- (WeiboAPI *)authenticatedRequest:(WTCallback *)callback;

#pragma mark -
#pragma mark Timeline
- (void)forceRefreshTimelines;
- (void)refreshTimelineForType:(WeiboCompositionType)type;
- (void)refreshTimelines;
- (void)resetUnreadCountWithType:(WeiboUnreadCountType)type;

#pragma mark -
#pragma mark Composition
- (void)sendCompletedComposition:(WeiboComposition *)composition;
- (void)didSendCompletedComposition:(id)response info:(id)info;

#pragma mark -
#pragma mark User
- (void)userWithUsername:(NSString *)screenname callback:(WTCallback *)callback;
- (void)userResponse:(id)response info:(id)info;

#pragma mark -
#pragma mark Account
- (void)_postAccountDidUpdateNotification;
- (void)myUserResponse:(id)response info:(id)info;
- (void)myUserDidUpdate:(WeiboUser *)user;
- (void)verifyCredentials:(WTCallback *)callback;

#pragma mark -
#pragma mark User Detail Streams
- (WeiboUserTimelineStream *)timelineStreamForUser:(WeiboUser *)aUser;


#pragma mark - Cache
- (void)pruneStatusCache;
- (void)pruneUserCache;
- (void)cacheUser:(WeiboUser *)newUser;

#pragma mark - Others
- (WeiboRepliesStream *)repliesStreamForStatus:(WeiboStatus *)status;
- (BOOL)hasFreshTweets;
- (BOOL)hasFreshMentions;
- (BOOL)hasFreshComments;
- (BOOL)hasFreshDirectMessages;
- (BOOL)hasNewFollowers;
- (BOOL)hasAnythingUnread;
- (BOOL)hasFreshAnythingApplicableToStatusItem;
- (BOOL)hasFreshAnythingApplicableToDockBadge;
- (void)deleteStatus:(WeiboBaseStatus *)status;

- (void)setHasNewDirectMessages:(BOOL)hasNew;
- (void)setHasNewFollowers:(BOOL)hasNew;

@end


@protocol WeiboAccountDelegate <NSObject>
- (void)account:(WeiboAccount *)account didFailToPost:(WeiboComposition *)composition errorMessage:(NSString *)message error:(WeiboRequestError *)error;
- (void)account:(WeiboAccount *)account didCheckingUnreadCount:(id)info;
- (void)account:(WeiboAccount *)account finishCheckingUnreadCount:(WeiboUnread *)unread;
@end
