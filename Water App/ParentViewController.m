//
//  ParentViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 24/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "ParentViewController.h"
#import "MainViewController.h"
#import "TrackerViewController.h"
#import "SettingsTableViewController.h"
#import "Constants.h"
#import "EntryManager.h"

@interface ParentViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) TrackerViewController *trackerViewController;
@property (nonatomic, strong) SettingsTableViewController *settingsTableViewController;

//Label that displays name of the screen you are currently on
@property (nonatomic, strong) UILabel *screenNameLabel;

@end

@implementation ParentViewController

- (instancetype)init {
    if (self = [super init]) {
    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Passes the context on to the EntryManager singleton
    if (self.context) {
//        [[EntryManager sharedManager] setContext:self.context];
//        [[EntryManager sharedManager] populateEntryCache];
    }
    else {
        NSLog(@"ParentViewController: self.context wasn't initialized");
    }
    
    [self setupChildViewControllers];
    [self setupScrollView];
    [self setupDivider];
    [self setupScreenNameLabel];
    
    self.view.backgroundColor = kBackgroundColor;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Sets the name of the screen you're currently on
    self.screenNameLabel.text = [self currentScreenName];
}

#pragma mark - Other Methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSString *)currentScreenName {
    int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    switch (page) {
        case 0:
            return @"Tracker View";
            break;
        case 1:
            return @"Main View";
            break;
        case 2:
            return @"Settings View";
            break;
        default:
            return nil;
            break;
    }
    
    NSLog(@"Page: %@", self.screenNameLabel);
}


#pragma mark - Setup Methods

- (void)setupChildViewControllers {
    
    // Creates the children view controllers and passes them the NSManagedObjectContext
    
    if (!self.mainViewController) {
        self.mainViewController = [[MainViewController alloc] initWithManagedObjectContext:self.context];
    }
    
    if (!self.trackerViewController) {
        self.trackerViewController = [[TrackerViewController alloc] initWithManagedObjectContext:self.context];
    }
    
    if (!self.settingsTableViewController) {
        self.settingsTableViewController = [[SettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped ManagedObjectContext:self.context];
    }
}

- (void)setupScrollView {
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        NSArray *viewControllers = [NSArray arrayWithObjects:self.trackerViewController, self.mainViewController, self.settingsTableViewController, nil];
        int index = 0;
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        for (UIViewController *viewController in viewControllers) {
            [self addChildViewController:viewController];
            CGFloat originX = (CGFloat)index * width;
            viewController.view.frame = CGRectMake(originX, 0, width, height - 100);
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
            index++;
        }
        
        //Sets the middle view controller (MainViewController) to be the first view controller displayed
        CGPoint point = CGPointMake(self.scrollView.frame.size.width, 0);
        [self.scrollView setContentOffset:point animated:NO];
        
        [self.view addSubview:self.scrollView];
    }
}

- (void)setupDivider {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 99)];
    [path addLineToPoint:CGPointMake(self.view.bounds.size.width, 99)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 1.5;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.view.layer addSublayer:shapeLayer];
}

- (void)setupScreenNameLabel {
    self.screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, 25)];
    self.screenNameLabel.textAlignment = NSTextAlignmentCenter;
    self.screenNameLabel.textColor = kWhiteColor;
    [self.view addSubview:self.screenNameLabel];
    
    self.screenNameLabel.text = [self currentScreenName];
}

@end
