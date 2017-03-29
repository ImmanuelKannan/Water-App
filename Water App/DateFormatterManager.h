//
//  DateFormatterManager.h
//  Water App
//
//  Created by Immanuel Kannan on 28/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatterManager : NSObject

+ (instancetype)sharedManager;

// Returns a date formatter that is compatible with an
// entries "yyyy-MM-dd" format
- (NSDateFormatter *)entryDate;

@end
