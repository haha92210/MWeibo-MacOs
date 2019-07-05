//
//  NSDictionary+WeiboAdditions.m
//  Weibo
//
//  Created by Wu Tian on 12-2-15.
//  Copyright (c) 2012年 Wutian. All rights reserved.
//

#import "NSDictionary+WeiboAdditions.h"

@implementation NSDictionary (WeiboAdditions)

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue{
    return [self objectForKey:key] == [NSNull null] ? defaultValue 
    : [[self objectForKey:key] boolValue];
}
- (int)intForKey:(NSString *)key defaultValue:(int)defaultValue{
    return [self objectForKey:key] == [NSNull null] 
    ? defaultValue : [[self objectForKey:key] intValue];
}
- (time_t)timeForKey:(NSString *)key defaultValue:(time_t)defaultValue{
    NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}
- (long long)longlongForKey:(NSString *)key defaultValue:(long long)defaultValue{
    return [self objectForKey:key] == [NSNull null] 
    ? defaultValue : [[self objectForKey:key] longLongValue];
}
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue{
    return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] 
    ? defaultValue : [self objectForKey:key];
}

@end
