#ifndef PLAYER_H
#define PLAYER_H

#define dealingSpeed 0.3
#define downScaleComputerPlayersCards 2.8
//#define downScaleComputerPlayersCards 1.5
//enable unlimited fast testing
#define infiteMode 0
#define qreal float
#include "CGPointExtension.h"
#include "QList.h"
#include "card_layer.h"
#include "intell_controll.h"
#include "numbers.h"

@class dealer;

//class intell_controll;

class Player
{
public:
    
    void takeCardFromDealer(card_layer *recived_card);
    Player();
    ~Player();
    //this position holds the center card position
    CGPoint centerCardPos;
    //this is to hold the center card rotation
    float centerCardRotation;
    //this position holds the play card position
    CGPoint playCardPos;
    //this is to hold the center card rotation
    float playCardRotation;
    //this is pointer to the dealer, static because players in a game all share the same dealer
    static dealer* gameDealer;
    static float originalCardScale;
    int cards_count();
    //saves player id
    short int pid;
    bool setting_right();
    bool setting_down();
    bool setting_up();
    bool setting_left();
    void play_card();
    void show_tut_message();
    void hide_tut_message();
    void clear_hand();
    //ask the player how much he can bed
    int bed(bool forced = false);
    void speech(int speechText);
    CCSprite* icon;
    CCSprite *UnderIconLighter;
    bool contFlashing;
    CCSprite* tutMessageSprite;
    //not static, specific to each player
    int toPlay;
    static int findLargestOnTable();
    void recievedTouch(CGPoint touchPos);
    void touchEnded(CGPoint touchPos);
    intell_controll ai_unit;
    static float myTeamChange(int sid);
    static int compDiffculty();
    static int bed_team();
    static int bedders_round_count();
    static int numOfPlayer();
    static int bed_amout();
    static Card* table_cards_at(int i);
    static Card::cardType bed_suite();
    static int findAtTable(Card::cardType cardtype, int cardValu = 0);
    static int table_cards_size();
    static int bed_playerID();
    static Player* players(int i);
    static int cards_size();
    static Card* cards_at(int i);
    int myHandcards_size();
    bool dontHave(Card::cardType);
    Card* myHandcards_at(int i);
    static int team_eats(int id);
    static int opposite_team(int id);
    void rearrange_cards();
    void deleteMessageBox();
    void throw_card();
    void HideSpeechLayer();
    void orgnize_cards(float time = 1);
    void play_second_sound();
    static CGPoint pixToPoint(float x, float y);
    QList myHandCards;
    void flashHintCard();
    void createPlayerUnnderIconLighter();
    void startFlashingUnderIcon();
    void flashUnderIcon();
    void stopFlashingUnderIcon();

private:
    //this function makes the player speech the recieved text
    bool allowed(int cardID,bool dim = false);
    void dimAllNotAllowed();
    void undimAll();
    int selectedID;
    CGPoint selectedOrigPos;
    bool selectionMade;
    numbers* speechBox;
    bool preperToReArrange;
    bool arrangeType(QList *tempList,Card::cardType cardtype);
    void CreatSpeechLayer();
    bool speechLayerCreated;
};

#endif // PLAYER_H
