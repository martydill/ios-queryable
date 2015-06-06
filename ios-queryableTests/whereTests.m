//
//  whereTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-11.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "whereTests.h"
#import "Product.h"

@implementation whereTests

- (void)test_where_returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name = 'Banana'"];
    
    XCTAssertNotNil(queryable, @"Queryable should not be null");
}

- (void)test_where_filters_results
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name = 'Banana'"];
    
    NSArray* products = [queryable toArray];
    Product* firstProduct = (Product*)[products objectAtIndex:0];
    
    XCTAssertEqual(products.count, (NSUInteger)1, @"Expected a single product");
    XCTAssertEqualObjects(firstProduct.name, @"Banana", @"Expected a product name of Banana");
}

- (void)test_multiple_wheres_filters_results
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name like '*r*'"];
    queryable = [queryable where:@"name like '*n*'"];
    
    NSArray* products = [queryable toArray];
    Product* firstProduct = (Product*)[products objectAtIndex:0];
    
    XCTAssertEqual(products.count, (NSUInteger)1, @"Expected a single product");
    XCTAssertEqualObjects(firstProduct.name, @"Orange", @"Expected a product name of Orange");
}

- (void)test_where_with_variables_filters_results
{
    NSManagedObjectContext* context = [self getContext];
    NSString* name = @"Banana";
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name = %@", name];
    	
    NSArray* products = [queryable toArray];
    Product* firstProduct = (Product*)[products objectAtIndex:0];
    
    XCTAssertEqual(products.count, (NSUInteger)1, @"Expected a single product");
    XCTAssertEqualObjects(firstProduct.name, @"Banana", @"Expected a product name of Banana");
}
@end
