//
//  averageTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-17.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "averageTests.h"

@implementation averageTests

-(void) test_average_returns_average_for_int_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    int avg = (int)[queryable average:@"quantity"];
    XCTAssertEqual(avg, 6, @"Expected average of 6");
}

-(void) test_average_returns_average_for_float_field
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    double avg = [queryable average:@"price"];
    [self assertDouble:avg isEqualToDouble:3.3 message:@"Expected average of 3.3"];
}

-(void) test_average_returns_average_when_filtered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*n*'"]; // banana and orange

    float avg = [queryable average:@"quantity"];

    XCTAssertEqual(avg, 5.5f, @"Expected average of 5.5");
}

@end
