#ifndef DEALER_MM
#define DEALER_MM

#import "dealer.h"
#import "card_layer.h"
#import "callmenu.h"

#include <stdlib.h>
#define qrand arc4random
#define qreal float

@implementation dealer

@synthesize numOfPlayer;
@synthesize bed;
@synthesize menu;
@synthesize table_cards;
@synthesize cards;
@synthesize compDiffculty;
@synthesize bedders_round_count;
@synthesize gameSpeed;
@synthesize iconsLayer;
//important for every class that inherits from CCLayer

-(void) onEnter {
    // called right after a node's init methode is called.
    // If using CCTransitionScene: called when the transition begins.
    
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);

    [super onEnter];
}

-(void) onEnterTransitionDidFinish {
    // Called right after onEnter
    // If using a CCTransitionScence: called when the transition ended.
    [self setPositionInPixels:CGPointMake(winSizeInPixels.width/2, winSizeInPixels.height/2)];
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    [super onEnterTransitionDidFinish];
}

-(void) onExit {
    // called right before node's dealloc methode is called
    // If using a CCTransitionScence: called when the transition has ended
    
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    [super onExit];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    delete players;
    delete teams;
    table_cards.release();
    cards.release();
    for (int i = 0; i < numOfPlayer; i++) {
        players[i].myHandCards.release();
    }
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    
	// don't forget to call "super dealloc"
	
    [super dealloc];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff        
	}
	return self;
}


//end of important for every class that inherits from CCLayer

