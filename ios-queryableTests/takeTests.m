//
//  takeTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-09.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "takeTests.h"
#import "Product.h"

@implementation takeTests

- (void)test_take_returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] take:1];
    
    STAssertNotNil(queryable, @"Queryable should not be null");
}

- (void)test_take_takes_records
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] take:2];
    
    NSArray* products = [queryable toArray];
    Product* firstProduct = (Product*)[products objectAtIndex:0];
    
    STAssertEquals(products.count, (NSUInteger)2, @"The wrong number of objects was returned");
    STAssertEqualObjects(firstProduct.name, @"Apple", @"Expected a product name of Apple");
}


- (void)test_take_negative_amount_returns_no_records
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] take:-1];
    
    NSArray* products = [queryable toArray];
    
    STAssertEquals(products.count, (NSUInteger)0, @"The wrong number of objects was returned");
}

@end
