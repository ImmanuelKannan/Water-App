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

@interface ParentViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) TrackerViewController *trackerViewController;
@property (nonatomic, strong) SettingsTableViewController *settingsTableViewController;

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

    [self setupChildViewControllers];
    [self setupScrollView];
    [self setupDivider];
    
    self.view.backgroundColor = kBackgroundColor;
}

#pragma mark - UIScrollViewDelegate Methods


#pragma mark - Setup Methods

- (void)setupChildViewControllers {
    if (!self.mainViewController) {
        self.mainViewController = [[MainViewController alloc] init];
    }
    
    if (!self.trackerViewController) {
        self.trackerViewController = [[TrackerViewController alloc] init];
    }
    
    if (!self.settingsTableViewController) {
        self.settingsTableViewController = [[SettingsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
}

- (void)setupScrollView {
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        NSArray *viewControllers = [NSArray arrayWithObjects:self.mainViewController, self.trackerViewController, self.settingsTableViewController, nil];
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
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.view.layer addSublayer:shapeLayer];
}

@end
