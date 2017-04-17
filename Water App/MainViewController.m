
//  MainViewController.m
//  Water App
//
//  Created by Immanuel Kannan on 24/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "MainViewController.h"
#import "Entry+CoreDataClass.h"
#import "EntryManager.h"
#import "DateFormatterManager.h"
#import "Constants.h"
#import <BAFluidView/BAFluidView.h>

@interface MainViewController ()

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) UILabel *numberOfGlassesLabel;
@property (nonatomic, strong) UILabel *threeLabel;

@end

@implementation MainViewController

- (instancetype)initWithManagedObjectContext: (NSManagedObjectContext *)moc {
    if (self = [super init]) {
        _context = moc;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupButtons];
    [self setupnumberOfGlassesLabel];
    [self setupThreeLabel];
    
    self.view.backgroundColor = kBackgroundColor;
}

#pragma mark - Setup Methods

- (void)setupButtons {
    
    /* Setup for "plus button" */
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.layer.cornerRadius = 33;
    self.plusButton.layer.borderWidth = 1.5;
    self.plusButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.plusButton addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.plusButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.plusButton];
    
    /* Setup for "minus button" */
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.frame = CGRectMake((self.view.bounds.size.width / 2) + 60, 320, 65, 65);
    self.minusButton.layer.cornerRadius = self.minusButton.bounds.size.width / 2;
    self.minusButton.layer.borderWidth = 1.5;
    self.minusButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.minusButton addTarget:self action:@selector(minusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.minusButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.minusButton];

    /* Auto Layout */
    //Basically says to use constraints instead of frames
    self.plusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.minusButton.translatesAutoresizingMaskIntoConstraints = NO;

    NSMutableDictionary *views = [[NSMutableDictionary alloc] init];
    [views setObject:self.plusButton forKey:@"plusButton"];
    [views setObject:self.minusButton forKey:@"minusButton"];
    
    NSMutableDictionary *metrics = [[NSMutableDictionary alloc] init];
    [metrics setValue:@35 forKey:@"space"];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[plusButton(66)]-35-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[minusButton(66)]-35-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minusButton(66)]-35-[plusButton(66)]-55-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
}

- (void)setupnumberOfGlassesLabel {
    
    /* Setup label that displays the number of glasses the user has drunk */
    
    // !! Remember to implement Auto Layout here !!
    self.numberOfGlassesLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) + 60, 65, 65, 65)];
    self.numberOfGlassesLabel.backgroundColor = [UIColor clearColor];
    self.numberOfGlassesLabel.textAlignment = NSTextAlignmentCenter;
    self.numberOfGlassesLabel.font = [UIFont fontWithName:kFont size:45];
//    self.numberOfGlassesLabel.text = @"5";
    self.numberOfGlassesLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.numberOfGlassesLabel];
    
    self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses]];
}

- (void)setupThreeLabel {
    
    /* Setup for the label that displays "glass" or "glasses" depending on the number of glasses drunk */
    
    // !! Rename the property and the method !!
    // !! Remember to implement Auto Layout !!
    self.threeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) + 60, 65 + 65, 65, 20)];
    self.threeLabel.backgroundColor = [UIColor clearColor];
    self.threeLabel.textColor = [UIColor whiteColor];
    self.threeLabel.font = [UIFont fontWithName:kFont size:18];
    self.threeLabel.textAlignment = NSTextAlignmentCenter;
    self.threeLabel.text = @"Glasses";
    [self.view addSubview:self.threeLabel];
}

- (void)plusButtonPressed {
    NSLog(@"Plus");
}

- (void)minusButtonPressed {
    NSLog(@"Minus");
}

@end
