//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Johan Henkens on 11/29/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                         usingDeck:(Deck *)deck;

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)matchCount;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;


@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSUInteger cardMatchCount;
@property (nonatomic, readonly) NSInteger lastMoveSelectionCost;
@property (nonatomic, readonly) NSInteger lastMoveMatchPoints;
@property (nonatomic, readonly) NSArray *cardsInLastMatch;


@end
