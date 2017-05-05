
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

#define goal 12

@interface MainViewController ()

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) UILabel *numberOfGlassesLabel;
@property (nonatomic, strong) UILabel *threeLabel;

@property (nonatomic, strong) UIView *fluidContainerView;
@property (nonatomic, strong) BAFluidView *fluidView;

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
    
    [self setupContainerView];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    
    // Setup FluidView after the Main View finishes setting up
    if (!self.fluidView) {
        [self setupFluidView];
    }
 }

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
////    [self.view layoutIfNeeded];
////    
////    if (!self.fluidView) {
////        [self setupFluidView];
////    }
//}

#pragma mark - Setup Methods

- (void)setupContainerView {
    
    if (!self.fluidContainerView) {
        
        self.fluidContainerView = [[UIView alloc] init];
        self.fluidContainerView.backgroundColor = [UIColor clearColor];
        self.fluidContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.view addSubview:self.fluidContainerView];
    
        /* Auto Layout */
        //Use constraints instead of frames
        self.fluidContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSMutableDictionary *views = [[NSMutableDictionary alloc] init];
        [views setObject:self.fluidContainerView forKey:@"containerView"];
        
        if (!self.plusButton) {
            NSLog(@"PLUS NOT INITIALIZED");
        }
        else {
            [views setObject:self.plusButton forKey:@"plus"];
        }
        
        NSMutableDictionary *metrics = [[NSMutableDictionary alloc] init];
        [metrics setObject:@35 forKey:@"space"];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[containerView]-35-[plus]"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[containerView]-100-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
    }
    
    else {
        NSLog(@"was inited");
    }
    
    // Translates the constraints into a frame for the container view
    [self.view layoutIfNeeded];
    
    
}

- (void)setupFluidView {
    
    // Gets the width and height of the container view
    CGFloat width, height;
    width = self.fluidContainerView.frame.size.width;
    height = self.fluidContainerView.frame.size.height;
    
    // Instantiates the fluid view with the containers width and height
    self.fluidView = [[BAFluidView alloc] initWithFrame:CGRectMake(0, 0, width, height) maxAmplitude:10 minAmplitude:1 amplitudeIncrement:1];
    self.fluidView.strokeColor = [UIColor redColor];
    self.fluidView.fillDuration = 2;
    [self.fluidView keepStationary];
    self.fluidView.fillAutoReverse = NO;
    [self.fluidContainerView addSubview:self.fluidView];
    
    // Sets up the masking image and fluid view background
    UIImage *maskingImage = [UIImage imageNamed:@"icon"];
    UIImageView *maskingView = [[UIImageView alloc] initWithImage:maskingImage];
    maskingView.frame = self.fluidView.frame;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.fluidView.frame;
    [maskLayer setContents:(id)[maskingImage CGImage]];
    [self.fluidView.layer setMask:maskLayer];
    [self.fluidContainerView addSubview:self.fluidView];
    [self.fluidContainerView insertSubview:maskingView belowSubview:self.fluidView];
//    self.fluidContainerView.backgroundColor = kFluidBackground;
    
    // !~!~!~!~ For testing purposes only ~!~!~!~!
    // Fills the fluidView to a random value
    [self updateUI];
}

- (void)updateUI {
    
    if (self.fluidView) {
//        double val = ((double)arc4random() / ARC4RANDOM_MAX);
//        NSNumber *qty = [NSNumber numberWithDouble:val];
//        [self.fluidView fillTo:qty];
        
        NSNumber *fill = @([[[[EntryManager sharedManager] todayEntry] numberOfGlasses] doubleValue] / goal);
        [self.fluidView fillTo:fill];
        
        self.numberOfGlassesLabel.text = [NSString stringWithFormat:@"%@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses] ];
    }

}

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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[plusButton(66)]-35-[minusButton(66)]-55-|"
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
    if (self.fluidView) {
        [[EntryManager sharedManager] incrementTodayEntry];
        NSLog(@"Number of glasses: %@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses]);
        [self updateUI];
    }
//    [self updateUI];
//    NSLog(@"Plus");
}

- (void)minusButtonPressed {
    [[EntryManager sharedManager] decrementTodayEntry];
    NSLog(@"Number of glasses: %@", [[[EntryManager sharedManager] todayEntry] numberOfGlasses]);
    [self updateUI];

}

@end
