//
//  QueryCompositionTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-09.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "QueryCompositionTests.h"

@implementation QueryCompositionTests

- (void)test_queries_return_different_objects
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    IQueryable* q1 = [queryable skip:1];
    IQueryable* q2 = [queryable skip:2];
   
    STAssertFalse(q1 == q2, @"Expected q1 and q2 to be different objects");
}

- (void)test_compose_queries_with_skip
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    IQueryable* q1 = [queryable skip:1];
    IQueryable* q2 = [queryable skip:2];
    
    NSArray* results1  = [q1 toArray];
    NSArray* results2 = [q2 toArray];

    STAssertEquals(results1.count, (NSUInteger)4, @"Expected 1 item to be skipped");
    STAssertEquals(results2.count, (NSUInteger)3, @"Expected 2 items to be skipped");
}

@end
