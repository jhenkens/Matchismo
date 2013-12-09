//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Johan Henkens on 11/27/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[CardGameViewController titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[CardGameViewController backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

+ (NSString *)titleForCard:(Card *)card
{
    if (card.isChosen)
    {
        return card.contents;
    } else
    {
        return @"";
    }
}

+ (UIImage *)backgroundImageForCard:(Card *)card
{
    if (card.isChosen)
    {
        return [UIImage imageNamed:@"cardfront"];
    }
    else
    {
        return [UIImage imageNamed:@"cardback"];
    }
}

@end
