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

@property (nonatomic, weak) NSManagedObjectContext *context;

@property (nonatomic, strong) Entry *currentlySelectedEntry;
@property (nonatomic, strong) Entry *todayEntry;
@property (nonatomic, strong) NSMutableDictionary *entryCache;

+ (instancetype)sharedManager;

- (void)populateEntryCache;
- (void)createEntryForDate: (NSString *)date;

@end
