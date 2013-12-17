//
//  Card.m
//  Matchismo
//
//  Created by Johan Henkens on 11/27/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "Card.h"
@interface Card()
@end

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards){
        if ([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    return score;
}

- (NSString *)description
{
    return self.contents;
}

@end
