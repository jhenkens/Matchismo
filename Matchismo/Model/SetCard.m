//
//  SetCard.m
//  Matchismo
//
//  Created by Johan Henkens on 12/17/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()

@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, readwrite) NSInteger fillNumber;
@property (nonatomic, readwrite) NSInteger countNumber;
@property (nonatomic, readwrite) NSInteger colorNumber;
@property (nonatomic, readwrite) NSInteger shapeNumber;

@end

@implementation SetCard

- (instancetype) initWithFillNumber:(NSInteger) fill
                countNumber:(NSInteger) count
                colorNumber:(NSInteger) color
                shapeNumber:(NSInteger) shape
{
    self = [super init];
    
    if (self)
    {
        self.fillNumber = fill;
        self.countNumber = count;
        self.colorNumber = color;
        self.shapeNumber = shape;
    }
    
    return self;
}

- (instancetype) init
{
    return nil;
}

+ (NSArray *)propertySet
{
    return @[@"fill",@"color",@"count",@"shape"];
}

- (NSInteger)valueOfProperty:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"fill"])
    {
        return self.fillNumber;
    }
    else if ([propertyName isEqualToString:@"color"])
    {
        return self.colorNumber;
    }
    else if ([propertyName isEqualToString:@"count"])
    {
        return self.countNumber;
    }
    else if ([propertyName isEqualToString:@"shape"])
    {
        return self.shapeNumber;
    }
    else
    {
        return -1;
    }
}

- (NSDictionary*)attributes
{
    if (!_attributes) _attributes = [[NSDictionary alloc] init];
    return _attributes;
}

- (NSString*)contents
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"{"];
    for (NSString *key in [SetCard propertySet])
    {
        [str appendFormat:@"\"%@\": \"%d\",",key,[self valueOfProperty:key]];
    }
    return nil;
}

- (NSInteger)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 2)
    {
        score = 1;
        for (NSString *key in [self.attributes keyEnumerator])
        {
            if (![self isMatchWith:otherCards[0] andSecondCard:otherCards[1] onKey:key])
            {
                score = 0;
            }
        }
    }
    return score;
}

- (BOOL)isProperMatchWith:(SetCard *)first
            andSecondCard:(SetCard *)second
                    onKey:(NSString *)key
{
    return ([self.attributes valueForKey:key] == [first.attributes valueForKey:key])
    && ([first.attributes valueForKey:key] == [second.attributes valueForKey:key]);
}

- (BOOL)isNegativeMatchWith:(SetCard *)first
              andSecondCard:(SetCard *)second
                      onKey:(NSString *)key
{
    return ([self.attributes valueForKey:key] != [first.attributes valueForKey:key])
            && ([first.attributes valueForKey:key] != [second.attributes valueForKey:key])
            && ([self.attributes valueForKey:key] != [second.attributes valueForKey:key])
            ;
}

- (BOOL)isMatchWith:(SetCard *)first
      andSecondCard:(SetCard *)second
              onKey:(NSString *)key
{
    // Returns true if
    return [self isProperMatchWith:first andSecondCard:second onKey:key] || [self isNegativeMatchWith:first andSecondCard:second onKey:key];
}


@end
