//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Johan Henkens on 11/27/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//
//  Abstract Class

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

//  Abstract Method
- (Deck *)createDeck;

- (NSAttributedString *)descriptionForSelectionOfCard:(Card *) card
                               costToSelect:(NSInteger) cost;
- (NSAttributedString *)descriptionForUnselectionOfCard:(Card *) card
                               costToUnselect:(NSInteger) cost;
- (NSAttributedString *)descriptionForIncorrectMatchOfCards:(NSArray *)cards
                               incorrectMatchCost:(NSInteger) cost;
- (NSAttributedString *)descriptionForCorrectMatchOfCards:(NSArray *)cards
                                  pointsAwarded:(NSInteger) cost;
- (NSAttributedString *)gameStartedDescription:(NSUInteger) matchCount;

@end
