//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Johan Henkens on 12/17/13.
//  Copyright (c) 2013 Johan Henkens. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        for (int count = 0; count < 3; count++)
        {
            for (int color = 0; color < 3; color++)
            {
                for (int fill = 0; fill < 3; fill++)
                {
                    for (int shape = 0; shape < 3; shape++)
                    {
                        SetCard *card = [[SetCard alloc] initWithFillNumber:fill
                                                                countNumber:count
                                                                colorNumber:color
                                                                shapeNumber:shape];
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
