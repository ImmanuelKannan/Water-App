//
//  EntryManager.m
//  Water App
//
//  Created by Immanuel Kannan on 29/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "EntryManager.h"
#import "DateFormatterManager.h"
#import "Entry+CoreDataClass.h"

@implementation EntryManager

#pragma mark - Initializer Methods

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
        _entryCache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}



#pragma mark - unnamed

- (void)populateEntryCache {
    
    /* Fetch all entries from Core Data and store it in entryCache */
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSArray *array;
    
    NSError *error = nil;
    if (self.context) {
        array = [self.context executeFetchRequest:fetch error:&error];
        
        // Move all entries from array to the entryCache
        for (Entry *entry in array) {
            [self.entryCache setValue:entry forKey:entry.date];
            NSLog(@"EntryManager -(populateEntryCache): %@", entry.description);
        }
    }
    else {
        NSLog(@"EntryManager, -(populateEntryCache): self.context wasn't initialized");
    }
}

- (void)createEntryForDate: (NSString *)date {
    
    /* Make sure there's another method to check if an entry already exists for passed-in date */
    
    // Creates a new entry and puts it into self.context
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.context];
    [entry setValue:date forKey:@"date"];
    [entry setValue:[NSNumber numberWithInt:0] forKey:@"numberOfGlasses"];
    
    // Adds the created entry into self.entryCache
    [self.entryCache setValue:entry forKey:[NSString stringWithFormat:@"%@", entry.date]];
}

- (Entry *)entryForDate: (NSString *)date {
    /* Checks if an entry already exists in Core Data for the passed-in date */
    
    // Create a fetch request with a predicate that checks if there's an entry in core date with a specific date
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    fetchRequest.predicate = predicate;
    
    // If an entry is found, return the entry
    // If an entry is not found, return nil
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (array.count == 1) {
        NSLog(@"EntryManager, -(entryForDate:): Entry with date %@ found in Core Data", date);
        return [array firstObject];
    }
    else {
        NSLog(@"EntryManager, -(entryForDate:): Entry with date %@ not found in Core Data", date);
        return nil;
    }
}

- (void)setContext:(NSManagedObjectContext *)context {
    /* 
       Sets the NSManagedObjectContext property for the EntryManager
       and populates the entry cache once the context has been set
     */
    
    _context = context;
    
    if (self.context) {
        // Populates the entryCache
        [self populateEntryCache];
        
        NSDateFormatter *entryDateFormat = [[DateFormatterManager sharedManager] entryDateFormat];
        
        // Checks if an entry for the current day exists
        // If one does not exist, create an entry, and set it as self.todayEntry and self.currentlySelectedEntry
        // If one does exist, set it as self.currentlySelectedEntry and self.todayEntry
        if (!(self.todayEntry = [self entryForDate:[entryDateFormat stringFromDate:[NSDate date]]])) {
//            [self createEntryForDate:[[[DateFormatterManager sharedManager] entryDateFormat] stringFromDate:[NSDate date]]];
            [self createEntryForDate:[entryDateFormat stringFromDate:[NSDate date]]];
            self.todayEntry = [self entryForDate:[[[DateFormatterManager sharedManager] entryDateFormat] stringFromDate:[NSDate date]]];
            self.currentlySelectedEntry = self.todayEntry;
            NSLog(@"JUST CREATED: %@", self.todayEntry);
        }
        else {
            self.currentlySelectedEntry = self.todayEntry;
            NSLog(@"Always believed: %@", self.todayEntry);
        }
    }
}

- (void)incrementTodayEntry {
    if (self.todayEntry) {
        self.todayEntry.numberOfGlasses = [NSNumber numberWithInt:[self.todayEntry.numberOfGlasses intValue] + 1];
    }
}

- (void)decrementTodayEntry {
    if (self.todayEntry) {
        
        if ([self.todayEntry.numberOfGlasses isEqualToNumber:@0]) {
            self.todayEntry.numberOfGlasses = @0;
        }
        
        else {
            self.todayEntry.numberOfGlasses = [NSNumber numberWithInt:[self.todayEntry.numberOfGlasses intValue] - 1];
        }
//        self.todayEntry.numberOfGlasses = [NSNumber numberWithInt:[self.todayEntry.numberOfGlasses intValue] - 1];
    }
}

@end
