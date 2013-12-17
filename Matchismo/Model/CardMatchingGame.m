//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Johan Henkens on 11/29/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *chosenCards;

//Public readonly, private readwrite
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSUInteger cardMatchCount;
@property (nonatomic, readwrite) NSInteger lastMoveSelectionCost;
@property (nonatomic, readwrite) NSInteger lastMoveMatchPoints;
@property (nonatomic, readwrite) NSArray *cardsInLastMatch;


@end

@implementation CardMatchingGame

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
    
    self.cardMatchCount = matchCount;
    
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
    self.lastMoveSelectionCost = 0;
    self.lastMoveMatchPoints = 0;
    self.cardsInLastMatch = nil;
    
    if (!card.isMatched)
    {
        if (card.isChosen)
        {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        }
        else
        {
            int matchScore = 0;
            self.lastMoveSelectionCost = -1*COST_TO_CHOOSE;

            if ([self.chosenCards count] == self.cardMatchCount - 1)
            {
                self.cardsInLastMatch = [self.chosenCards arrayByAddingObject:card];
                
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
                    self.lastMoveMatchPoints = (int) (matchScore * MATCH_BONUS / (self.cardMatchCount/BASE_POINT_MULTIPLIER));
                    card.matched = YES;
                    for (Card *matchedCard in self.chosenCards)
                    {
                        matchedCard.matched = YES;
                    }
                    [self.chosenCards removeAllObjects];
                }
                else
                {
                    self.lastMoveMatchPoints = -1 * ((int) (MISMATCH_PENALTY * (self.cardMatchCount/BASE_POINT_MULTIPLIER)));
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

            card.chosen = YES;
        }
    }
    self.score += self.lastMoveSelectionCost;
    self.score += self.lastMoveMatchPoints;
}


- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
@end
