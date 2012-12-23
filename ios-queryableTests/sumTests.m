//
//  sumTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-17.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "sumTests.h"

@implementation sumTests

-(void) test_sum_returns_sum_for_int_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    int sum = (int)[queryable sum:@"quantity"];

    STAssertEquals(sum, 30, @"Expected sum of 30");
}

-(void) test_sum_returns_sum_for_float_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    double sum = [queryable sum:@"price"];
    [self assertDouble:sum isEqualToDouble:16.5 message:@"Expected sum of 16.5"];
}

-(void) test_sum_returns_sum_when_filtered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*n*'"]; // banana and orange

    double sum = [queryable sum:@"quantity"];
    [self assertDouble:sum isEqualToDouble:11.0 message:@"Expected sum of 11"];
}

@end
