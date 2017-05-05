//
//  TrackerViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 24/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>
#import "Entry+CoreDataClass.h"
#import "TrackerViewController.h"
#import "Constants.h"
#import "EntryManager.h"
#import "DateFormatterManager.h"

@interface TrackerViewController () < FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance >

@property (nonatomic, strong) FSCalendar *calendar;

@end

@implementation TrackerViewController

- (instancetype)initWithManagedObjectContext: (NSManagedObjectContext *)moc {
    if (self = [super init]) {
        self.context = moc;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCalendar];
    
    self.view.backgroundColor = [UIColor clearColor];

}

#pragma mark - Setup Methods

- (void)setupCalendar {
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 275)];
    calendar.delegate = self;
    calendar.dataSource = self;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    self.calendar.firstWeekday = 2;
    
    self.calendar.appearance.headerTitleFont = [UIFont fontWithName:kFont size:20];
    self.calendar.appearance.headerTitleColor = kWhiteColor;
    
    self.calendar.appearance.weekdayFont = [UIFont fontWithName:kFont size:15];
    self.calendar.appearance.weekdayTextColor = kWhiteColor;
    
    self.calendar.appearance.titleDefaultColor = kWhiteColor;
    
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0;
    
    self.calendar.clipsToBounds = YES;
    
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
//    
//    NSDateFormatter *entryDateFormatter = [[DateFormatterManager sharedManager] entryDateFormat];
//    
//}

-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    EntryManager *entryManager = [EntryManager sharedManager];
    NSDateFormatter *entryDateFormatter = [[DateFormatterManager sharedManager] entryDateFormat];
    NSString *dateString = [NSString stringWithFormat:@"%@", [entryDateFormatter stringFromDate:date]];
    
    if ([[entryManager entryCache] objectForKey:dateString]) {
        return [UIColor greenColor];
    }
    
    else
        return [UIColor clearColor];
}

#pragma mark - FSCalendar Methods

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    EntryManager *entryManager = [EntryManager sharedManager];
    NSDateFormatter *entryDateFormatter = [[DateFormatterManager sharedManager] entryDateFormat];
    NSString *dateString = [NSString stringWithFormat:@"%@", [entryDateFormatter stringFromDate:date]];
    
    NSLog(@"%@", [[[entryManager entryCache] objectForKey:dateString] description]);
}



@end