-(id) initWithTut:(BOOL) tuturial scoreH:(float) scoreH gaid:(int) gaidMax speed:(int) speed diffcult:(int) difficult parent:(CCNode*) father {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self setContentSize:CGSizeMake(0, 0)];
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff        
        menu = 0;
        numOfPlayer = 6;
        currentState = dealingState;
        compDiffculty = difficult;
        gameEnd = false;
        gameSpeed = speed;
        totalGaid = gaidMax;
        cardToDeal = 0;
        cardPos = 0;
        //taking screen size, saving it to variable called winSize
        backGroundHeight = winSize.width/origwallw*origwallh;
        NSString* temp;
        card_layer *newCard;
        qreal offset = 0;
        players = new Player[numOfPlayer];
        teams = new team[numOfTeams];
        currentState = pauseState;
        oldState = pauseState;
        //we'll creat the 13 club cards
        for (int i = 1; i <= 13; i++) {
            temp = [NSString stringWithFormat:@"%ic.png", i];
            if (i == 1) {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Club number:14];
            }
            else {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Club number:i];
            }
            cards.append(newCard);
            [newCard setPositionInPixels:CGPointMake(offset, offset)];
            offset-= cardsOffset;
            [newCard returnCardToDealer];
            [newCard setScale:[self resizeToW:[newCard cardWidth]/dealCarddownScale]];
            [self addChild:newCard];
        }
        //we'll creat the 13 diamond cards
        for (int i = 1; i <= 13; i++) {
            temp = [NSString stringWithFormat:@"%id.png", i];
            if (i == 1) {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Diamond number:14];
            }
            else {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Diamond number:i];
            }
            cards.append(newCard);
            [newCard setPositionInPixels:CGPointMake(offset, offset)];
            offset-= cardsOffset;
            [newCard returnCardToDealer];
            [newCard setScale:[self resizeToW:[newCard cardWidth]/dealCarddownScale]];
            [self addChild:newCard];

        }
        //we'll creat the 13 heart cards
        for (int i = 1; i <= 13; i++) {
            temp = [NSString stringWithFormat:@"%ih.png", i];
            CCLOG(@"%@",temp);
            if (i == 1) {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Heart number:14];
            }
            else {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Heart number:i];
            }
            cards.append(newCard);
            [newCard setPositionInPixels:CGPointMake(offset, offset)];
            offset-= cardsOffset;
            [newCard returnCardToDealer];
            [newCard setScale:[self resizeToW:[newCard cardWidth]/dealCarddownScale]];
            [self addChild:newCard];
        }
        //we'll creat the 13 Spade cards
        for (int i = 1; i <= 13; i++) {
            temp = [NSString stringWithFormat:@"%is.png", i];
            if (i == 1) {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Spade number:14];
            }
            else {
                newCard = [[card_layer alloc] initWithFile:temp type:Card::Spade number:i];
            }
            cards.append(newCard);
            [newCard setPositionInPixels:CGPointMake(offset, offset)];
            offset-= cardsOffset;
            [newCard returnCardToDealer];
            [newCard setScale:[self resizeToW:[newCard cardWidth]/dealCarddownScale]];
            [self addChild:newCard];
        }
        //finally we'll add the joker and black joker
        temp = [NSString stringWithFormat:@"rjoker.png"];
        newCard = [[card_layer alloc] initWithFile:temp type:Card::RedJoker number:15];
        cards.append(newCard);
        [newCard setPositionInPixels:CGPointMake(offset, offset)];
        offset-= cardsOffset;
        [newCard returnCardToDealer];
        [newCard setScale:[self resizeToW:[newCard cardWidth]/dealCarddownScale]];
        [self addChild:newCard];
        temp = [NSString stringWithFormat:@"bjoker.png"];
        newCard = [[card_layer alloc] initWithFile:temp type:Card::BlackJoker number:15];
        cards.append(newCard);
        [newCard setPositionInPixels:CGPointMake(offset, offset)];
        offset-= cardsOffset;
        [newCard returnCardToDealer];
        [newCard setScale:[self resizeToW:[newCard cardWidth]/dealCarddownScale]];
        [self addChild:newCard];
        
        //now we'll set players data
        Player::gameDealer = self;
        Player::originalCardScale = [self resizeToW:[newCard cardWidth]/dealCarddownScale];
        CCLOG(@"Original card scale = %f", Player::originalCardScale);
        qreal cardWidth = [newCard cardWidth] * Player::originalCardScale;
        
        /*
         WE HAVE TO SET THIS TO A RANDOM NUMBER
         */
        player_id_to_hand_card = 0;
        //first player info
        players[0].centerCardPos = CGPointMake(0, (cardWidth/3.5) - (winSizeInPixels.height/2) );
        players[0].centerCardRotation = -360;
        if (!tuturial) {
            players[0].ai_unit.human = true;
        } else {
            players[0].ai_unit.human = false;
        }
        players[0].playCardPos = CGPointMake( 0, - (50*Player::originalCardScale));
        players[0].playCardRotation = 150 + 180;
        players[0].playCardRotation *= -1;
        players[0].pid = 0;
        players[0].icon = [CCSprite spriteWithFile:@"main_callSpace.png"];
        [players[0].icon setScale:(winSizeInPixels.width/origwallw)];
        [self reorderChild:players[0].icon z:30];
        [players[0].icon setPositionInPixels:CGPointMake( winSizeInPixels.width/2 - ( 75 * Player::originalCardScale ),- winSizeInPixels.height/2 + ( ([players[0].icon contentSizeInPixels].height * [players[0].icon scale]) / 2.0 ))];
        [self addChild:players[0].icon];
        //after we've done with all humans
        cardWidth /= downScaleComputerPlayersCards;
        
        //second player info
        const float iconPosFactor = 1.5;
        players[1].centerCardPos = CGPointMake((winSizeInPixels.width/2) - (cardWidth/2), - (120*Player::originalCardScale) );
        players[1].centerCardRotation = 90.0;

        players[1].ai_unit.human = false;
        players[1].playCardPos = CGPointMake( 100 * (Player::originalCardScale), - (35*Player::originalCardScale));
        players[1].playCardRotation = 200 + 180;
        players[1].pid = 1;
        players[1].icon = [CCSprite spriteWithFile:@"grayTeamIcon.png"];
        [players[1].icon setScale:[players[0].icon scale]];
        [players[1].icon setRotation:-90];
        [players[1].icon setPositionInPixels:CGPointMake(players[1].centerCardPos.x - (([self anyCardWidth]*[[self anyCard] scale])/iconPosFactor) ,players[1].centerCardPos.y)];
        //third player info
        players[2].centerCardPos = CGPointMake((winSizeInPixels.width/2) - (cardWidth/2), (120*Player::originalCardScale));
        players[2].centerCardRotation = 90.0;
        
        players[2].ai_unit.human = false;
        players[2].playCardPos = CGPointMake( 100 * (Player::originalCardScale),(35*Player::originalCardScale));
        players[2].playCardRotation = 170 + 180;
        players[2].pid = 2;
        players[2].icon = [CCSprite spriteWithFile:@"redTeamIcon.png"];
        [players[2].icon setRotation:-90];
        [players[2].icon setScale:[players[0].icon scale]];
        [players[2].icon setPositionInPixels:CGPointMake(players[2].centerCardPos.x - (([self anyCardWidth]*[[self anyCard] scale])/iconPosFactor) ,players[2].centerCardPos.y)];
        
        //fourth player info
        players[3].centerCardPos = CGPointMake(0, - (cardWidth/2) + (winSizeInPixels.height/2));
        players[3].centerCardRotation = 180.0;

        players[3].ai_unit.human = false;
        players[3].playCardPos = CGPointMake( 0, (60*Player::originalCardScale));
        players[3].playCardRotation = 170 + 180;
        players[3].pid = 3;
        players[3].icon = [CCSprite spriteWithFile:@"grayTeamIcon.png"];
        [players[3].icon setRotation:180];
        [players[3].icon setScale:[players[0].icon scale]];
        [players[3].icon setPositionInPixels:CGPointMake(0,players[3].centerCardPos.y - (([self anyCardWidth]*[[self anyCard] scale])/iconPosFactor))];
        
        //fifth player info
        players[4].centerCardPos = CGPointMake(- (winSizeInPixels.width/2) + (cardWidth/2), (120*Player::originalCardScale) );
        players[4].centerCardRotation = 270.0;

        players[4].ai_unit.human = false;
        players[4].playCardPos = CGPointMake( - 100 * (Player::originalCardScale), (35*Player::originalCardScale));
        players[4].playCardRotation = 180 + 180;
        players[4].pid = 4;
        players[4].icon = [CCSprite spriteWithFile:@"redTeamIcon.png"];
        [players[4].icon setRotation:90];
        [players[4].icon setScale:[players[0].icon scale]];
        [players[4].icon setPositionInPixels:CGPointMake(players[4].centerCardPos.x + (([self anyCardWidth]*[[self anyCard] scale])/iconPosFactor) ,players[4].centerCardPos.y)];
        
        //sixth player info
        players[5].centerCardPos = CGPointMake(- (winSizeInPixels.width/2) + (cardWidth/2), - (120*Player::originalCardScale));
        players[5].centerCardRotation = 270.0;

        players[5].ai_unit.human = false;
        players[5].playCardPos = CGPointMake( - 100 * (Player::originalCardScale), - (35*Player::originalCardScale));
        players[5].playCardRotation = 150 + 180;
        players[5].pid = 5;
        players[5].icon = [CCSprite spriteWithFile:@"grayTeamIcon.png"];
        [players[5].icon setRotation:90];
        [players[5].icon setScale:[players[0].icon scale]];
        [players[5].icon setPositionInPixels:CGPointMake(players[5].centerCardPos.x + (([self anyCardWidth]*[[self anyCard] scale])/iconPosFactor) ,players[5].centerCardPos.y)];
        
        iconsLayer = [[CCLayer alloc] init];
        [father addChild:iconsLayer z:-1];
        [iconsLayer setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
        [iconsLayer setContentSize:CGSizeMake(0, 0)];
        for (int i = 1; i < numOfPlayer; i++) {
            [iconsLayer addChild:players[i].icon];
            players[i].centerCardRotation *= -1;
            players[i].playCardRotation *= -1;
        }
        PlayerTurn = 0;
        teams[myTeam].id = myTeam;
        teams[computerTeam].id = computerTeam;
        teams[myTeam].eats = 0;
        teams[computerTeam].eats = 0;
        teams[myTeam].score = 0;
        teams[computerTeam].score = 0;
        //created team Labels
        teams[myTeam].score_label = [[numbers alloc] init];
        teams[computerTeam].score_label = [[numbers alloc] init];
        [self addChild:teams[myTeam].score_label];
        [self addChild:teams[computerTeam].score_label];
        [teams[myTeam].score_label setNum:0];
        [teams[computerTeam].score_label setNum:0];
        //we'll create the positiong of teaming score labels and stuff
        numbers* myTeamLabel = teams[myTeam].score_label;
        [teams[myTeam].score_label setScale:(Player::originalCardScale)];
        [self reorderChild:teams[myTeam].score_label z:any_info_z_level];
        [teams[myTeam].score_label setPositionInPixels:CGPointMake(- (winSizeInPixels.width/2)+(45*2* [myTeamLabel scale] * 0.45),(winSizeInPixels.height/2) - (scoreH/2) + (9*[myTeamLabel scale]))];
        [teams[computerTeam].score_label setScale:[myTeamLabel scale]];
        [self reorderChild:teams[computerTeam].score_label z:any_info_z_level];
        [teams[computerTeam].score_label setPositionInPixels:CGPointMake((winSizeInPixels.width/2)-((45*2) * [myTeamLabel scale] * 0.45),(winSizeInPixels.height/2) - (scoreH/2) + (9*[myTeamLabel scale]))];
        //let's create the label that will show the score, this will start with opacity of 0 by defualt
        bed.bedLayer = [[bedinfolayer alloc] init];
        //let's set the positions, for team 0 and 1
        [bed.bedLayer setTeam0point:CGPointMake([myTeamLabel positionInPixels].x + (65 * [myTeamLabel scale]), [myTeamLabel positionInPixels].y)];
        [bed.bedLayer setTeam1point:CGPointMake([teams[computerTeam].score_label positionInPixels].x - (95 * [myTeamLabel scale]), [myTeamLabel positionInPixels].y)];
        [self addChild:bed.bedLayer];
        [self reorderChild:bed.bedLayer z:any_info_z_level];
        [bed.bedLayer setScale:[myTeamLabel scale]];
        //    //remove comment to fastly test the bed layer
        //    bed.bedLayer->showWith(9,Card::Heart,0);
        //these points, are where the first eat of each team is going to
        teams[myTeam].point = CGPointMake([bed.bedLayer team0point].x + (80 * [myTeamLabel scale]),[myTeamLabel positionInPixels].y);
        teams[computerTeam].point = CGPointMake([bed.bedLayer team1point].x - (30 * [myTeamLabel scale]),[myTeamLabel positionInPixels].y);
        theWinner = myTeam;
        [self setContentSize:CGSizeMake(0, 0)];
        [self createHintButton];
        
        players[0].createPlayerUnnderIconLighter();
        for (int i = 1; i < numOfPlayer; i++) {
            [iconsLayer reorderChild:players[i].icon z:1];
            players[i].createPlayerUnnderIconLighter();
        }
	}
	return self;
}

