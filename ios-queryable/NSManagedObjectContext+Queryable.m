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

@property (strong) NSManagedObjectContext* context;
@property (strong) NSArray* sorts;
@property (strong) NSArray* whereClauses;

@property int skipCount;
@property int takeCount;
@property (strong) NSString* type;

-(NSFetchRequest*) getFetchRequest;

@end


@implementation IQueryable

@synthesize takeCount;
@synthesize skipCount;
@synthesize sorts;
@synthesize whereClauses;
@synthesize context;
@synthesize type;

-(id)initWithType:(NSString *)entityType context:(NSManagedObjectContext*)theContext
{
    self = [super init];
    if(self != nil)
    {
        self.type = entityType;
        self.context = theContext;
        self.takeCount = INT32_MAX;
        self.skipCount = 0;
    }
    
    return self;
}

-(id) initWithType:(NSString*)entityType context:(NSManagedObjectContext*)theContext take:(int)newTake skip:(int)newSkip sorts:(NSArray*)newSorts whereClauses:(NSArray*)newWhereClauses
{
    self = [super init];
    if(self != nil)
    {
        self.type = entityType;
        self.context = theContext;
        self.takeCount = newTake;
        self.skipCount = newSkip;
        self.sorts  = newSorts;
        self.whereClauses = newWhereClauses;
    }
    
    return self;
}

-(NSArray*) toArray
{
    if(self.takeCount <= 0)
        return [[NSArray alloc] init];

    NSFetchRequest* fetchRequest = [self getFetchRequest];
    NSError* error = nil;
    NSArray* results = [self.context executeFetchRequest:fetchRequest error:&error];
    return results;
}

-(NSArray*) add:(id)object toArray:(NSArray*)array
{
    NSMutableArray* a = [NSMutableArray arrayWithArray:array];
    return [a arrayByAddingObject:object];
}

-(IQueryable*) orderBy:(NSString*)fieldName
{
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:true];
    NSArray* newSorts = [self add:descriptor toArray:self.sorts];
    
    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:self.takeCount skip:self.skipCount sorts:newSorts whereClauses:self.whereClauses];
    return q;
}

-(IQueryable*) orderByDescending:(NSString*)fieldName
{
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:false];
    NSArray* newSorts = [self add:descriptor toArray:self.sorts];
    
    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:self.takeCount skip:self.skipCount sorts:newSorts whereClauses:self.whereClauses];
    return q;
}

-(IQueryable*) skip:(int)numberToSkip
{
    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:self.takeCount skip:numberToSkip sorts:self.sorts whereClauses:self.whereClauses];

    return q;
}

-(IQueryable*) take:(int)numberToTake
{
    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:numberToTake skip:self.skipCount sorts:self.sorts whereClauses:self.whereClauses];
    
    return q;
}

-(IQueryable*) where:(NSString*)condition, ...
{
    va_list args;
    va_start(args, condition);
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:condition arguments:args];
    NSArray* newWheres = [self add:predicate toArray:self.whereClauses];
    
    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:self.takeCount skip:self.skipCount sorts:self.sorts whereClauses:newWheres];
    
    va_end(args);
    return q;
}

-(int) count
{
    NSFetchRequest* fetchRequest = [self getFetchRequest];
    int theCount = [self.context countForFetchRequest:fetchRequest error:nil];
    return theCount;
}

-(int) count:(NSString*)condition, ...
{
    IQueryable* q = [self where:condition];
    int theCount = [q count];
    return theCount;
}

-(bool)any
{
    int count = [self count];
    bool hasAny = count > 0;
    return hasAny;
}

-(bool) any:(NSString*)condition, ...
{
    int count = [self count:condition];
    bool hasAny = count > 0;
    return hasAny;
}

-(bool) all:(NSString*)condition, ...
{
    int conditionCount = [self count:condition];
    int totalCount = [self count];
    bool doAllMatch = conditionCount == totalCount;
    return doAllMatch;
}

