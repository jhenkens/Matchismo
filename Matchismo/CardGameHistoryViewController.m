//
//  CardGameHistoryViewController.m
//  Matchismo
//
//  Created by Johan Henkens on 12/17/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "CardGameHistoryViewController.h"

@interface CardGameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *previousMovesTextView;

@end

@implementation CardGameHistoryViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.previousMovesTextView setAttributedText:self.historyAttributedstring];
}

@end
