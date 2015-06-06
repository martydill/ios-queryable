//
//  firstTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-09.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "firstTests.h"
#import "Product.h"

@implementation firstTests

- (void)test_first_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    Product* product = [queryable first];
    XCTAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_first_with_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    Product* product = [queryable first:@"name like 'A*'"];
    XCTAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_first_with_parametized_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"quantity"];

    Product* product = [queryable first:@"name = %@", @"Apple"];
    XCTAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_first_does_not_change_query
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    [queryable first];
    NSArray* allProducts = [queryable toArray];
    XCTAssertEqual(allProducts.count, self.testProductData.count, @"Expected an equal number of products");
}

- (void)test_first_throws_exception_if_object_does_not_exist
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"User"] orderBy:@"name"];
    
    XCTAssertThrows([queryable first], @"Expected an exception to be thrown");
}

- (void)test_firstOrDefault_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    Product* product = [queryable firstOrDefault];
    XCTAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_firstOrDefault_with_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    Product* product = [queryable firstOrDefault:@"name like 'A*'"];
    XCTAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_firstOrDefault_with_parametized_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"quantity"];

    Product* product = [queryable firstOrDefault:@"name = %@", @"Apple"];
    XCTAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_firstOrDefault_returns_nil_if_object_does_not_exist
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"User"] orderBy:@"name"];
    
    XCTAssertNil([queryable firstOrDefault], @"Expected result to be nil");
}

@end
