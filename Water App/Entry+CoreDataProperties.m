//
//  Entry+CoreDataProperties.m
//  Water App
//
//  Created by Immanuel Kannan on 28/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
}

@dynamic date;
@dynamic numberOfGlasses;

@end
