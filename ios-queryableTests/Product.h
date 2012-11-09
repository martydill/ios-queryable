//
//  Product.h
//  ios-queryable
//
//  Created by Marty on 2012-11-08.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic) NSTimeInterval created_on;
@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString * name;

@end
