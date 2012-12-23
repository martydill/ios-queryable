//
//  BaseTest.h
//  ios-queryableTests
//
//  Created by Marty on 2012-11-07.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Queryable.h"
#import "Product.h"

static float const epsilon = 0.000001;

@interface BaseTest : SenTestCase

@property (strong) NSArray* testProductData;

-(NSManagedObjectContext*)getContext;

-(void) assertDouble:(double)a isEqualToDouble:(float)b message:(NSString*)message;

@end
