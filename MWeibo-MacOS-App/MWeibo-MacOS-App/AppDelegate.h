//
//  AppDelegate.h
//  MWeibo-MacOS-App
//
//  Created by 梓铭 王 on 2019/7/4.
//  Copyright © 2019 梓铭 王. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@end

