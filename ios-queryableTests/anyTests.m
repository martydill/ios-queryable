//
//  anyTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-01.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "anyTests.h"
#import "Product.h"
#import "NSManagedObjectContext+Queryable.h"

@implementation anyTests

- (void)test_any_returns_true_when_unfiltered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    bool any = [queryable any];
    
    STAssertTrue(any, @"Expected any to be true");
}

- (void)test_any_returns_true_when_there_are_some
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    bool any = [queryable any:@"name = 'Banana'"];
    
    STAssertTrue(any, @"Expected any to be true");
}

- (void)test_any_returns_false_when_there_are_none
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    bool any = [queryable any:@"name = 'Pizza'"];
    
    STAssertFalse(any, @"Expected any to be false");
}

- (void)test_any_returns_correct_value_after_take
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] take:0];
    
    bool any = [queryable any:@"name = 'Pizza'"];
    
    STAssertFalse(any, @"Expected any to be false");
}

@end
