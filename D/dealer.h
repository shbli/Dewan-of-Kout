#ifndef DEALER_H
#define DEALER_H

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#include "card.h"
#include "QList.h"
#include "global_keys.h"
#import "player.h"
#import "numbers.h"
#import "bedinfolayer.h"
#import "fadeDel.h"
#import "gameover.h"
#import "hintbutton.h"
#include "math.h"

#define pi 3.1415926
#define degtorad pi/180
#define radtodeg 180/pi

#define qreal float
#define cardsOffset 0.2
#define z_start_value 30
#define eatCardZ 100
#define eatScale 4
#define any_info_z_level 600
#define force true
#define dealCarddownScale 2.5

@class card_layer;
@class callmenu;

//this struct is used to record team info
struct team {
    //team id
    int id;
    //team total score
    int score;
    //team current eats
    short int eats;
    //team eating point, where the want to keep their eats
    CGPoint point;
    //display label, this will be used to display total score each time total score changes
    numbers* score_label;
    //team bed chance
    float chance;
};

//mini state machine, so the whole state of a game can be knowen by the dealer at anytime
enum Dealer_state {
    pauseState,
    dealingState,
    beddingState,
    playingState,
    gameOverState
};

struct bedding {
    //bedding amount
    short int amout;
    // save the suite of the bedding
    Card::cardType suite;
    //bedding team id
    int team;
    //player id
    short int playerID;
    //bed layer to show the info
    bedinfolayer* bedLayer;
};

class Player;

@interface dealer : CCLayer {
    hintbutton* hintButtonLayer;
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    CCLayer* iconsLayer;
//    //diffculty of computer players
    int compDiffculty;
    int numOfPlayer;
    int bedders_round_count;
    //saves game bedding information
    bedding bed;
    //gaid max
    int totalGaid;
    QList table_cards;
    //find a card at table, if valu is 0, it will try to find any card
    //save team info
    team *teams;
    int theWinner;
    QList cards;
    Player *players;
    float gameSpeed;
    callmenu* menu;
    Dealer_state currentState;
    Dealer_state oldState;
    //this is set true when game ends
    bool gameEnd;
    //show's when a team wins or lost
    CCSprite* winMessage;
    //saves the eating team id
    short int eating_team;
    card_layer *cardToDeal;
    //all the players are saved in here
    //total number of players
    qreal backGroundHeight;
    int cardPos;
    int PlayerTurn;
    int player_id_to_hand_card;
    long long currentDegree;
    

}

@property (nonatomic,retain) CCLayer* iconsLayer;
@property int numOfPlayer;
@property QList table_cards;
@property QList cards;
@property bedding bed;
@property (nonatomic,retain) callmenu* menu;
@property int compDiffculty;
@property int bedders_round_count;
@property float gameSpeed;
- (void) play_second_sound;
- (team*) teams:(int) teamID;
- (Player*) players:(int) playerID;
-(id) initWithTut:(BOOL) tuturial scoreH:(float) scoreH gaid:(int) gaidMax speed:(int) speed diffcult:(int) difficult parent:(CCNode*) father;
- (qreal) anyCardWidth;
- (card_layer*) anyCard;
- (void) dealcards;
- (void) dealNextCard;
//this is to randomize the cards, in step 2, the real dealing comes,step 2 is private as it is only to be used by this methode
- (void) hideCallMenu_2;
- (void) NextPlayerTurn;
- (void) check_who_ate;
// returns any card width, as all cards are equal
//clean up the table
- (void) cleanTable;
//this is the second step
- (void) winMessageStep2;
//pause the game
- (void) pauseGame;
//continue the game
- (void) contGame;
//change the state, this to remove the hassel, automatically saves the old state
- (void) changeState:(Dealer_state) newState;
//- (void) startDealing;
- (void) dealcardsStep2;

- (void) startDealing;
- (float) resizeToW:(int) newiWidth;
- (int) findAtTable:(Card::cardType) cardtype val: (int) cardValu;
- (void) showCallMenu : (bool) call;
- (void) hideCallMenu;
//check if there's a winner to end the current game and start a new one
- (bool) check_winner;
- (void) nicer_cards;
- (int) findWithDealer:(Card::cardType) cardtype val: (int) cardValu;
- (void) resetAllPlayerTurn;
- (int) opposite_team : (int) idd;
//this is used to find the largest card on the table, returns it's #num used in the list "table_cardrs"
- (int) findLargestOnTable;
- (void) player_0_throw_card;
- (void) createHintButton;
- (void) hintButtonClicked;
-(void) flashHints;
-(void) stopFlashingHints;
-(void) flashBedderAgain;
- (void) rotateAllCards;
- (void) rotateAllCards2;
-(void) movecardsnextToPlayer:(int) playerID;
@end

#endif
