//
//  skipTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-09.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "skipTests.h"
#import "Product.h"

@implementation skipTests

- (void)test_skip_Returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] skip:1];
    
    XCTAssertNotNil(queryable, @"Queryable should not be null");
}

- (void)test_skip_skips_records
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] skip:2];
    
    NSArray* products = [queryable toArray];
    Product* firstProduct = (Product*)[products objectAtIndex:0];
    
    XCTAssertEqual(products.count, self.testProductData.count - 2u, @"The wrong number of objects was returned");
    XCTAssertEqualObjects(firstProduct.name, @"Orange", @"Expected a product name of Orange");
}

-(void)test_skip_negative_amount_skips_nothing
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[[context ofType:@"Product"] orderBy:@"name"] skip:-1];
    
    NSArray* products = [queryable toArray];
    
    XCTAssertEqual(products.count, self.testProductData.count, @"The wrong number of objects was returned");
}

@end
