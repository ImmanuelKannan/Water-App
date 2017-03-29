//
//  Entry+CoreDataClass.m
//  Water App
//
//  Created by Immanuel Kannan on 28/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "Entry+CoreDataClass.h"

@implementation Entry

- (NSString *)description {
    return [NSString stringWithFormat:@"Date: %@, Number of Glasses: %@", self.date, self.numberOfGlasses];
}

@end
