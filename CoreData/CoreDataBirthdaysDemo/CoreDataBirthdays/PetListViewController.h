//
//  PetListViewController.h
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "BirthdayListViewController.h"

@class Person;

@interface PetListViewController : BirthdayListViewController

@property (nonatomic, strong) Person *owner;

@end