- (void) play_second_sound {
    players[0].play_second_sound();
}

- (team*) teams:(int) teamID {
    return &teams[teamID];
}
- (Player*) players:(int) playerID {
    return &players[playerID];
}

- (void) dealcards {
    //hide all speech layers
    for (int i = 0; i < numOfPlayer; i++) {
        players[i].HideSpeechLayer();
        players[i].stopFlashingUnderIcon();
    }
    self.isTouchEnabled = false;
    
    //we have to reest the eat values
    bedders_round_count = 0;
    teams[myTeam].eats = 0;
    teams[computerTeam].eats = 0;
    teams[myTeam].chance = 0;
    teams[computerTeam].chance = 0;
    //take all players cards
    for (int i = 0 ; i < numOfPlayer ; i++) {
        players[i].clear_hand();
    }
    cardPos = 0;
    //reset the bed
    bed.amout = 0;
    //chose a player frmo winning team to hand in the card
    do {
        player_id_to_hand_card = qrand() % numOfPlayer;
    } while (player_id_to_hand_card%numOfTeams != theWinner);
    //first we have to randomize the cards, then in step 2, we deal the cards
    
    card_layer* tempCard;
    //we'll creat a list
    QList to_random_cards;
    int selector;
    // we'll randomize our list 2 times, for better chance
    while (!cards.isEmpty()) {
        to_random_cards.append(cards.takeLast());
    }
    //we'll chose a random variable and insert that one into our older list
    for (int idx = to_random_cards.size(); idx > 0; idx--)
    {
        selector = (((qrand() % (idx))));
        cards.append(to_random_cards.takeAt(selector));
        tempCard = cards.last();
        [tempCard stopAllActions];
    }
    selector = 0;
    while (!cards.isEmpty()) {
        to_random_cards.append(cards.takeLast());
    }
    //we'll chose a random variable and insert that one into our older list
    for (int idx = to_random_cards.size(); idx > 0; idx--)
    {
        selector = (((qrand() % (idx))));
        cards.append(to_random_cards.takeAt(selector));
    }
    
    //nice the cards for a better chance, and more love for the game
    short int numOfCardsToNicer = qrand() % 3;
    for (int i = 0; i < numOfCardsToNicer; i++) {
        [self nicer_cards];
    }
    float gatherSpeed = 0.5;
    for (int i = 0; i < cards.size() ; i++) {
        tempCard = cards.at(i);
        [tempCard turnFaceDown:gatherSpeed];
        [tempCard returnCardToDealer];
        [tempCard setZ:z_start_value+i];
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:gatherSpeed angle:0] rate:4]];
//        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:gatherSpeed position:Player::pixToPoint(i*cardsOffset, i*cardsOffset)] rate:4]];
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:gatherSpeed scale:Player::originalCardScale/dealCarddownScale] rate:4]];
        
    }
    int DealerID = player_id_to_hand_card - 1;
    if (DealerID < 0) {
        DealerID = numOfPlayer - 1;
    }
    [self movecardsnextToPlayer:DealerID];
    [self resetAllPlayerTurn];
