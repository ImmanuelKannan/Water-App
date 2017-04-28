//
//  SettingsTableViewController.h
//  Water App
//
//  Created by Immanuel Kannan on 24/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) NSManagedObjectContext *context;

- (instancetype)initWithStyle:(UITableViewStyle)style ManagedObjectContext:(NSManagedObjectContext *)moc;

@end
