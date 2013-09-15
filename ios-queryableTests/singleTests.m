//
//  singleTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-02.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "singleTests.h"
#import "Product.h"

@implementation singleTests

- (void)test_single_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] where:@"name = 'Banana'"];
    
    Product* product = [queryable single];
    STAssertEqualObjects(product.name, @"Banana", @"Expected name of Banana");
}

- (void)test_single_with_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    Product* product = [queryable single:@"name like 'App*'"];
    STAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_single_with_parametized_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];

    Product* product = [queryable single:@"name = %@", @"Apple"];
    STAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_single_throws_exception_if_object_does_not_exist
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"User"] orderBy:@"name"];
    
    STAssertThrows([queryable single], @"Expected an exception to be thrown");
}

- (void)test_single_throws_exception_if_more_than_one_object
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    STAssertThrows([queryable single], @"Expected an exception to be thrown");
}

- (void)test_single_throws_exception_if_more_than_one_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
  
    STAssertThrows([queryable single], @"Expected an exception to be thrown");
}

- (void)test_singleOrDefault_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] where:@"name = 'Banana'"];
    
    Product* product = [queryable singleOrDefault];
    STAssertEqualObjects(product.name, @"Banana", @"Expected name of Banana");
}

- (void)test_singleOrDefault_with_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"quantity"];
    
    Product* product = [queryable singleOrDefault:@"name like 'App*'"];
    STAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_singleOrDefault_with_parametized_predicate_returns_object_if_object_exists
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"quantity"];

    Product* product = [queryable singleOrDefault:@"name = %@", @"Apple"];
    STAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_singleOrDefault_returns_nil_if_object_does_not_exist
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"User"] orderBy:@"name"];
    
    STAssertNil([queryable singleOrDefault], @"Expected result to be nil");
}

- (void)test_single_throws_exception_if_more_than_one_record
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] orderBy:@"name"];
    
    STAssertThrows([queryable single], @"Expected an exception to be thrown");
}

- (void)test_single_does_not_throw_exception_after_take
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] take:1];

    Product* product = [queryable singleOrDefault];
    STAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

- (void)test_singleOrDefault_does_not_throw_exception_after_take
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] take:1];

    Product* product = [queryable single];
    STAssertEqualObjects(product.name, @"Apple", @"Expected name of Apple");
}

@end
