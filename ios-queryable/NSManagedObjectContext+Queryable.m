//
//  NSManagedObjectContext+Queryable.m
//  ios-queryable
//
//  Created by Marty on 2012-11-07.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "NSManagedObjectContext+Queryable.h"

@implementation NSManagedObjectContext (Queryable)

-(IQueryable*) ofType:(NSString*)typeName
{
    return [[IQueryable alloc] initWithType:typeName context:self];
}

@end


@interface IQueryable()

@property (strong) NSFetchRequest* fetchRequest;
@property (strong) NSManagedObjectContext* context;
@property (strong) NSArray* sorts;
@property (strong) NSArray* descendingSorts;
@property int skipCount;
@property int takeCount;

@end


@implementation IQueryable

@synthesize takeCount;
@synthesize skipCount;
@synthesize sorts;
@synthesize context;
@synthesize fetchRequest;
@synthesize descendingSorts;

-(id)initWithType:(NSString *)type context:(NSManagedObjectContext*)theContext
{
    self = [super init];
    if(self != nil)
    {
        self.context = theContext;
        
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:type
                                                  inManagedObjectContext:self.context];
        
        self.fetchRequest = [[NSFetchRequest alloc] init];
        [self.fetchRequest setEntity:entityDescription];
        
        self.takeCount = INT32_MAX;
    }
    
    return self;
}

-(NSArray*)toArray
{
    if(self.takeCount <= 0)
        return [[NSArray alloc] init];
    
    self.skipCount = MAX(self.skipCount, 0);

    NSError* error = nil;
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    for(NSString* sort in self.sorts)
    {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sort ascending:true]];
    }
    for(NSString* descendingSort in self.descendingSorts)
    {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:descendingSort ascending:false]];
    }
    
    self.fetchRequest.sortDescriptors = sortDescriptors;
    
    [self.fetchRequest setFetchOffset:self.skipCount];
    [self.fetchRequest setFetchLimit:self.takeCount];
    NSArray* results = [self.context executeFetchRequest:self.fetchRequest error:&error];
    return results;
}

-(IQueryable*) orderBy:(NSString*)fieldName
{
    self.sorts = [[NSArray alloc] initWithObjects:fieldName, nil];
    return self;
}

-(IQueryable*) orderByDescending:(NSString*)fieldName
{
    self.descendingSorts = [[NSArray alloc] initWithObjects:fieldName, nil];
    return self;
}

-(IQueryable*) skip:(int)numberToSkip
{
    self.skipCount = numberToSkip;
    return self;
}

-(IQueryable*) take:(int)numberToTake
{
    self.takeCount = numberToTake;
    return self;
}
@end