//    resetAllPlayerTurn();
    //change the state to dealing cards after some time
    [NSTimer scheduledTimerWithTimeInterval:gatherSpeed*1.1 target:self selector:@selector(startDealing) userInfo:nil repeats:NO];
    
    to_random_cards.release();
    
}
-(void) movecardsnextToPlayer:(int) playerID {
    float startSpeed = 0.1;
    float xpos = players[playerID].centerCardPos.x;
    float ypos = players[playerID].centerCardPos.y;
    float distance = 180 * Player::originalCardScale;
    if (players[playerID].setting_down()) {
        ypos += distance;
    } else if (players[playerID].setting_up()) {
        ypos -= distance;
    } else if (players[playerID].setting_left()) {
        xpos -= distance;
    } else {
        //anything else means setting right
        xpos += distance;
    }
    card_layer* tempCard;
    for (int i = 0; i < cards.size() ; i++) {
        tempCard = cards.at(i);
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:startSpeed position:Player::pixToPoint(xpos + (i*cardsOffset), ypos+ (i*cardsOffset))] rate:4]];
        startSpeed += 0.01;
    }
//    [NSTimer scheduledTimerWithTimeInterval:startSpeed/7.0 target:self selector:@selector(dealNextCard) userInfo:nil repeats:NO];
}
- (void) dealcardsStep2 {
    cardToDeal = cards.at(cardPos);
    if ([cardToDeal cardWithDealer]) {
        // if the coming card is not in the hand of any player, we'll hand it to nextplayer
        if (players[player_id_to_hand_card].cards_count() >= 9) {
            //in this case, let's switch to the next player
            player_id_to_hand_card++;
            if (player_id_to_hand_card >= numOfPlayer) {
                player_id_to_hand_card = 0;
            }
            PlayerTurn = player_id_to_hand_card + 1;
            if (PlayerTurn >= numOfPlayer) {
                PlayerTurn = 0;
            }
            //if we are switching to another player no need to wait, deal next card directly
        }
        //actually handing card to the player
        players[player_id_to_hand_card].takeCardFromDealer(cardToDeal);
        //this is to set the id of the card belonging to this player
        [cardToDeal giveCardToPlayer:player_id_to_hand_card];
        cardPos++;
        if (cardPos >= cards.size()) {
            cardPos = 0;
        }
        // if the coming card is not in the hand of any player, we'll hand it to nextplayer
        [self schedule:@selector(dealNextCard) interval:0.3/8.0];
    } else {
        //we'll start the fun, by letting players start bedding
        [self changeState:beddingState];
    }
    
}
- (void) dealNextCard {
    [self unschedule:@selector(dealNextCard)];
    if (currentState == dealingState) {
        [self dealcardsStep2];
    }
}
-(void) startDealing {
    if (currentState != pauseState || (currentState == pauseState && oldState == pauseState)) {
        [self changeState:dealingState];
    }
}

