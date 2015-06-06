//
//  orderByTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-08.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "orderByTests.h"
#import "NSManagedObjectContext+Queryable.h"
#import "Product.h"

@implementation orderByTests

- (void)test_orderBy_Returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    XCTAssertNotNil(queryable, @"Queryable should not be null");
}


- (void)test_orderByDescending_Returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderByDescending:@"name"];
    
    XCTAssertNotNil(queryable, @"Queryable should not be null");
}

- (void)test_orderBy_Orders_Results
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    NSArray* products = [queryable toArray];
    
    Product* firstProduct = [products objectAtIndex:0];
    Product* lastProduct = [products objectAtIndex:products.count - 1];
    
    XCTAssertEqualObjects(firstProduct.name, @"Apple", @"Expected product name of Apple");
    XCTAssertEqual(lastProduct.name, @"Strawberry", @"Expected product name of Strawberries");
}

- (void)test_orderByDescending_Orders_Results
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderByDescending:@"name"];
    NSArray* products = [queryable toArray];
    
    Product* firstProduct = [products objectAtIndex:0];
    Product* lastProduct = [products objectAtIndex:products.count - 1];
    
    XCTAssertEqualObjects(firstProduct.name, @"Strawberry", @"Expected product name of Strawberry");
    XCTAssertEqual(lastProduct.name, @"Apple", @"Expected product name of Apple");
}

@end
