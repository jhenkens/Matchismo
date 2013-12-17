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
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *previousMoveLabel;
@property (weak, nonatomic) IBOutlet UISlider *previousMoveSlider;

@end

@implementation CardGameViewController

- (IBAction)resetGame:(UIButton *)sender
{
    [self.modeSelector setEnabled:YES];
    [self resetGame];
}

- (void)resetGame
{
    [self setGame: [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                     usingDeck:[self createDeck]
                                                withMatchCount:[self.modeSelector selectedSegmentIndex] + 2]];
    [self updateUI];
}

- (IBAction)toggleMatchCount:(UISegmentedControl *)sender
{
    [self resetGame];
}

- (IBAction)changePreviousMoveSlider:(UISlider *)sender {
    int position = roundl([sender value]);
    [sender setValue:position animated:NO];
    [self.previousMoveLabel setText:[self.game previousMoveDescriptions][position]];
    if (position != roundl([sender maximumValue]))
    {
        [self.previousMoveLabel setTextColor:[UIColor darkGrayColor]];
    }
    else
    {
        [self.previousMoveLabel setTextColor:[UIColor darkTextColor]];
    }

}

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
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    [self.modeSelector setEnabled:NO];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[CardGameViewController titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[CardGameViewController backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long) self.game.score];
    NSArray* previousMoveDescriptions = [self.game previousMoveDescriptions];
    if ([previousMoveDescriptions count] > 1)
    {
        [self.previousMoveSlider setMinimumValue:0];
        [self.previousMoveSlider setMaximumValue:([previousMoveDescriptions count]-1)];
        [self.previousMoveSlider setValue:[self.previousMoveSlider maximumValue] animated:YES];
        [self.previousMoveSlider setEnabled:YES];
    }
    else
    {
        [self.previousMoveSlider setMinimumValue:0];
        [self.previousMoveSlider setMaximumValue:1];
        [self.previousMoveSlider setValue:1 animated:YES];
        [self.previousMoveSlider setEnabled:NO];
    }
    [self.previousMoveLabel setText:previousMoveDescriptions[[previousMoveDescriptions count]-1]];
    [self.previousMoveLabel setTextColor:[UIColor darkTextColor]];
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
