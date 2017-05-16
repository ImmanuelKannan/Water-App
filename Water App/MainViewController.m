
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
#import "CircleUIView.h"
#import "CircleUIButton.h"
#import <BAFluidView/BAFluidView.h>

#define goal 10

@interface MainViewController ()

@property (nonatomic, strong) EntryManager *entryManager;

@property (nonatomic, strong) CircleUIButton *plusButton;
@property (nonatomic, strong) CircleUIButton *minusButton;

@property (nonatomic, strong) CircleUIView *fluidContainerView;
@property (nonatomic, strong) BAFluidView *fluidView;

@property (nonatomic, strong) UILabel *glassesCounterLabel;

@end

@implementation MainViewController

- (instancetype)initWithManagedObjectContext: (NSManagedObjectContext *)moc {
    if (self = [super init]) {
        _context = moc;
        _entryManager = [EntryManager sharedManager];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupContainerView];
    [self setupButtons];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.view layoutIfNeeded];
    
    // Setup FluidView after the Main View finishes setting up
    if (!self.fluidView) {
        [self setupFluidView];
    }
    [self setupGlassesCounterLabel];
    [self.view layoutIfNeeded];
 }

#pragma mark - Setup Methods

- (void)setupContainerView {
    
    if (!self.fluidContainerView) {
        
        self.fluidContainerView = [[CircleUIView alloc] init];
        self.fluidContainerView.backgroundColor = [UIColor clearColor];
        self.fluidContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.fluidContainerView.layer.borderWidth = 1.5;
        [self.view addSubview:self.fluidContainerView];
    
        /* Auto Layout */
        //Use constraints instead of frames
        self.fluidContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Sets fluidContainerView.width to be 70% of MainViewController.width
        [[self.fluidContainerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:.70] setActive:TRUE];

        // Sets fluidContainerView.height to be equal to fluidContainerView.width
        [[self.fluidContainerView.heightAnchor constraintEqualToAnchor:self.fluidContainerView.widthAnchor] setActive:TRUE];

        // Centers fluidContainerView with MainViewController
        [[self.fluidContainerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:TRUE];

        // Sets where the fluidContainerView's top should be
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fluidContainerView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:.1
                                                               constant:0]];
        
    }
}


- (void)setupFluidView {
    CGFloat width = self.fluidContainerView.frame.size.width;
    CGFloat height = self.fluidContainerView.frame.size.height;
    
    self.fluidView = [[BAFluidView alloc] initWithFrame:CGRectMake(0, 0, width, height) maxAmplitude:20 minAmplitude:10 amplitudeIncrement:1];
    self.fluidView.fillDuration = 2;
    [self.fluidView keepStationary];
    self.fluidView.fillAutoReverse = NO;
    [self.fluidContainerView addSubview:self.fluidView];
    
    // Sets up the circular mask for the fluidView
    UIImage *maskingImage = [UIImage imageNamed:@"circle"];
    CALayer *maskingLayer = [CALayer layer];
    maskingLayer.frame = self.fluidView.frame;
    maskingLayer.contents = (id)maskingImage.CGImage;
    
    [self.fluidView.layer setMask:maskingLayer];
    
    [self updateUI];
    
}

- (void)setupButtons {
    
    /* Setup for "plus button" */
    self.plusButton = [CircleUIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.layer.cornerRadius = 33;
    self.plusButton.layer.borderWidth = 1.5;
    self.plusButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.plusButton addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.plusButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.plusButton];
    
    /* Setup for "minus button" */
    self.minusButton = [CircleUIButton buttonWithType:UIButtonTypeCustom];
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
    
    // Sets the width, height and right anchors
    [self.plusButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.27].active = TRUE;
    [self.plusButton.heightAnchor constraintEqualToAnchor:self.plusButton.widthAnchor].active = TRUE;
    [self.plusButton.rightAnchor constraintEqualToAnchor:self.fluidContainerView.rightAnchor constant:25].active = TRUE;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.plusButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.fluidContainerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.15
                                                           constant:0]];
    
    [self.minusButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.27].active = TRUE;
    [self.minusButton.heightAnchor constraintEqualToAnchor:self.minusButton.widthAnchor].active = TRUE;
    [self.minusButton.leftAnchor constraintEqualToAnchor:self.fluidContainerView.leftAnchor constant:-25].active = TRUE;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.minusButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.fluidContainerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.15
                                                           constant:0]];
}

- (void)setupGlassesCounterLabel {
    
    /* Setup the label in the middle of the fluidView that displays the number of glasses the user has already consumed */
    
    CGFloat diameterOfFluidView = self.fluidContainerView.bounds.size.width;
    CGFloat side = [self sideOfSquareWithCircleDiameter:diameterOfFluidView];
    CGFloat originOffset = (diameterOfFluidView - side) / 2;
    
    self.glassesCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(originOffset, originOffset, side, side)];
    [self.fluidView addSubview:self.glassesCounterLabel];
    self.glassesCounterLabel.backgroundColor = [UIColor redColor];
    self.glassesCounterLabel.text = [NSString stringWithFormat:@"%@", [[self.entryManager currentlySelectedEntry] numberOfGlasses]];
    
}

#pragma mark - Button Methods

- (void)plusButtonPressed {
    if (self.fluidView) {
        [self.entryManager incrementTodayEntry];
        NSLog(@"Number of glasses: %@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses]);
        [self updateUI];
    }
}

- (void)minusButtonPressed {
    [[EntryManager sharedManager] decrementTodayEntry];
    NSLog(@"Number of glasses: %@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses]);
    [self updateUI];
}

#pragma mark - Other Methods

- (void)updateUI {
    
    if (self.fluidView) {
        
        /*
         Fills the fluidView to a random quantity
         
         double val = ((double)arc4random() / ARC4RANDOM_MAX);
         NSNumber *qty = [NSNumber numberWithDouble:val];
         [self.fluidView fillTo:qty];
         */
        
        NSNumber *fill = @([[[[EntryManager sharedManager] todayEntry] numberOfGlasses] doubleValue] / goal);
        [self.fluidView fillTo:fill];
        
//        self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses] ];
        self.glassesCounterLabel.text = [NSString stringWithFormat:@"%@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses]];
    }
    
}

- (CGFloat)sideOfSquareWithCircleDiameter:(CGFloat)diameter {
    CGFloat side;
    
    side = sqrtf(pow(diameter, 2) / 2);
    
    return side * .70;
}

@end
