//
//  Game.m
//  HW5_Ancil
//
//  Created by Ancil on 8/21/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "Game.h"
#import "Utility.h"
#import "Item.h"

@interface Game()
@property (nonatomic,strong) NSMutableArray* data;
@end

@implementation Game

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _data = [[NSMutableArray alloc] init];
        [self createData];
    }
    return self;
}

-(NSArray*)getNewGame
{
    return [Utility randomizeArray:self.data ForSize:4];
}

-(void)createData
{
    
    [self.data addObject:[[Item alloc] initWithQuestion:@"Alabama" Answer:@"Montgomery"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Alaska" Answer:@"Juneau"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Arizona" Answer:@"Phoenix"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Arkansas" Answer:@"Little Rock"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"California" Answer:@"Sacremento"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Colorado" Answer:@"Denver"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Connecticut" Answer:@"Hartford"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Delaware" Answer:@"Dover"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Florida" Answer:@"Tallahassee"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Georgia" Answer:@"Atlanta"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Hawaii" Answer:@"Honolulu"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Idaho" Answer:@"Boise"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Illinois" Answer:@"Springfield"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Indiana" Answer:@"Indianapolis"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Iowa" Answer:@"Des Moines"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Kansas" Answer:@"Topeka"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Kentucky" Answer:@"Frankfort"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Maine" Answer:@"Augusta"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Maryland" Answer:@"Annapolis"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Massachussetts" Answer:@"Boston"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Michigan" Answer:@"Lansing"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Minnesota" Answer:@"Saint Paul"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Mississippi" Answer:@"Jackson"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Missouri" Answer:@"Jefferson City"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Montana" Answer:@"Helena"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Nebraska" Answer:@"Lincoln"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Nevada" Answer:@"Carson City"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"New Hampshire" Answer:@"Concord"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"New Jersey" Answer:@"Trenton"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"New Mexico" Answer:@"Santa Fe"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"New York" Answer:@"Albany"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"North Carolina" Answer:@"Raleigh"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Norh Dakota" Answer:@"Bismarck"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Ohio" Answer:@"Columbus"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Oklahoma" Answer:@"Oklahoma City"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Oregon" Answer:@"Salem"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Massachussetts" Answer:@"Boston"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Pennsylvania" Answer:@"Harrisburg"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Rhode Island" Answer:@"Providence"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"South Carolina" Answer:@"Columbia"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"South Dakota" Answer:@"Pierre"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Tennessee" Answer:@"Nashville"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Texas" Answer:@"Austin"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Utah" Answer:@"Salt Lake City"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Vermont" Answer:@"Montpelier"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Virginia" Answer:@"Richmond"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Washington" Answer:@"Olympia"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"West Virginia" Answer:@"Charleston"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Wisconsin" Answer:@"Madison"]];
    [self.data addObject:[[Item alloc] initWithQuestion:@"Wyoming" Answer:@"Cheyenne"]];

}



@end
