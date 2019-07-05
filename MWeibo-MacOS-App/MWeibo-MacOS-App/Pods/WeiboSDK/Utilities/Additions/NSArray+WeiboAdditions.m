//
//  NSArray+WeiboAdditions.m
//  Weibo
//
//  Created by Wu Tian on 12-2-19.
//  Copyright (c) 2012年 Wutian. All rights reserved.
//

#import "NSArray+WeiboAdditions.h"

@implementation NSArray (WeiboAdditions)

- (id)firstObject{
    if ([self count] == 0) {
        return nil;
    }
    return [self objectAtIndex:0];
}

-(NSInteger)binarySearch:(id)key usingBlock:(CompareObjects)comparator{
    if(self.count == 0 || key == nil || comparator == NULL)
        return -1;
    NSInteger min = 0, max = [self count] - 1;
    while (min <= max){
        const NSInteger mid = (min + max) >> 1;
        switch (comparator(key, [self objectAtIndex:mid])){
            case NSOrderedSame:
                return mid;
            case NSOrderedDescending:
                min = mid + 1;
                break;
            case NSOrderedAscending:
                max = mid - 1;
                break;
        }
    }
    return ~min; //-(min + 1) Key not found
}

@end
