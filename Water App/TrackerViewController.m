//
//  TrackerViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 24/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "TrackerViewController.h"
#import "Constants.h"

@interface TrackerViewController ()

@property (nonatomic, strong) FSCalendar *calendar;

@end

@implementation TrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCalendar];
    
    self.view.backgroundColor = kBackgroundColor;
}

#pragma mark - Setup Methods

- (void)setupCalendar {
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 275)];
    calendar.delegate = self;
    calendar.dataSource = self;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    self.calendar.appearance.headerTitleFont = [UIFont fontWithName:kFont size:20];
    self.calendar.appearance.headerTitleColor = kWhiteColor;
    
    self.calendar.appearance.weekdayFont = [UIFont fontWithName:kFont size:15];
    self.calendar.appearance.weekdayTextColor = kWhiteColor;
    
    self.calendar.appearance.titleDefaultColor = kWhiteColor;
    
    self.calendar.clipsToBounds = YES;
    
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    
    return kWhiteColor;
}



@end
