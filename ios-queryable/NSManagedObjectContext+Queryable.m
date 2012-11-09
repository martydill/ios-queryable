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
@property (strong) NSMutableArray* sorts;

@end


@implementation IQueryable

@synthesize sorts;
@synthesize context;
@synthesize fetchRequest;

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
        
        self.sorts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray*)toArray
{
    NSError* error = nil;
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    for(NSString* sort in self.sorts)
    {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:sort ascending:true]];
    }
    
    self.fetchRequest.sortDescriptors = sortDescriptors;
    NSArray* results = [self.context executeFetchRequest:self.fetchRequest error:&error];
    return results;
}

-(IQueryable*)orderBy:(NSString*)fieldName
{
    [self.sorts addObject:fieldName];
    return self;
}

@end