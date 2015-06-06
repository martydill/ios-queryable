//
//  minMaxTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-17.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "minMaxTests.h"

@implementation minMaxTests

- (void)test_min_returns_min_for_int_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    int min = (int)[queryable min:@"quantity"];

    XCTAssertEqual(min, 3, @"Expected min of 3");
}

- (void)test_min_returns_min_for_float_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    double min = [queryable min:@"price"];

    [self assertDouble:min isEqualToDouble:1.1 message:@"Expected min of 1.1"];
}

- (void)test_min_returns_min_when_filtered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*n*'"]; // banana and orange

    int min = (int)[queryable min:@"quantity"];

    XCTAssertEqual(min, 4, @"Expected min of 4");
}

- (void)test_max_returns_max_for_int_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    int max = (int)[queryable max:@"quantity"];

    XCTAssertEqual(max, 11, @"Expected max of 11");
}

- (void)test_max_returns_max_for_float_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    double max = [queryable max:@"price"];

    [self assertDouble:max isEqualToDouble:5.5 message:@"Expected max of 5.5"];
}

- (void)test_max_returns_max_when_filtered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*n*'"]; // banana and orange

    int max = (int)[queryable max:@"quantity"];

    XCTAssertEqual(max, 7, @"Expected max of 7");
}

@end
