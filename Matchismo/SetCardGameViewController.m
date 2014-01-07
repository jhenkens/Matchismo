//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Johan Henkens on 12/17/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}


- (NSAttributedString *)descriptionForSelectionOfCard:(Card *) card
                                         costToSelect:(NSInteger) cost
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Selected %@. %d point selection cost.", [card contents], cost]];
}
- (NSAttributedString *)descriptionForUnselectionOfCard:(Card *) card
                                         costToUnselect:(NSInteger) cost
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Unselected %@.", [card contents]]];
}
- (NSAttributedString *)descriptionForIncorrectMatchOfCards:(NSArray *)cards
                                         incorrectMatchCost:(NSInteger) cost
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ don't match! %d point penalty!", [cards componentsJoinedByString:@" "], cost]];
}
- (NSAttributedString *)descriptionForCorrectMatchOfCards:(NSArray *)cards
                                            pointsAwarded:(NSInteger) cost
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ match! %d points awarded!", [cards componentsJoinedByString:@" "], cost]];
}
- (NSAttributedString *)gameStartedDescription:(NSUInteger) matchCount
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Game started with match size %d!", matchCount]];
}

@end
