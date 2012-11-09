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

@end


@implementation IQueryable

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
    }
    
    return self;
}

-(NSArray*)toArray
{
    NSError* error = nil;
    NSArray* results = [self.context executeFetchRequest:self.fetchRequest error:&error];
    return results;
}

@end