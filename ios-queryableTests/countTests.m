//
//  countTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-01.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "countTests.h"
#import "Product.h"
#import "NSManagedObjectContext+Queryable.h"

@implementation countTests

- (void)test_count_returns_correct_number_of_records_when_unfiltered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    int count = [queryable count];
        
    XCTAssertEqual(self.testProductData.count, (NSUInteger)count, @"Expected count to match the total number of records");
}

- (void)test_count_returns_correct_number_of_records_when_filtered
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    int count = [queryable count:@"name = 'Banana'"];
    
    XCTAssertEqual(1, count, @"Expected count to match the total number of records");
}

- (void)test_count_returns_correct_number_of_records_when_filtered_with_parameters
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];

    int count = [queryable count:@"name = %@", @"Banana"];

    XCTAssertEqual(1, count, @"Expected count to match the total number of records");
}

- (void)test_count_returns_correct_number_of_records_after_take
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] take:3];
    
    int count = [queryable count];
    
    XCTAssertEqual(3, count, @"Expected count to match the taken number of records");
}

@end
