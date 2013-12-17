//
//  PlayingCard.m
//  Matchismo
//
//  Created by Johan Henkens on 11/27/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSInteger)match:(NSArray *)otherCards
{
    int score = 0;

    if ([otherCards count]){
        for (PlayingCard *otherCard in otherCards)
        {
            if (otherCard.rank == self.rank)
            {
                score += 4;
            }
            else if (otherCard.suit == self.suit)
            {
                score += 1;
            }
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♣", @"♠", @"♦", @"♥"];}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1 ;
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

@end
