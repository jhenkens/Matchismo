//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Johan Henkens on 11/27/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *previousMoveLabel;
@property (weak, nonatomic) IBOutlet UISlider *previousMoveSlider;

@property (strong, nonatomic) NSMutableArray *previousMoves;

@end

@implementation CardGameViewController

//  Abstract methods
- (Deck *)createDeck
{
    return nil;
}

- (NSAttributedString *)descriptionForSelectionOfCard:(Card *) card
                                         costToSelect:(NSInteger) cost
{
    return nil;
}
- (NSAttributedString *)descriptionForUnselectionOfCard:(Card *) card
                                         costToUnselect:(NSInteger) cost
{
    return nil;
}
- (NSAttributedString *)descriptionForIncorrectMatchOfCards:(NSArray *)cards
                                         incorrectMatchCost:(NSInteger) cost
{
    return nil;
}
- (NSAttributedString *)descriptionForCorrectMatchOfCards:(NSArray *)cards
                                            pointsAwarded:(NSInteger) cost
{
    return nil;
}
- (NSAttributedString *)gameStartedDescription:(NSUInteger) matchCount
{
    return nil;
}
//  Non-abstract method
- (NSMutableArray *)previousMoves
{
    if (!_previousMoves){
        _previousMoves = [[NSMutableArray alloc] init];
        [self addGameStartedDescription];
    }
    return _previousMoves;
}

- (IBAction)resetGame:(UIButton *)sender
{
    [self resetGame];
}


- (void)resetGame
{
    [self setGame: [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                     usingDeck:[self createDeck]
                                                withMatchCount:[self.modeSelector selectedSegmentIndex] + 2]];
    [self.modeSelector setEnabled:YES];
    self.previousMoves = nil;
    [self updateUI];
}

- (IBAction)toggleMatchCount:(UISegmentedControl *)sender
{
    [self resetGame];
}

- (IBAction)changePreviousMoveSlider:(UISlider *)sender {
    int position = lroundl([self.previousMoveSlider value]);
    [self.previousMoveSlider setValue:position animated:NO];
    [self updatePreviousMoveLabel];

}

- (void)updatePreviousMoveLabel
{
    if ([self.previousMoves count])
    {
        [self.previousMoveLabel setAttributedText:[self.previousMoves objectAtIndex:([self.previousMoveSlider value] -1)]];
    }
    //If not at the end of the slider, set it to dark gray.
    if ([self.previousMoveSlider value] != [self.previousMoveSlider maximumValue])
    {
        [self.previousMoveLabel setTextColor:[UIColor darkGrayColor]];
    }
    //otherwise, set it to the dark text color
    else
    {
        [self.previousMoveLabel setTextColor:[UIColor darkTextColor]];
    }
}

- (void)updateSlider
{
    if ([self.previousMoves count] > 1)
    {
        [self enableSlider];
    }
    else
    {
        [self disableSlider];
    }
}

- (void)disableSlider
{
    [self.previousMoveSlider setMinimumValue:0];
    [self.previousMoveSlider setMaximumValue:1];
    [self.previousMoveSlider setValue:1 animated:NO];
    [self.previousMoveSlider setEnabled:NO];
}

- (void)enableSlider
{
    [self.previousMoveSlider setMinimumValue:1];
    [self.previousMoveSlider setMaximumValue:([self.previousMoves count])];
    [self.previousMoveSlider setValue:[self.previousMoveSlider maximumValue] animated:NO];
    [self.previousMoveSlider setEnabled:YES];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[self createDeck]];
    return _game;
}

- (void)addGameStartedDescription
{
    NSAttributedString *description = [self gameStartedDescription:[self.game cardMatchCount]];
    if (description)
    {
        [self.previousMoves addObject:description];
    }
}

- (void)addDescriptionForSelectionAtIndex:(NSUInteger) index
{
    NSAttributedString *description = nil;
    if ([self.game cardAtIndex:index].chosen)
    {
        description = [self descriptionForSelectionOfCard:[self.game cardAtIndex:index] costToSelect:[self.game lastMoveSelectionCost]];
    }
    else
    {
        description = [self descriptionForUnselectionOfCard:[self.game cardAtIndex:index] costToUnselect:[self.game lastMoveSelectionCost]];
    }
    if (description)
    {
        [self.previousMoves addObject:description];
    }
    
    description = nil;
    
    if ([self.game cardsInLastMatch])
    {
        if ([self.game lastMoveMatchPoints] > 0)
        {
            description = [self descriptionForCorrectMatchOfCards:[self.game cardsInLastMatch] pointsAwarded:[self.game lastMoveMatchPoints]];
        }
        else
        {
            description = [self descriptionForIncorrectMatchOfCards:[self.game cardsInLastMatch] incorrectMatchCost:[self.game lastMoveMatchPoints]];
        }
    }
    
    if (description)
    {
        [self.previousMoves addObject:description];
    }
    
}


- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self addDescriptionForSelectionAtIndex:chosenButtonIndex];
    [self.modeSelector setEnabled:NO];
    [self updateUI];

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
    [self updateSlider];
    [self updatePreviousMoveLabel];
    
}

+ (NSString *)titleForCard:(Card *)card
{
    if (card.isChosen)
    {
        return card.contents;
    }
    else
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
