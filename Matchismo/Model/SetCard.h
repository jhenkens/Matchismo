//
//  SetCard.h
//  Matchismo
//
//  Created by Johan Henkens on 12/17/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (nonatomic, readonly) NSInteger fillNumber;
@property (nonatomic, readonly) NSInteger countNumber;
@property (nonatomic, readonly) NSInteger colorNumber;
@property (nonatomic, readonly) NSInteger shapeNumber;
- (instancetype) initWithFillNumber:(NSInteger) fill
                        countNumber:(NSInteger) count
                        colorNumber:(NSInteger) color
                        shapeNumber:(NSInteger) shape;

@end
