//
//  allTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-05.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "allTests.h"

@implementation allTests

- (void)test_all_returns_true_when_they_all_match
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*a*'"];
    
    bool all = [queryable all:@"name like '*a*'"];
    
    STAssertTrue(all, @"Expected all to be true");
}

- (void)test_all_returns_true_when_they_all_match_with_parameters
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*a*'"];

    bool all = [queryable all:@"name like %@", @"*a*"];

    STAssertTrue(all, @"Expected all to be true");
}

- (void)test_all_returns_true_when_sequence_is_empty
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like 'nonexistent'"];
    
    bool all = [queryable all:@"name like '*a*'"];
    
    STAssertTrue(all, @"Expected all to be true");
}

- (void)test_all_returns_false_when_one_element_doesnt_match
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    bool all = [queryable all:@"name like '*a*'"];
    
    STAssertFalse(all, @"Expected all to be false");
}

@end