-(void) changeState:(Dealer_state)newState {
    //let's check if it was pause state
    //this takes care of changing the state
    oldState = currentState;
    currentState = newState;
    if (oldState == pauseState ) {
        //transition from pause
        if (!self.isTouchEnabled) {
            self.isTouchEnabled = true;
        }
    }
    if (currentState == pauseState ) {
        self.isTouchEnabled = false;
    } else if (currentState == playingState) {
        float speedFactor = 0.65;
        [NSTimer scheduledTimerWithTimeInterval:gameSpeed*speedFactor target:self selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
    } else if (currentState == beddingState) {
        float speedFactor = 0.65;
        [NSTimer scheduledTimerWithTimeInterval:gameSpeed*speedFactor target:self selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
    } else
        if (currentState == dealingState) {
            [self dealNextCard];
        } else if (currentState == gameOverState) {
            self.isTouchEnabled = false;
        }

}

- (float) resizeToW:(int) newiWidth {
    // resizing the elemnt while saving the aspect ratio of the elemnt
    float newWidth = newiWidth;
    newWidth *= (winSizeInPixels.width/origwallw);
    float startWidth = newiWidth;
    float newScaleX = newWidth/startWidth;
    return newScaleX;
}

- (qreal) anyCardWidth {
    card_layer* tempCard = cards.at(0);
    return [tempCard cardWidth];
}
- (card_layer*) anyCard {
    return cards.at(0);    
}

- (int) findAtTable:(Card::cardType) cardtype val: (int) cardValu {
    for (int i = 0; i < table_cards.size(); i++) {
        card_layer* tempCard = table_cards.at(i);
        if (cardValu == 0) {
            //search anycard of that number
            if ([tempCard cardInst]->typ == cardtype) {
                return i;
            }
            
        } else {
            //search that specific number
            if ([tempCard cardInst]->typ == cardtype && [tempCard cardInst]->cardNum == cardValu) {
                return i;
            }
        }
    }
    //this function should return none in case, no card found
    return Card::None;
}

- (int) findLargestOnTable {
    return intell_controll::findLargestOnTable();    
}

- (void) pauseGame {
    [self changeState:pauseState];
}

//continue the game
- (void) contGame {
    [self changeState:oldState];
}

- (void) nicer_cards {
    short int numOfCardsToNicer = qrand() % 9;
    short int withJokers = qrand() % 7;
    short int suit = qrand() % 4;
    Card::cardType suiteToNicer;
    if (suit == 0) {
        suiteToNicer = Card::Heart;
    } else if (suit == 1) {
        suiteToNicer = Card::Spade;
        
    } else if (suit == 2) {
        suiteToNicer = Card::Club;
    } else {
        suiteToNicer = Card::Diamond;
    }
    
    if (withJokers < 2) {
        cards.append(cards.takeAt([self findWithDealer:Card::BlackJoker val:0]));
    }
    if (withJokers < 1) {
        cards.append(cards.takeAt([self findWithDealer:Card::RedJoker val:0]));
    }
    for (int i = 0; i < numOfCardsToNicer; i++) {
        cards.append(cards.takeAt([self findWithDealer:suiteToNicer val:0]));
    }
    numOfCardsToNicer = qrand() % 100;
    for (int i = 0; i < numOfCardsToNicer; i++) {
        cards.append(cards.takeLast());
    }
}

- (int) findWithDealer:(Card::cardType) cardtype val: (int) cardValu {
    for (int i = 0; i < cards.size(); i++) {
        card_layer* tempCard = cards.at(i);
        if (cardValu == 0) {
            //search anycard of that number
            if ([tempCard cardInst]->typ == cardtype) {
                return i;
            }
            
        } else {
            //search that specific number
            if ([tempCard cardInst]->typ == cardtype && [tempCard cardInst]->cardNum == cardValu) {
                return i;
            }
        }
    }
    //this function should return none in case, no card found
    return Card::None;

}

- (void) check_who_ate {
    // here we shall find who ate the card, and add to his team eats one, using the function findLargetOnTable
    int largest_card_id = [self findLargestOnTable];
    card_layer* tempCard = table_cards.at(largest_card_id);
    PlayerTurn = [tempCard player_id_holding_card];
    eating_team = PlayerTurn%numOfTeams;
    //flashing the largest card on table, then cleaning the table and sending the cards to appropraite team
    //    table_cards.at(largest_card_id)->runSequence(Sequence::sequenceWithActions(action::fadeTo(0.25,0),action::fadeTo(0.25,100),action::FuncCall(this,SLOT(cleanTable())),NULL));
    float flashtime = 0.8;
    [tempCard flash:flashtime*gameSpeed WithTarget:self selector:@selector(cleanTable)];
}

- (bool) check_winner {
    bool retVal = false;
    if (teams[bed.team].eats >= bed.amout) {
        //game end, this team has won the match we should increase his score
        if (bed.amout < 9 && bed.amout > 4) {
            teams[bed.team].score += bed.amout;
        } else if (bed.amout == 9) {
            teams[bed.team].score += 36;
            if (teams[bed.team].score == 36) {
                //there's a chance of a bawan won
                if (teams[[self opposite_team:bed.team]].score == 0) {
                    gameEnd = true;
                }
            }
        } else {
            CCLOG(@"Error in bedding amount it's win and amount = %i",bed.amout);
        }
        //we have to set the text to new amount
        [teams[bed.team].score_label setNum:teams[bed.team].score];
        if (teams[bed.team].score > teams[[self opposite_team:bed.team]].score) {
            theWinner = bed.team;
        }
        if (!gameEnd) {
            //here we have to show a win
            int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
            if (langID == arabic) {
                if (bed.team == computerTeam) {
                    //let's show a sprite
                    winMessage = [CCSprite spriteWithFile:@"blue_won_ar.png"];
                } else {
                    winMessage = [CCSprite spriteWithFile:@"red_won_ar.png"];
                }
            } else {
                if (bed.team == computerTeam) {
                    //let's show a sprite
                    winMessage = [CCSprite spriteWithFile:@"blue_won_en.png"];
                } else {
                    winMessage = [CCSprite spriteWithFile:@"red_won_en.png"];
                }
            }
        }
        retVal = true;
    } else {
        if (teams[[self opposite_team:bed.team]].eats >= (10 - bed.amout)) {
            //bedding team has lost!!
            //we have to show a loss pic
            if (bed.amout < 10 && bed.amout > 4) {
                teams[[self opposite_team:bed.team]].score += (bed.amout * 2);
            } else {
//                qDebug() << "Error in bedding amount it's loss and amount = " << bed.amout;
            }
            //we have to set the text of oppenet to new text

            [teams[[self opposite_team:bed.team]].score_label setNum:(teams[[self opposite_team:bed.team]].score)];
            if (teams[bed.team].score < teams[[self opposite_team:bed.team]].score) {
                theWinner = [self opposite_team:bed.team];
            }
            if (!gameEnd) {
                //here we have to show a loss
                int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
                if (langID == arabic) {
                    if (bed.team == computerTeam) {
                        //let's show a sprite
                        winMessage = [CCSprite spriteWithFile:@"blue_los_ar.png"];
                    } else {
                        winMessage = [CCSprite spriteWithFile:@"red_los_ar.png"];
                    }
                } else {
                    if (bed.team == computerTeam) {
                        //let's show a sprite
                        winMessage = [CCSprite spriteWithFile:@"blue_los_en.png"];
                    } else {
                        winMessage = [CCSprite spriteWithFile:@"red_los_en.png"];
                    }
                }
            }
            retVal = true;
        }
    }
    if (retVal) {
        //here we have to check if game finished or not
        if (teams[myTeam].score >= totalGaid || teams[computerTeam].score >= totalGaid) {
            //some team has already won
            gameEnd = true;
        }
        //let's check if one team is half the score and other one is 0
        if (teams[computerTeam].score > (totalGaid/2) && teams[myTeam].score == 0.0) {
            gameEnd = true;
        }
        if (teams[myTeam].score > (totalGaid/2) && teams[computerTeam].score == 0.0) {
            gameEnd = true;
        }
    }
    if (retVal && !gameEnd) {
        //let's show that sprite
        [winMessage setOpacity:0];
        [winMessage setScale:Player::originalCardScale];
        [winMessage setPositionInPixels:CGPointMake(0, 700*Player::originalCardScale)];
        [winMessage runAction:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.5 opacity:255] rate:4]];
        [winMessage runAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, 0)] rate:4], nil]];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(winMessageStep2) userInfo:nil repeats:NO];
        [self addChild:winMessage];
        [winMessage.parent reorderChild:winMessage z:any_info_z_level];
    }
    return retVal;
}

