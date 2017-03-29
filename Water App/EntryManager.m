//
//  EntryManager.m
//  Water App
//
//  Created by Immanuel Kannan on 29/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "EntryManager.h"
#import "DateFormatterManager.h"

@implementation EntryManager

+ (instancetype)sharedManager {
    static EntryManager *entryManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        entryManager = [[self alloc] init];
    });
    
    return entryManager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

@end
