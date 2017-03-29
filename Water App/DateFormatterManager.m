//
//  DateFormatterManager.m
//  Water App
//
//  Created by Immanuel Kannan on 28/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "DateFormatterManager.h"

@interface DateFormatterManager ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation DateFormatterManager

+ (instancetype)sharedManager {
    static DateFormatterManager *formatterManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatterManager = [[self alloc] init];
    });
    
    return formatterManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.formatter = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

- (NSDateFormatter *)entryDate {
    self.formatter.dateFormat = @"yyyy-MM-dd";
    
    return self.formatter;
}


@end