- (int) opposite_team : (int) idd {
    if  (idd% numOfTeams == myTeam) {
        return computerTeam;
    }
    return myTeam;
}

- (void) winMessageStep2 {
    if (winMessage != 0) {
        
        [[fadeDel alloc] initWithToDel:winMessage parent:self action:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, 1000)] rate:4]];
        winMessage = 0;
    }
}

- (void) hideCallMenu_2 {
    [menu stopAllActions];
    [self removeChild:menu cleanup:YES];
    menu = 0;
    [self NextPlayerTurn];
}

- (void) resetAllPlayerTurn {
    for (int i = 0; i < numOfPlayer; i++) {
        players[i].ai_unit.tookTurn = false;
    }
}

- (void) cleanTable {
    [self resetAllPlayerTurn];
    CGPoint cardsPoint;
    int zLevel = eatCardZ;
    if (eating_team == computerTeam) {
        teams[computerTeam].eats++;
        zLevel += teams[computerTeam].eats;
        cardsPoint = teams[computerTeam].point;
        cardsPoint.x = (cardsPoint.x-(([self anyCardWidth]*(Player::originalCardScale/(eatScale*2)))*teams[computerTeam].eats));
    } else {
        teams[myTeam].eats++;
        zLevel += teams[myTeam].eats;
        cardsPoint = teams[myTeam].point;
        cardsPoint.x = (cardsPoint.x+(([self anyCardWidth ]*(Player::originalCardScale/(eatScale*2)))*teams[myTeam].eats));
    }
    float factor = 0.5;
    card_layer* tempCard;
    for (int i = 0; i< table_cards.size(); i++) {
        tempCard = table_cards.at(i);
        [tempCard turnFaceDown:factor];
        [tempCard returnCardToDealer];
        [tempCard setZ:zLevel];
        float newRotation = 0;
        newRotation -= [tempCard rotation];
        
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:factor angle:newRotation] rate:4]];
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:factor position:Player::pixToPoint(cardsPoint.x,cardsPoint.y)] rate:4]];
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:factor scale:Player::originalCardScale/eatScale] rate:4]];
    }
    table_cards.clear();
    if ([self check_winner]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"game_end.wav"];
        for (int i = 0; i < cards.size(); i++) {
            tempCard = cards.at(i);
            [tempCard stopAllActions];
        }
        [bed.bedLayer hide];
        if (gameEnd) {
            //the true or false parameter, indicates if it's a won or loss to show the appropiate message
            gameover *gameoverLayer;
            if (teams[myTeam].score >= teams[computerTeam].score) {
                //we won
                gameoverLayer = [[gameover alloc] initWithWin:true];
            } else {
                //we lost
                gameoverLayer = [[gameover alloc] initWithWin:false];
            }
            [gameoverLayer setPositionInPixels:CGPointMake(0,-winSizeInPixels.height)];
            [gameoverLayer setScale:winSizeInPixels.width/origwallw];
            [gameoverLayer runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:factor position:Player::pixToPoint(0,- (winSizeInPixels.height/2) + (100*(winSizeInPixels.width/origwallw)))] rate:4]];
            [self addChild:gameoverLayer z:590];
            self.isTouchEnabled = false;
            [self changeState:gameOverState];
            [self rotateAllCards];
        } else {
            [self dealcards];
        }
    } else {
        [[SimpleAudioEngine sharedEngine] playEffect:@"clean_up.wav"];
        [NSTimer scheduledTimerWithTimeInterval:gameSpeed*factor target:self selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
    }
    
}