-(id) first
{
    id result = [self firstOrDefault];
    if(!result)
        [NSException raise:@"The source sequence is empty" format:@""];
    
    return result;
}

-(id) first:(NSString*)condition, ...
{
    IQueryable* q = [self where:condition];
    id theFirst = [q first];
    return theFirst;
}

-(id) firstOrDefault
{
    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:1 skip:self.skipCount sorts:self.sorts whereClauses:self.whereClauses];
    
    NSArray* results = [q toArray];
    if(results.count > 0)
        return [results objectAtIndex:0];
    else
        return nil;
}

-(id) firstOrDefault:(NSString *)condition, ...
{
    IQueryable* q = [self where:condition];  
    id theFirstOrDefault = [q firstOrDefault];
    return theFirstOrDefault;
}

-(id) single
{
    id result = [self singleOrDefault];
    if(!result)
        [NSException raise:@"The source sequence is empty" format:@""];
    return result;
}

-(id) single:(NSString*)condition, ...
{
    IQueryable* q = [self where:condition];
    id theSingle = [q single];
    return theSingle;
}

-(id) singleOrDefault
{
    int howManyShouldITake = MIN(self.takeCount, 2);
    if(self.takeCount <= 0)
        howManyShouldITake = 0;

    IQueryable* q = [[IQueryable alloc] initWithType:self.type context:self.context take:howManyShouldITake skip:self.skipCount sorts:self.sorts whereClauses:self.whereClauses];

    NSArray* results = [q toArray];
    if(results.count == 0)
        return nil;
    else if(results.count == 1)
        return [results objectAtIndex:0];
    else
        [NSException raise:@"The source sequence contains more than one element" format:@""];
    
    return nil; // We'll never get here, but without it we get a warning about control reaching the end of a non-void function. Thanks, Xcode.
}

-(id) singleOrDefault:(NSString *)condition, ...
{
    IQueryable* q = [self where:condition];
    id theSingleOrDefault = [q singleOrDefault];
    return theSingleOrDefault;
}

-(double) average:(NSString*)property
{
    double avg = [self getExpressionValue:property function:@"average:"];
    return avg;
}

- (double) sum:(NSString*)propertyName
{
    double result = [self getExpressionValue:propertyName function:@"sum:"];
    return result;
}

- (double) min:(NSString*)propertyName
{
    double result = [self getExpressionValue:propertyName function:@"min:"];
    return result;
}

- (double) max:(NSString*)propertyName
{
    double result = [self getExpressionValue:propertyName function:@"max:"];
    return result;
}

- (double) getExpressionValue:(NSString*)property function:(NSString*)function
{
    NSExpression* keyPathExpression = [NSExpression expressionForKeyPath:property];
    NSExpression* exp = [NSExpression expressionForFunction:function arguments:[NSArray arrayWithObject:keyPathExpression]];

    NSExpressionDescription* expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"expressionValue"];
    [expressionDescription setExpression:exp];
    [expressionDescription setExpressionResultType:NSFloatAttributeType];

    NSFetchRequest* request = [self getFetchRequest];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSArray* fetchResultsArray = [self.context executeFetchRequest:request error:nil];
    NSDictionary* fetchResultsDictionary = [fetchResultsArray objectAtIndex:0];
    return [[fetchResultsDictionary objectForKey:@"expressionValue"] floatValue];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained []) stackbuf count:(NSUInteger)len
{
    NSArray* items = [self toArray];
    uint count = [items countByEnumeratingWithState:state objects:stackbuf count:len];
    return count;
}

-(NSFetchRequest*) getFetchRequest
{
    int skip = MAX(self.skipCount, 0);
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:self.type
                                              inManagedObjectContext:self.context];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    fetchRequest.sortDescriptors = self.sorts;
    
    [fetchRequest setFetchOffset:skip];
    [fetchRequest setFetchLimit:self.takeCount];
    
    if(self.whereClauses != nil)
        fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:self.whereClauses];
    
    return fetchRequest;
}


@end