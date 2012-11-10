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
    
    STAssertNotNil(queryable, @"Queryable should not be null");
}


- (void)test_orderByDescending_Returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderByDescending:@"name"];
    
    STAssertNotNil(queryable, @"Queryable should not be null");
}

- (void)test_orderBy_Orders_Results
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    NSArray* products = [queryable toArray];
    
    Product* firstProduct = [products objectAtIndex:0];
    Product* lastProduct = [products objectAtIndex:products.count - 1];
    
    STAssertEqualObjects(firstProduct.name, @"Apple", @"Expected product name of Apple");
    STAssertEquals(lastProduct.name, @"Strawberry", @"Expected product name of Strawberries");
}

- (void)test_orderByDescending_Orders_Results
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderByDescending:@"name"];
    NSArray* products = [queryable toArray];
    
    Product* firstProduct = [products objectAtIndex:0];
    Product* lastProduct = [products objectAtIndex:products.count - 1];
    
    STAssertEqualObjects(firstProduct.name, @"Strawberry", @"Expected product name of Strawberry");
    STAssertEquals(lastProduct.name, @"Apple", @"Expected product name of Apple");
}

@end
