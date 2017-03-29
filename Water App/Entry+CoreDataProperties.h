//
//  Entry+CoreDataProperties.h
//  Water App
//
//  Created by Immanuel Kannan on 28/03/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "Entry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nonatomic) int16_t numberOfGlasses;

@end

NS_ASSUME_NONNULL_END