- (void) showCallMenu : (bool) call {
    if (menu == 0) {
        menu = [[callmenu alloc] initWithDealer:self playerID:0 call:call];
//        [menu runAction:[CCFadeTo actionWithDuration:0 opacity:0]];
        [self addChild:menu z:any_info_z_level tag:callMenuTag];
//        [menu runAction:[CCFadeTo actionWithDuration:0.5 opacity:255]];

    }
}

- (void) NextPlayerTurn {
    float speedFactor = 0.65;
    if (currentState == playingState) {
        //if he finished his turn, go to next player, this is to make sure all players get their turn to play
        if (players[PlayerTurn].ai_unit.tookTurn) {
            PlayerTurn++;
            if (PlayerTurn >= numOfPlayer) {
                PlayerTurn = 0;
            }
        }
        
        if (table_cards.size() >= numOfPlayer) {
            //here we should check which teams ate the cards, and move it to their place
            [NSTimer scheduledTimerWithTimeInterval:1.1*0.5 target:self selector:@selector(check_who_ate) userInfo:nil repeats:NO];
        } else {
            if (players[PlayerTurn].cards_count() <= 0) {
                //we reached the state that everyone has played his cards, so we'll just deal the cards again
                [NSTimer scheduledTimerWithTimeInterval:1.1*gameSpeed target:self selector:@selector(dealcards) userInfo:nil repeats:NO];
            } else {
                players[PlayerTurn].pid = PlayerTurn;
                players[PlayerTurn].play_card();
            }
            
        }
    } else {
        //it's the bedding state then
        if (currentState == beddingState) {
            int tempNext = PlayerTurn;
            tempNext++;
            if (tempNext >= numOfPlayer) {
                tempNext = 0;
            }
            if (players[PlayerTurn].ai_unit.tookTurn) {
                PlayerTurn = tempNext;
                bedders_round_count++;
            }
            
            if (bedders_round_count >= numOfPlayer) {
                PlayerTurn = bed.playerID;
                if (bed.suite == Card::None) {
                    //this means, we are showing the call menu, but with suite chooser, that why we are putting it to false
                    [self showCallMenu:false];
                } else {
                    [bed.bedLayer showWith:bed.amout type:bed.suite teamID:bed.team];
                    self.isTouchEnabled = true;
                    [self resetAllPlayerTurn];
                    [self changeState:playingState];
                    //hide all other players numbers
                    for (int i = 0; i < numOfPlayer; i++) {
                        if (i != bed.playerID) {
                            //not the player that is bedding
                            players[i].HideSpeechLayer();
                        } else {
                            players[i].startFlashingUnderIcon();
                        }
                    }
                }
            } else {
                if  (bed.amout < 9) {
                    if (bedders_round_count >= numOfPlayer ) {
                        if (players[PlayerTurn].ai_unit.human) {
                        [self showCallMenu:true];
                        } else {
                            players[PlayerTurn].bed(force);
                        }
                    } else {
                        if (players[PlayerTurn].ai_unit.human && !infiteMode) {
                            [self showCallMenu:true];
                        } else {
                            players[PlayerTurn].bed();
                        }
                    }
                    if (!players[PlayerTurn].ai_unit.human || infiteMode) {
                        if (players[tempNext].ai_unit.human) {
                            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
                        } else {
                            [NSTimer scheduledTimerWithTimeInterval:speedFactor target:self selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
                        }
                    }
                    
                } else {
                    //we are done the bedding, we should go on, so we'll set the count to the end
                    bedders_round_count = numOfPlayer;
                    [self NextPlayerTurn];
                }
            }
        }
    }
    
    
}

- (void) hideCallMenu {
    if (menu != 0 ) {
        [menu stopAllActions];
        [menu runAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(1000, 0)] rate:4],[CCCallFunc actionWithTarget:self selector:@selector(hideCallMenu_2)], nil]];
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    //converting it to pixels
    touchPos.x = touchPos.x * (winSizeInPixels.width/winSize.width);    
    touchPos.y = touchPos.y * (winSizeInPixels.width/winSize.width);    
    if (players[0].ai_unit.human) {
        //this will only get called if a human is playing the rule of player 0
        players[0].touchEnded(touchPos);
    } else {
        players[0].hide_tut_message();
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    //converting it to pixels
    touchPos.x = touchPos.x * (winSizeInPixels.width/winSize.width);    
    touchPos.y = touchPos.y * (winSizeInPixels.width/winSize.width);    
    if (players[0].ai_unit.human) {
        //this will only get called if a human is playing the rule of player 0
        players[0].recievedTouch(touchPos);
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    //converting it to pixels
    touchPos.x = touchPos.x * (winSizeInPixels.width/winSize.width);    
    touchPos.y = touchPos.y * (winSizeInPixels.width/winSize.width);    
    if (players[0].ai_unit.human) {
        //this will only get called if a human is playing the rule of player 0
        players[0].recievedTouch(touchPos);
    }

}

- (void) player_0_throw_card {
    players[0].throw_card();
}

- (void) hintButtonClicked {
    players[0].flashHintCard();
}
- (void) createHintButton {
    hintButtonLayer = [[hintbutton alloc] init];
    [self addChild:hintButtonLayer];
    [hintButtonLayer setScale:winSizeInPixels.width/origwallw];
    [self reorderChild:hintButtonLayer z:1000];
    [hintButtonLayer setPositionInPixels:CGPointMake( (-winSizeInPixels.width/2) + (115*Player::originalCardScale),(-winSizeInPixels.height/2)+(45*Player::originalCardScale))];
}

-(void) flashHints {
    [hintButtonLayer flash:0.5];
}

-(void) stopFlashingHints {
    [hintButtonLayer stopFlashing];
}
-(void) flashBedderAgain {
    players[bed.playerID].flashUnderIcon();
}


- (void) rotateAllCards {
    
    int startx = 50;
    int starty = 50;
    float distance = winSizeInPixels.height/3;
    float time = 1;
    long long startingDegree = 0;
    long long increaseDegreeBy = (360*2) / (cards.size());
    card_layer* tempCard;
    for (int i = 0; i < cards.size(); i++) {
        //        for (int j = 0; j < numOfLines; j++) {
        //            sprites[id]->runAction(action::easeinout(action::moveTo(time,base + startx*i,base + starty*j),5));
        startx =  distance * cos(startingDegree*degtorad);
        starty =  distance * sin(startingDegree*degtorad);
        tempCard = cards.at(i);
        [tempCard turnFaceUp:time];
        [tempCard runAction:[CCEaseBackInOut actionWithAction:[CCMoveTo actionWithDuration:time position:Player::pixToPoint(startx, starty)]]];
        [tempCard runAction:[CCEaseBackInOut actionWithAction:[CCScaleTo actionWithDuration:time scale:Player::originalCardScale/dealCarddownScale]]];
        [tempCard runAction:[CCEaseBackInOut actionWithAction:[CCRotateTo actionWithDuration:time angle:0]]];
        [tempCard setZ:i];
        startingDegree += increaseDegreeBy;
        time += 0.01;
        //        }
    }
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(rotateAllCards2) userInfo:nil repeats:NO];
}

- (void) rotateAllCards2 {
    [self scheduleUpdate];
}


-(void) update:(ccTime)delta{
    int startx = 50;
    int starty = 50;
    float distance = winSizeInPixels.height/3;
    float time = 1;
    currentDegree += delta * 80;
    if (currentDegree > 360) {
        currentDegree -= 360;
    }
    long long startingDegree = currentDegree;
    long long increaseDegreeBy = (360*2) / (cards.size());
    card_layer* tempCard;
    for (int i = 0; i < cards.size(); i++) {
        startx =  distance * cos(startingDegree*degtorad);
        starty =  distance * sin(startingDegree*degtorad);
        tempCard = cards.at(i);
        [tempCard setPositionInPixels:CGPointMake(startx,starty)];
        startingDegree += increaseDegreeBy;
        time += 0.01;
    }
}

@end

#endif
