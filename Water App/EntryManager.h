//
//  EntryManager.h
//  Water App
//
//  Created by Immanuel Kannan on 29/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Entry;

@interface EntryManager : NSObject

@property (nonatomic, strong) Entry *currentlySelectedEntry;
@property (nonatomic, strong) NSManagedObjectContext *context;

+ (instancetype)sharedManager;

+ (void)setCurrentlySelectedEntry: (NSString *)date;

- (void)addOneGlassToCurrentlySelectedEntry;
- (void)subtractOneGlassFromCurrentlySelectedEntry;

@end
