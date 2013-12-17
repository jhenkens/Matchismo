//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Johan Henkens on 11/29/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite) NSUInteger matchCount;
@property (nonatomic, strong) NSMutableArray *chosenCards;
@property (nonatomic, strong, readwrite) NSMutableArray *previousMoves;

@end

@implementation CardMatchingGame


- (NSArray *)previousMoveDescriptions
{
    return [self.previousMoves copy];
}

- (NSMutableArray *)previousMoves
{
    if (!_previousMoves) _previousMoves = [[NSMutableArray alloc] init];
    return _previousMoves;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)matchCount
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                [self.cards addObject:card];
            }
            else
            {
                self = nil;
                return self;
            }
        }
    }
    
    self.matchCount = matchCount;
    [self.previousMoves addObject:[NSString stringWithFormat:@"Game started with match size %d!", self.matchCount]];
    
    return self;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [self initWithCardCount:count usingDeck:deck withMatchCount:2];
    
    return self;
}

- (instancetype)init
{
    return nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const double BASE_POINT_MULTIPLIER = 2.0;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched)
    {
        if (card.isChosen)
        {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
            [self.previousMoves addObject:[NSString stringWithFormat:@"Unselected %@", [card contents]]];
        }
        else
        {
            [self.previousMoves addObject:[NSString stringWithFormat:@"Selected %@. %d point selection cost.", [card contents], COST_TO_CHOOSE]];
            int matchScore = 0;
            
            if ([self.chosenCards count] == self.matchCount - 1)
            {
                matchScore += [card match:self.chosenCards];
                NSMutableArray *chosenCardsDuplicate = [self.chosenCards mutableCopy];
                
                Card *chosenCard = [chosenCardsDuplicate firstObject];
                [chosenCardsDuplicate removeObjectAtIndex:0];
                
                while ([chosenCardsDuplicate count])
                {
                    matchScore += [chosenCard match:chosenCardsDuplicate];
                    chosenCard = [chosenCardsDuplicate firstObject];
                    [chosenCardsDuplicate removeObjectAtIndex:0];
                }
                
                if (matchScore)
                {
                    int pointsEarned = (int) (matchScore * MATCH_BONUS / (self.matchCount/BASE_POINT_MULTIPLIER));
                    self.score += pointsEarned;
                    NSLog(@"Move earned %d points", pointsEarned);
                    [self.previousMoves addObject:[NSString stringWithFormat:@"%@ %@ match! %d points awarded!", card.contents, [self.chosenCards componentsJoinedByString:@" "], pointsEarned]];
                    card.matched = YES;
                    for (Card *matchedCard in self.chosenCards)
                    {
                        matchedCard.matched = YES;
                    }
                    [self.chosenCards removeAllObjects];
                }
                else
                {
                    int pointsLost = (int) (MISMATCH_PENALTY * (self.matchCount/BASE_POINT_MULTIPLIER));
                    self.score -= pointsLost;
                    [self.previousMoves addObject:[NSString stringWithFormat:@"%@ %@ don't match! %d point penalty!", card.contents, [self.chosenCards componentsJoinedByString:@" "], pointsLost]];
                    Card *unchosenCard = [self.chosenCards firstObject];
                    [self.chosenCards removeObjectAtIndex:0];
                    unchosenCard.chosen = NO;
                }
            }
            //If no matches, this card must be added to chosenCards
            if (!matchScore)
            {
                [self.chosenCards addObject:card];
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}


- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
@end
