//
//  ParentViewController.h
//  Water App
//
//  Created by Immanuel Kannan on 24/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController < UIScrollViewDelegate >

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
