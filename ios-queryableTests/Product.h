//
//  Product.h
//  ios-queryable
//
//  Created by Marty on 2012-12-17.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSDate * created_on;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;

@end
